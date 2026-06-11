import 'domain.dart';

RingStaffingRequirement staffingRequirementFor(EventType eventType) {
  switch (eventType) {
    case EventType.sparring:
      return const RingStaffingRequirement(
        centerJudges: 1,
        cornerJudges: 2,
        timekeepers: 1,
        scorekeepers: 1,
      );
    case EventType.forms:
    case EventType.weapons:
    case EventType.combatWeapons:
    case EventType.creativeForms:
    case EventType.creativeWeapons:
    case EventType.xmaForms:
    case EventType.xmaWeapons:
      return const RingStaffingRequirement(
        centerJudges: 1,
        cornerJudges: 2,
        timekeepers: 0,
        scorekeepers: 0,
      );
  }
}

bool canJudgeAtAll(Judge judge) {
  return judge.qualification.index >= JudgeQualification.corner.index;
}

bool canCenterJudge(Judge judge) {
  return judge.qualification.index >= JudgeQualification.center.index;
}

bool judgeRankIsHighEnough(Judge judge, Ring ring) {
  return judge.rank.index >= ring.maxStudentRank.index;
}

int requiredRingCount(Division division) {
  if (division.competitorCount <= 0) {
    return 0;
  }
  if (division.maxCompetitorsPerRing <= 0) {
    throw ArgumentError.value(
      division.maxCompetitorsPerRing,
      'maxCompetitorsPerRing',
      'Must be greater than zero.',
    );
  }

  return (division.competitorCount / division.maxCompetitorsPerRing).ceil();
}

List<Ring> buildRingsFromDivisions(List<Division> divisions) {
  final rings = <Ring>[];
  var nextRingNumber = 1;

  for (final division in divisions) {
    final ringCount = requiredRingCount(division);
    final divisionRingIds = <String>[];

    for (var index = 0; index < ringCount; index += 1) {
      final ringId = '${division.id}-pool-${index + 1}';
      divisionRingIds.add(ringId);
      rings.add(
        Ring(
          id: ringId,
          number: nextRingNumber,
          name: ringCount == 1
              ? division.name
              : '${division.name} Pool ${_poolName(index)}',
          eventType: division.eventType,
          minStudentRank: division.minRank,
          maxStudentRank: division.maxRank,
          schoolIdsRepresented: const [],
          isChampionshipRing: false,
          parentDivisionId: division.id,
          expectedCompetitorCount: _poolCompetitorCount(division, index),
        ),
      );
      nextRingNumber += 1;
    }

    if (ringCount > 1 && division.requiresChampionshipRound) {
      rings.add(
        Ring(
          id: '${division.id}-championship',
          number: nextRingNumber,
          name: 'Championship: ${division.name}',
          eventType: division.eventType,
          minStudentRank: division.minRank,
          maxStudentRank: division.maxRank,
          schoolIdsRepresented: const [],
          isChampionshipRing: true,
          parentDivisionId: division.id,
          sourceRingIds: divisionRingIds,
          expectedCompetitorCount: divisionRingIds.length,
        ),
      );
      nextRingNumber += 1;
    }
  }

  return rings;
}

