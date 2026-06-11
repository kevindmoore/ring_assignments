import 'package:signals/signals.dart';

import 'assignment_engine.dart';
import 'domain.dart';

final divisionsSignal = signal<List<Division>>(sampleDivisions);
final competitorsSignal = signal<List<Competitor>>([]);
final judgesSignal = signal<List<Judge>>([]);
final generatedManualAssignmentsSignal = signal<List<GeneratedRingAssignment>>(
  [],
);
final ringCountSignal = signal(4);
final rankOrderSignal = signal<List<BeltRank>>(_defaultRankOrder);
const _defaultRankOrder = [
  BeltRank.firstDegree,
  BeltRank.secondDegree,
  BeltRank.thirdDegree,
  BeltRank.fourthDegree,
  BeltRank.fifthDegree,
  BeltRank.sixthDegree,
  BeltRank.seventhDegree,
  BeltRank.eighthDegree,
  BeltRank.ninthDegree,
  BeltRank.white,
  BeltRank.orange,
  BeltRank.yellow,
  BeltRank.camo,
  BeltRank.green,
  BeltRank.purple,
  BeltRank.blue,
  BeltRank.brown,
  BeltRank.red,
];
final manualRingSetupsSignal = signal<List<ManualRingSetup>>([
  const ManualRingSetup(
    id: 'ring-1',
    ringNumber: 1,
    ageGroup: AgeGroup.youthNineTen,
  ),
  const ManualRingSetup(
    id: 'ring-2',
    ringNumber: 2,
    ageGroup: AgeGroup.teenThirteenFourteen,
  ),
]);

final generatedRingsSignal = computed(
  () => buildRingsFromDivisions(divisionsSignal.value),
);

final ringAssignmentsSignal = computed(
  () => autoAssignRings(
    rings: generatedRingsSignal.value,
    judges: judgesSignal.value,
  ),
);

final assignmentProblemsSignal = computed(
  () => ringAssignmentsSignal.value
      .expand((assignment) => assignment.results)
      .where((result) => result.severity != AssignmentSeverity.ok)
      .toList(),
);

void setRingCount(int count) {
  if (count < 1) {
    return;
  }

  ringCountSignal.value = count;
  generatedManualAssignmentsSignal.value = const [];
}

void moveRankOrder(BeltRank rank, int direction) {
  final ranks = rankOrderSignal.value.toList();
  final currentIndex = ranks.indexOf(rank);
  final newIndex = currentIndex + direction;
  if (currentIndex == -1 || newIndex < 0 || newIndex >= ranks.length) {
    return;
  }

  final movedRank = ranks.removeAt(currentIndex);
  ranks.insert(newIndex, movedRank);
  rankOrderSignal.value = ranks;
}

void saveManualRingSetup(ManualRingSetup setup) {
  final setups = manualRingSetupsSignal.value
      .where(
        (item) => item.id == setup.id || item.ringNumber != setup.ringNumber,
      )
      .toList();
  final existingIndex = setups.indexWhere((item) => item.id == setup.id);

  if (existingIndex == -1) {
    setups.add(setup);
  } else {
    setups[existingIndex] = setup;
  }

  setups.sort((left, right) => left.ringNumber.compareTo(right.ringNumber));
  manualRingSetupsSignal.value = setups;

  if (setup.ringNumber > ringCountSignal.value) {
    ringCountSignal.value = setup.ringNumber;
  }
}

void saveCompetitor(Competitor competitor) {
  final competitors = competitorsSignal.value.toList();
  final existingIndex = competitors.indexWhere(
    (item) => item.id == competitor.id,
  );

  if (existingIndex == -1) {
    competitors.add(competitor);
  } else {
    competitors[existingIndex] = competitor;
  }

  competitorsSignal.value = competitors;
}

void deleteCompetitor(String competitorId) {
  competitorsSignal.value = competitorsSignal.value
      .where((competitor) => competitor.id != competitorId)
      .toList();
  generatedManualAssignmentsSignal.value = const [];
}

void clearCompetitors() {
  competitorsSignal.value = const [];
  generatedManualAssignmentsSignal.value = const [];
}

void importCompetitors(List<Competitor> competitors) {
  final existing = competitorsSignal.value.toList();

  for (final competitor in competitors) {
    final existingIndex = existing.indexWhere(
      (item) => item.ataNumber == competitor.ataNumber,
    );
    if (existingIndex == -1) {
      existing.add(competitor);
    } else {
      existing[existingIndex] = competitor;
    }
  }

  competitorsSignal.value = existing;
}

void importJudges(List<Judge> judges) {
  final existing = judgesSignal.value.toList();

  for (final judge in judges) {
    final existingIndex = existing.indexWhere(
      (item) => item.ataNumber == judge.ataNumber,
    );
    if (existingIndex == -1) {
      existing.add(judge);
    } else {
      existing[existingIndex] = judge;
    }
  }

  judgesSignal.value = existing;
}

void saveJudge(Judge judge) {
  final judges = judgesSignal.value.toList();
  final existingIndex = judges.indexWhere((item) => item.id == judge.id);

  if (existingIndex == -1) {
    judges.add(judge);
  } else {
    judges[existingIndex] = judge;
  }

  judgesSignal.value = judges;
}

void deleteJudge(String judgeId) {
  judgesSignal.value = judgesSignal.value
      .where((judge) => judge.id != judgeId)
      .toList();
  generatedManualAssignmentsSignal.value = const [];
}

void clearJudges() {
  judgesSignal.value = const [];
  generatedManualAssignmentsSignal.value = const [];
}

void generateManualAssignments() {
  generatedManualAssignmentsSignal.value = const [];

  final competitorsByRank = <BeltRank, List<Competitor>>{};
  for (final competitor in competitorsSignal.value) {
    competitorsByRank
        .putIfAbsent(competitor.rank, () => <Competitor>[])
        .add(competitor);
  }

  final centerJudges = judgesSignal.value
      .where((judge) => judge.isAvailable && canCenterJudge(judge))
      .toList();
  final cornerJudges = judgesSignal.value
      .where((judge) => judge.isAvailable && canJudgeAtAll(judge))
      .toList();
  final assignments = <GeneratedRingAssignment>[];
  final ringsPerRound = _ringsPerRoundForJudges(
    ringCountSignal.value,
    centerJudges,
    cornerJudges,
  );
  final reservedCenterJudgeIds = centerJudges
      .take(ringsPerRound)
      .map((judge) => judge.id)
      .toSet();
  var assignmentNumber = 1;
  var currentRoundNumber = 1;
  var usedJudgeIdsThisRound = <String>{};

  for (final rank in _orderedRanksForAssignments()) {
    final competitors = competitorsByRank[rank] ?? const <Competitor>[];
    for (var index = 0; index < competitors.length; index += 8) {
      final groupCompetitors = competitors.skip(index).take(8).toList();
      final roundNumber = ((assignmentNumber - 1) ~/ ringsPerRound) + 1;
      if (roundNumber != currentRoundNumber) {
        currentRoundNumber = roundNumber;
        usedJudgeIdsThisRound = <String>{};
      }

      final centerJudge = _nextUnusedJudge(
        centerJudges,
        usedJudgeIdsThisRound,
      );
      if (centerJudge != null) {
        usedJudgeIdsThisRound.add(centerJudge.id);
      }
      final cornerJudgeOne = _nextUnusedJudge(
        cornerJudges,
        usedJudgeIdsThisRound,
        reservedJudgeIds: reservedCenterJudgeIds,
      );
      if (cornerJudgeOne != null) {
        usedJudgeIdsThisRound.add(cornerJudgeOne.id);
      }
      final cornerJudgeTwo = _nextUnusedJudge(
        cornerJudges,
        usedJudgeIdsThisRound,
        reservedJudgeIds: reservedCenterJudgeIds,
      );
      if (cornerJudgeTwo != null) {
        usedJudgeIdsThisRound.add(cornerJudgeTwo.id);
      }

      assignments.add(
        GeneratedRingAssignment(
          id: 'generated-ring-$assignmentNumber',
          roundNumber: roundNumber,
          ringNumber: ((assignmentNumber - 1) % ringsPerRound) + 1,
          rank: rank,
          competitors: groupCompetitors,
          centerJudge: centerJudge,
          cornerJudgeOne: cornerJudgeOne,
          cornerJudgeTwo: cornerJudgeTwo,
        ),
      );
      assignmentNumber += 1;
    }
  }

  generatedManualAssignmentsSignal.value = assignments;
}