List<AssignmentRuleResult> validateAssignment({
  required Judge judge,
  required Ring ring,
  required StaffRole role,
  required List<Judge> alreadyAssigned,
  required Set<String> activelyAssignedJudgeIds,
}) {
  final results = <AssignmentRuleResult>[];

  if (!judge.isAvailable) {
    results.add(
      const AssignmentRuleResult(
        allowed: false,
        severity: AssignmentSeverity.error,
        message: 'Judge is unavailable.',
      ),
    );
  }

  if (activelyAssignedJudgeIds.contains(judge.id)) {
    results.add(
      const AssignmentRuleResult(
        allowed: false,
        severity: AssignmentSeverity.error,
        message: 'Judge is already assigned to another active ring.',
      ),
    );
  }

  if (role == StaffRole.centerJudge && !canCenterJudge(judge)) {
    results.add(
      const AssignmentRuleResult(
        allowed: false,
        severity: AssignmentSeverity.error,
        message: 'No center judge qualification.',
      ),
    );
  }

  if (role == StaffRole.cornerJudge && !canJudgeAtAll(judge)) {
    results.add(
      const AssignmentRuleResult(
        allowed: false,
        severity: AssignmentSeverity.error,
        message: 'No corner judge qualification.',
      ),
    );
  }

  if ((role == StaffRole.centerJudge || role == StaffRole.cornerJudge) &&
      !judgeRankIsHighEnough(judge, ring)) {
    results.add(
      AssignmentRuleResult(
        allowed: false,
        severity: AssignmentSeverity.error,
        message:
            '${judge.name} is ranked below ${ring.maxStudentRank.displayName}.',
      ),
    );
  }

  if (role == StaffRole.centerJudge &&
      judge.rank.index == ring.maxStudentRank.index) {
    results.add(
      const AssignmentRuleResult(
        allowed: true,
        severity: AssignmentSeverity.warning,
        message: 'Center judge is barely qualified by rank.',
      ),
    );
  }

  final sameSchoolCount = alreadyAssigned
      .where((assignedJudge) => assignedJudge.schoolId == judge.schoolId)
      .length;
  if ((role == StaffRole.centerJudge || role == StaffRole.cornerJudge) &&
      sameSchoolCount > 0) {
    results.add(
      AssignmentRuleResult(
        allowed: true,
        severity: AssignmentSeverity.warning,
        message: 'School diversity penalty: ${sameSchoolCount * 20}.',
      ),
    );
  }

  if (results.isEmpty) {
    results.add(
      const AssignmentRuleResult(
        allowed: true,
        severity: AssignmentSeverity.ok,
        message: 'Assignment allowed.',
      ),
    );
  }

  return results;
}

List<RingAssignment> autoAssignRings({
  required List<Ring> rings,
  required List<Judge> judges,
}) {
  final assignedJudgeIds = <String>{};
  final assignments = <RingAssignment>[];
  final prioritizedRings = [...rings]..sort(_compareRingDifficulty);

  for (final ring in prioritizedRings) {
    final requirement = staffingRequirementFor(ring.eventType);
    final results = <AssignmentRuleResult>[];
    final assignedToRing = <Judge>[];
    final centerJudge = _pickJudge(
      judges: judges,
      ring: ring,
      role: StaffRole.centerJudge,
      alreadyAssignedToRing: assignedToRing,
      assignedJudgeIds: assignedJudgeIds,
    );

    if (centerJudge == null && requirement.centerJudges > 0) {
      results.add(
        AssignmentRuleResult(
          allowed: false,
          severity: AssignmentSeverity.error,
          message: '${ring.name} has no qualified center judge available.',
        ),
      );
    } else if (centerJudge != null) {
      assignedToRing.add(centerJudge);
      assignedJudgeIds.add(centerJudge.id);
      results.addAll(
        validateAssignment(
          judge: centerJudge,
          ring: ring,
          role: StaffRole.centerJudge,
          alreadyAssigned: const [],
          activelyAssignedJudgeIds: const {},
        ),
      );
    }

    final cornerJudges = <Judge>[];
    for (var index = 0; index < requirement.cornerJudges; index += 1) {
      final cornerJudge = _pickJudge(
        judges: judges,
        ring: ring,
        role: StaffRole.cornerJudge,
        alreadyAssignedToRing: assignedToRing,
        assignedJudgeIds: assignedJudgeIds,
      );
      if (cornerJudge == null) {
        results.add(
          AssignmentRuleResult(
            allowed: false,
            severity: AssignmentSeverity.error,
            message: '${ring.name} is missing a corner judge.',
          ),
        );
        continue;
      }

      results.addAll(
        validateAssignment(
          judge: cornerJudge,
          ring: ring,
          role: StaffRole.cornerJudge,
          alreadyAssigned: assignedToRing,
          activelyAssignedJudgeIds: const {},
        ),
      );
      assignedToRing.add(cornerJudge);
      assignedJudgeIds.add(cornerJudge.id);
      cornerJudges.add(cornerJudge);
    }

    final timekeeper = requirement.timekeepers == 0
        ? null
        : _pickSupportStaff(judges, assignedJudgeIds);
    if (timekeeper == null && requirement.timekeepers > 0) {
      results.add(
        AssignmentRuleResult(
          allowed: true,
          severity: AssignmentSeverity.warning,
          message: '${ring.name} is missing a timekeeper.',
        ),
      );
    } else if (timekeeper != null) {
      assignedJudgeIds.add(timekeeper.id);
    }

    final scorekeeper = requirement.scorekeepers == 0
        ? null
        : _pickSupportStaff(judges, assignedJudgeIds);
    if (scorekeeper == null && requirement.scorekeepers > 0) {
      results.add(
        AssignmentRuleResult(
          allowed: true,
          severity: AssignmentSeverity.warning,
          message: '${ring.name} is missing a scorekeeper.',
        ),
      );
    } else if (scorekeeper != null) {
      assignedJudgeIds.add(scorekeeper.id);
    }

    if (_allJudgesFromSameSchool(assignedToRing)) {
      results.add(
        AssignmentRuleResult(
          allowed: true,
          severity: AssignmentSeverity.warning,
          message: '${ring.name} has all judges from the same school.',
        ),
      );
    }

    assignments.add(
      RingAssignment(
        ring: ring,
        centerJudge: centerJudge,
        cornerJudges: cornerJudges,
        timekeeper: timekeeper,
        scorekeeper: scorekeeper,
        results: results,
      ),
    );
  }

  assignments.sort((left, right) => left.ring.number.compareTo(right.ring.number));
  return assignments;
}