int effectiveManualRingsPerRound() {
  final centerJudges = judgesSignal.value
      .where((judge) => judge.isAvailable && canCenterJudge(judge))
      .toList();
  final availableJudges = judgesSignal.value
      .where((judge) => judge.isAvailable && canJudgeAtAll(judge))
      .toList();

  return _ringsPerRoundForJudges(
    ringCountSignal.value,
    centerJudges,
    availableJudges,
  );
}

int _ringsPerRoundForJudges(
  int configuredRingCount,
  List<Judge> centerJudges,
  List<Judge> availableJudges,
) {
  final configuredRings = configuredRingCount < 1 ? 1 : configuredRingCount;
  for (var rings = configuredRings; rings >= 1; rings -= 1) {
    if (centerJudges.length < rings) {
      continue;
    }

    final reservedCenterJudgeIds = centerJudges
        .take(rings)
        .map((judge) => judge.id)
        .toSet();
    final availableCornerJudges = availableJudges
        .where((judge) => !reservedCenterJudgeIds.contains(judge.id))
        .length;
    if (availableCornerJudges >= rings * 2) {
      return rings;
    }
  }

  return 1;
}

Judge? _nextUnusedJudge(
  List<Judge> judges,
  Set<String> usedJudgeIds, {
  Set<String> reservedJudgeIds = const {},
}) {
  for (final judge in judges) {
    if (!usedJudgeIds.contains(judge.id) &&
        !reservedJudgeIds.contains(judge.id)) {
      return judge;
    }
  }

  return null;
}

List<BeltRank> _orderedRanksForAssignments() {
  final orderedRanks = <BeltRank>[];
  for (final rank in rankOrderSignal.value) {
    if (!orderedRanks.contains(rank)) {
      orderedRanks.add(rank);
    }
  }
  for (final rank in BeltRank.values) {
    if (!orderedRanks.contains(rank)) {
      orderedRanks.add(rank);
    }
  }

  return orderedRanks;
}

void saveGeneratedManualAssignment(GeneratedRingAssignment assignment) {
  final normalizedAssignment = _withoutDuplicateJudges(assignment);
  final assignedJudgeIds = {
    if (normalizedAssignment.centerJudge != null)
      normalizedAssignment.centerJudge!.id,
    if (normalizedAssignment.cornerJudgeOne != null)
      normalizedAssignment.cornerJudgeOne!.id,
    if (normalizedAssignment.cornerJudgeTwo != null)
      normalizedAssignment.cornerJudgeTwo!.id,
  };
  final assignments = generatedManualAssignmentsSignal.value.toList();
  final index = assignments.indexWhere((item) => item.id == assignment.id);

  for (var i = 0; i < assignments.length; i += 1) {
    if (assignments[i].id == assignment.id ||
        assignments[i].roundNumber != normalizedAssignment.roundNumber) {
      continue;
    }

    assignments[i] = _withoutJudges(assignments[i], assignedJudgeIds);
  }

  if (index == -1) {
    assignments.add(normalizedAssignment);
  } else {
    assignments[index] = normalizedAssignment;
  }

  assignments.sort(_compareGeneratedAssignments);
  generatedManualAssignmentsSignal.value = assignments;
}

int _compareGeneratedAssignments(
  GeneratedRingAssignment left,
  GeneratedRingAssignment right,
) {
  final roundComparison = left.roundNumber.compareTo(right.roundNumber);
  if (roundComparison != 0) {
    return roundComparison;
  }

  return left.ringNumber.compareTo(right.ringNumber);
}

GeneratedRingAssignment _withoutDuplicateJudges(
  GeneratedRingAssignment assignment,
) {
  final usedJudgeIds = <String>{};
  final centerJudge = assignment.centerJudge;
  if (centerJudge != null) {
    usedJudgeIds.add(centerJudge.id);
  }

  final cornerJudgeOne = assignment.cornerJudgeOne;
  final normalizedCornerJudgeOne =
      cornerJudgeOne == null || usedJudgeIds.add(cornerJudgeOne.id)
      ? cornerJudgeOne
      : null;

  final cornerJudgeTwo = assignment.cornerJudgeTwo;
  final normalizedCornerJudgeTwo =
      cornerJudgeTwo == null || usedJudgeIds.add(cornerJudgeTwo.id)
      ? cornerJudgeTwo
      : null;

  return GeneratedRingAssignment(
    id: assignment.id,
    roundNumber: assignment.roundNumber,
    ringNumber: assignment.ringNumber,
    rank: assignment.rank,
    competitors: assignment.competitors,
    centerJudge: centerJudge,
    cornerJudgeOne: normalizedCornerJudgeOne,
    cornerJudgeTwo: normalizedCornerJudgeTwo,
  );
}

GeneratedRingAssignment _withoutJudges(
  GeneratedRingAssignment assignment,
  Set<String> judgeIds,
) {
  Judge? removeIfAssigned(Judge? judge) {
    if (judge == null || !judgeIds.contains(judge.id)) {
      return judge;
    }

    return null;
  }

  return GeneratedRingAssignment(
    id: assignment.id,
    roundNumber: assignment.roundNumber,
    ringNumber: assignment.ringNumber,
    rank: assignment.rank,
    competitors: assignment.competitors,
    centerJudge: removeIfAssigned(assignment.centerJudge),
    cornerJudgeOne: removeIfAssigned(assignment.cornerJudgeOne),
    cornerJudgeTwo: removeIfAssigned(assignment.cornerJudgeTwo),
  );
}

Judge? judgeById(String judgeId) {
  for (final judge in judgesSignal.value) {
    if (judge.id == judgeId) {
      return judge;
    }
  }

  return null;
}

List<Competitor> parseCompetitorsCsv(String csv) {
  final rows = _parseCsvRows(
    csv,
  ).where((row) => row.any((cell) => cell.trim().isNotEmpty)).toList();
  if (rows.isEmpty) {
    return const [];
  }

  final header = rows.first.map(_normalizeHeader).toList();
  final hasHeader =
      header.contains('first') ||
      header.contains('firstname') ||
      header.contains('first_name');
  final firstNameIndex = hasHeader
      ? _headerIndex(header, ['first', 'firstname', 'first_name'])
      : 0;
  final lastNameIndex = hasHeader
      ? _headerIndex(header, ['last', 'lastname', 'last_name'])
      : 1;
  final ataNumberIndex = hasHeader
      ? _headerIndex(header, ['ata', 'atanumber', 'ata_number'])
      : 2;
  final ageGroupIndex = hasHeader
      ? _headerIndex(header, ['age', 'agegroup', 'age_group'])
      : 3;
  final rankIndex = hasHeader
      ? _headerIndex(header, ['rank', 'beltrank', 'belt_rank'])
      : 4;
  final dataRows = hasHeader ? rows.skip(1) : rows;

  return [
    for (final row in dataRows)
      if (row.length > firstNameIndex &&
          row.length > lastNameIndex &&
          row.length > ataNumberIndex &&
          row.length > ageGroupIndex &&
          row.length > rankIndex &&
          row[firstNameIndex].trim().isNotEmpty &&
          row[lastNameIndex].trim().isNotEmpty &&
          row[ataNumberIndex].trim().isNotEmpty)
        if (_rankFromText(row[rankIndex]) != null &&
            _ageGroupFromText(row[ageGroupIndex]) != null)
          Competitor(
            id: 'competitor-${row[ataNumberIndex].trim()}',
            firstName: row[firstNameIndex].trim(),
            lastName: row[lastNameIndex].trim(),
            ataNumber: row[ataNumberIndex].trim(),
            ageGroup: _ageGroupFromText(row[ageGroupIndex])!,
            rank: _rankFromText(row[rankIndex])!,
          ),
  ];
}