int schoolDiversityPenalty(Judge judge, List<Judge> alreadyAssigned) {
  final sameSchoolCount = alreadyAssigned
      .where((assignedJudge) => assignedJudge.schoolId == judge.schoolId)
      .length;

  return sameSchoolCount * 20;
}

Judge? _pickJudge({
  required List<Judge> judges,
  required Ring ring,
  required StaffRole role,
  required List<Judge> alreadyAssignedToRing,
  required Set<String> assignedJudgeIds,
}) {
  final ranked = judges
      .where((judge) {
        final results = validateAssignment(
          judge: judge,
          ring: ring,
          role: role,
          alreadyAssigned: alreadyAssignedToRing,
          activelyAssignedJudgeIds: assignedJudgeIds,
        );
        return results.every((result) => result.allowed);
      })
      .toList()
    ..sort((left, right) {
      final leftPenalty = schoolDiversityPenalty(left, alreadyAssignedToRing);
      final rightPenalty = schoolDiversityPenalty(right, alreadyAssignedToRing);
      final penaltyCompare = leftPenalty.compareTo(rightPenalty);
      if (penaltyCompare != 0) {
        return penaltyCompare;
      }

      return left.rank.index.compareTo(right.rank.index);
    });

  return ranked.firstOrNull;
}

Judge? _pickSupportStaff(List<Judge> judges, Set<String> assignedJudgeIds) {
  for (final judge in judges) {
    if (judge.isAvailable && !assignedJudgeIds.contains(judge.id)) {
      return judge;
    }
  }

  return null;
}

int _compareRingDifficulty(Ring left, Ring right) {
  final leftScore = _ringDifficultyScore(left);
  final rightScore = _ringDifficultyScore(right);
  return rightScore.compareTo(leftScore);
}

int _ringDifficultyScore(Ring ring) {
  return (ring.maxStudentRank.index * 100) +
      (ring.isChampionshipRing ? 50 : 0) +
      (ring.eventType == EventType.sparring ? 25 : 0) +
      (ring.expectedCompetitorCount ?? 0);
}

bool _allJudgesFromSameSchool(List<Judge> judges) {
  if (judges.length < 2) {
    return false;
  }

  return judges.every((judge) => judge.schoolId == judges.first.schoolId);
}

int _poolCompetitorCount(Division division, int poolIndex) {
  final alreadyPlaced = poolIndex * division.maxCompetitorsPerRing;
  final remaining = division.competitorCount - alreadyPlaced;
  if (remaining < division.maxCompetitorsPerRing) {
    return remaining;
  }

  return division.maxCompetitorsPerRing;
}

String _poolName(int index) {
  return String.fromCharCode('A'.codeUnitAt(0) + index);
}