List<Judge> parseJudgesCsv(String csv) {
  final rows = _parseCsvRows(
    csv,
  ).where((row) => row.any((cell) => cell.trim().isNotEmpty)).toList();
  if (rows.isEmpty) {
    return const [];
  }

  final header = rows.first.map(_normalizeHeader).toList();
  final hasHeader =
      header.contains('first') ||
      header.contains('firstname') ||
      header.contains('first_name');
  final firstNameIndex = hasHeader
      ? _headerIndex(header, ['first', 'firstname', 'first_name'])
      : 0;
  final lastNameIndex = hasHeader
      ? _headerIndex(header, ['last', 'lastname', 'last_name'])
      : 1;
  final ataNumberIndex = hasHeader
      ? _headerIndex(header, ['ata', 'atanumber', 'ata_number'])
      : 2;
  final rankIndex = hasHeader
      ? _headerIndex(header, ['rank', 'beltrank', 'belt_rank'])
      : 3;
  final qualificationIndex = hasHeader
      ? _optionalHeaderIndex(header, ['qualification', 'judgequalification'])
      : -1;
  final dataRows = hasHeader ? rows.skip(1) : rows;

  return [
    for (final row in dataRows)
      if (row.length > firstNameIndex &&
          row.length > lastNameIndex &&
          row.length > ataNumberIndex &&
          row.length > rankIndex &&
          row[firstNameIndex].trim().isNotEmpty &&
          row[lastNameIndex].trim().isNotEmpty &&
          row[ataNumberIndex].trim().isNotEmpty)
        if (_rankFromText(row[rankIndex]) != null)
          Judge(
            id: 'judge-${row[ataNumberIndex].trim()}',
            name: '${row[firstNameIndex].trim()} ${row[lastNameIndex].trim()}',
            ataNumber: row[ataNumberIndex].trim(),
            rank: _rankFromText(row[rankIndex])!,
            schoolId: '',
            qualification:
                qualificationIndex == -1 ||
                    row.length <= qualificationIndex ||
                    _qualificationFromText(row[qualificationIndex]) == null
                ? JudgeQualification.corner
                : _qualificationFromText(row[qualificationIndex])!,
            isAvailable: true,
          ),
  ];
}

List<List<String>> _parseCsvRows(String csv) {
  final rows = <List<String>>[];
  var row = <String>[];
  var cell = StringBuffer();
  var inQuotes = false;

  for (var index = 0; index < csv.length; index += 1) {
    final char = csv[index];
    if (char == '"') {
      if (inQuotes && index + 1 < csv.length && csv[index + 1] == '"') {
        cell.write('"');
        index += 1;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      row.add(cell.toString());
      cell = StringBuffer();
    } else if ((char == '\n' || char == '\r') && !inQuotes) {
      if (char == '\r' && index + 1 < csv.length && csv[index + 1] == '\n') {
        index += 1;
      }
      row.add(cell.toString());
      rows.add(row);
      row = <String>[];
      cell = StringBuffer();
    } else {
      cell.write(char);
    }
  }

  row.add(cell.toString());
  rows.add(row);
  return rows;
}

int _headerIndex(List<String> header, List<String> names) {
  for (final name in names) {
    final index = header.indexOf(name);
    if (index != -1) {
      return index;
    }
  }

  return names.first == 'first'
      ? 0
      : names.first == 'last'
      ? 1
      : names.first == 'ata'
      ? 2
      : 3;
}

int _optionalHeaderIndex(List<String> header, List<String> names) {
  for (final name in names) {
    final index = header.indexOf(name);
    if (index != -1) {
      return index;
    }
  }

  return -1;
}

String _normalizeHeader(String value) {
  return value.trim().toLowerCase().replaceAll(' ', '').replaceAll('-', '_');
}

BeltRank? _rankFromText(String value) {
  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll(' ', '')
      .replaceAll('-', '');

  for (final rank in BeltRank.values) {
    final name = rank.name.toLowerCase();
    final displayName = rank.displayName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (normalized == name || normalized == displayName) {
      return rank;
    }
  }

  return null;
}

JudgeQualification? _qualificationFromText(String value) {
  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll(' ', '')
      .replaceAll('-', '');

  for (final qualification in JudgeQualification.values) {
    final name = qualification.name.toLowerCase();
    final displayName = qualification.displayName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (normalized == name || normalized == displayName) {
      return qualification;
    }
  }

  return null;
}

AgeGroup? _ageGroupFromText(String value) {
  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll(' ', '')
      .replaceAll('-', '');

  for (final ageGroup in AgeGroup.values) {
    final name = ageGroup.name.toLowerCase();
    final displayName = ageGroup.displayName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (normalized == name || normalized == displayName) {
      return ageGroup;
    }
  }

  return null;
}

ManualRingSetup? manualRingSetupById(String setupId) {
  for (final setup in manualRingSetupsSignal.value) {
    if (setup.id == setupId) {
      return setup;
    }
  }

  return null;
}

ManualRingSetup? manualRingSetupForRing(int ringNumber) {
  for (final setup in manualRingSetupsSignal.value) {
    if (setup.ringNumber == ringNumber) {
      return setup;
    }
  }

  return null;
}

Division? divisionById(String? divisionId) {
  if (divisionId == null) {
    return null;
  }

  for (final division in divisionsSignal.value) {
    if (division.id == divisionId) {
      return division;
    }
  }

  return null;
}

final sampleDivisions = [
  const Division(
    id: 'boys-8-10-camo-brown-sparring',
    name: 'Boys 8-10 Camo/Brown Sparring',
    eventType: EventType.sparring,
    minRank: BeltRank.camo,
    maxRank: BeltRank.brown,
    competitorCount: 32,
    maxCompetitorsPerRing: 8,
    requiresChampionshipRound: true,
  ),
  const Division(
    id: 'teen-black-belt-forms',
    name: 'Teen Black Belt Forms',
    eventType: EventType.forms,
    minRank: BeltRank.firstDegree,
    maxRank: BeltRank.thirdDegree,
    competitorCount: 10,
    maxCompetitorsPerRing: 12,
    requiresChampionshipRound: false,
  ),
];

final sampleJudges = [
  const Judge(
    id: 'smith',
    name: 'Master Smith',
    rank: BeltRank.fifthDegree,
    schoolId: 'north',
    qualification: JudgeQualification.center,
    isAvailable: true,
  ),
  const Judge(
    id: 'lee',
    name: 'Ms. Lee',
    rank: BeltRank.thirdDegree,
    schoolId: 'east',
    qualification: JudgeQualification.center,
    isAvailable: true,
  ),
  const Judge(
    id: 'garcia',
    name: 'Mr. Garcia',
    rank: BeltRank.secondDegree,
    schoolId: 'south',
    qualification: JudgeQualification.corner,
    isAvailable: true,
  ),
  const Judge(
    id: 'nguyen',
    name: 'Ms. Nguyen',
    rank: BeltRank.firstDegree,
    schoolId: 'west',
    qualification: JudgeQualification.corner,
    isAvailable: true,
  ),
  const Judge(
    id: 'alex',
    name: 'Alex',
    rank: BeltRank.red,
    schoolId: 'north',
    qualification: JudgeQualification.none,
    isAvailable: true,
  ),
  const Judge(
    id: 'jamie',
    name: 'Jamie',
    rank: BeltRank.brown,
    schoolId: 'east',
    qualification: JudgeQualification.none,
    isAvailable: true,
  ),
];
