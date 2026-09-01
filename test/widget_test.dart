import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ring_assignments/assignment_engine.dart';
import 'package:ring_assignments/assignment_store.dart';
import 'package:ring_assignments/domain.dart';
import 'package:ring_assignments/main.dart';

void main() {
  test('sparring requires timekeeper and scorekeeper, forms do not', () {
    final sparring = staffingRequirementFor(EventType.sparring);
    final forms = staffingRequirementFor(EventType.forms);

    expect(sparring.centerJudges, 1);
    expect(sparring.cornerJudges, 2);
    expect(sparring.timekeepers, 1);
    expect(sparring.scorekeepers, 1);
    expect(forms.centerJudges, 1);
    expect(forms.cornerJudges, 2);
    expect(forms.timekeepers, 0);
    expect(forms.scorekeepers, 0);
  });

  test('judge must have enough rank for the ring', () {
    const ring = Ring(
      id: 'advanced',
      number: 1,
      name: 'Advanced Black Belt Forms',
      eventType: EventType.forms,
      minStudentRank: BeltRank.firstDegree,
      maxStudentRank: BeltRank.thirdDegree,
      schoolIdsRepresented: [],
      isChampionshipRing: false,
    );
    const judge = Judge(
      id: 'first-degree',
      name: 'First Degree Judge',
      rank: BeltRank.firstDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );

    final results = validateAssignment(
      judge: judge,
      ring: ring,
      role: StaffRole.centerJudge,
      alreadyAssigned: const [],
      activelyAssignedJudgeIds: const {},
    );

    expect(judgeRankIsHighEnough(judge, ring), isFalse);
    expect(results.any((result) => !result.allowed), isTrue);
  });

  test('large divisions create pool rings and a championship ring', () {
    const division = Division(
      id: 'boys-sparring',
      name: 'Boys Sparring',
      eventType: EventType.sparring,
      minRank: BeltRank.camo,
      maxRank: BeltRank.brown,
      competitorCount: 32,
      maxCompetitorsPerRing: 8,
      requiresChampionshipRound: true,
    );

    final rings = buildRingsFromDivisions([division]);

    expect(rings, hasLength(5));
    expect(rings.take(4).every((ring) => !ring.isChampionshipRing), isTrue);
    expect(rings.last.isChampionshipRing, isTrue);
    expect(rings.last.sourceRingIds, hasLength(4));
    expect(rings.last.expectedCompetitorCount, 4);
  });

  test('competitor CSV parser reads header rows and ranks', () {
    final competitors = parseCompetitorsCsv(
      'first_name,last_name,ata_number,age_group,rank\n'
      'Ada,Lovelace,12345,Youth 9-10,1st Degree\n'
      'Grace,Hopper,67890,Teen 13-14,blue\n',
    );

    expect(competitors, hasLength(2));
    expect(competitors.first.firstName, 'Ada');
    expect(competitors.first.lastName, 'Lovelace');
    expect(competitors.first.ataNumber, '12345');
    expect(competitors.first.ageGroup, AgeGroup.youthNineTen);
    expect(competitors.first.rank, BeltRank.firstDegree);
    expect(competitors.last.ageGroup, AgeGroup.teenThirteenFourteen);
    expect(competitors.last.rank, BeltRank.blue);
  });

  test('sample competitor CSV covers every rank', () {
    final competitors = parseCompetitorsCsv(
      File('sample_competitors.csv').readAsStringSync(),
    );
    final ranks = competitors.map((competitor) => competitor.rank).toSet();
    final countsByRank = <BeltRank, int>{};
    for (final competitor in competitors) {
      countsByRank.update(
        competitor.rank,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    expect(ranks, containsAll(BeltRank.values));
    expect(countsByRank.values.where((count) => count == 3), hasLength(1));
    expect(
      countsByRank.values.where((count) => count != 3),
      everyElement(allOf(greaterThanOrEqualTo(4), lessThanOrEqualTo(16))),
    );
  });

  test('judge CSV parser reads header rows, ATA numbers, and ranks', () {
    final judges = parseJudgesCsv(
      'first_name,last_name,ata_number,rank,qualification\n'
      'Nora,Bennett,730184,1st Degree,Center\n'
      'Caleb,Foster,518297,9th Degree,Corner\n',
    );

    expect(judges, hasLength(2));
    expect(judges.first.name, 'Nora Bennett');
    expect(judges.first.ataNumber, '730184');
    expect(judges.first.rank, BeltRank.firstDegree);
    expect(judges.first.schoolId, isEmpty);
    expect(judges.first.qualification, JudgeQualification.center);
    expect(judges.last.rank, BeltRank.ninthDegree);
    expect(judges.last.qualification, JudgeQualification.corner);
  });

  test('sample judge CSV scenarios have expected staffing counts', () {
    final eightCenterJudges = parseJudgesCsv(
      File('sample_judges_8_centers.csv').readAsStringSync(),
    );
    final limitedCenterJudges = parseJudgesCsv(
      File('sample_judges_3_centers_many_corners.csv').readAsStringSync(),
    );

    expect(
      eightCenterJudges.where(
        (judge) => judge.qualification == JudgeQualification.center,
      ),
      hasLength(8),
    );
    expect(
      eightCenterJudges.where(
        (judge) => judge.qualification == JudgeQualification.corner,
      ),
      hasLength(20),
    );
    expect(
      limitedCenterJudges.where(
        (judge) => judge.qualification == JudgeQualification.center,
      ),
      hasLength(3),
    );
    expect(
      limitedCenterJudges.where(
        (judge) => judge.qualification == JudgeQualification.corner,
      ),
      hasLength(18),
    );
  });

  test('sample eight-center judge CSV staffs eight rings per round', () {
    competitorsSignal.value = parseCompetitorsCsv(
      File('sample_competitors.csv').readAsStringSync(),
    );
    judgesSignal.value = parseJudgesCsv(
      File('sample_judges_8_centers.csv').readAsStringSync(),
    );
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 8;
    rankOrderSignal.value = BeltRank.values;

    generateManualAssignments();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(effectiveManualRingsPerRound(), 8);
    expect(assignments[7].roundNumber, 1);
    expect(assignments[7].ringNumber, 8);
    expect(assignments[8].roundNumber, 2);
    expect(assignments[8].ringNumber, 1);
    expect(
      assignments.take(8).every((assignment) => assignment.centerJudge != null),
      isTrue,
    );
  });

  test('school diversity is a warning, not a blocker', () {
    const ring = Ring(
      id: 'same-school',
      number: 1,
      name: 'Same School Forms',
      eventType: EventType.forms,
      minStudentRank: BeltRank.brown,
      maxStudentRank: BeltRank.brown,
      schoolIdsRepresented: [],
      isChampionshipRing: false,
    );
    const center = Judge(
      id: 'center',
      name: 'Center',
      rank: BeltRank.firstDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    const corner = Judge(
      id: 'corner',
      name: 'Corner',
      rank: BeltRank.firstDegree,
      schoolId: 'north',
      qualification: JudgeQualification.corner,
      isAvailable: true,
    );

    final results = validateAssignment(
      judge: corner,
      ring: ring,
      role: StaffRole.cornerJudge,
      alreadyAssigned: const [center],
      activelyAssignedJudgeIds: const {},
    );

    expect(results.every((result) => result.allowed), isTrue);
    expect(
      results.any((result) => result.severity == AssignmentSeverity.warning),
      isTrue,
    );
  });

  testWidgets(
    'bottom navigation starts at competitors and moves to assignments',
    (tester) async {
      competitorsSignal.value = const [];
      judgesSignal.value = const [];
      generatedManualAssignmentsSignal.value = const [];
      ringCountSignal.value = 4;

      await tester.pumpWidget(const RingAssignmentsApp());
      await tester.pumpAndSettle();

      expect(find.text('Ring Assignments'), findsNothing);
      expect(find.text('Competitors'), findsWidgets);
      expect(find.text('Rings'), findsOneWidget);
      expect(find.text('Judges'), findsOneWidget);
      expect(find.text('Assignments'), findsOneWidget);
      expect(find.text('No competitors yet'), findsOneWidget);

      await tester.tap(find.text('Assignments'));
      await tester.pumpAndSettle();

      expect(find.text('Generate Assignments'), findsOneWidget);
      expect(
        find.textContaining('Staffed rings per round: 1 of 4'),
        findsOneWidget,
      );
      expect(find.text('No assignments generated yet'), findsOneWidget);
      expect(find.text('No center judges available'), findsOneWidget);
    },
  );

  testWidgets('welcome intro is dismissed permanently after getting started', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Ring Assignments'), findsOneWidget);
    expect(
      find.text('1. Add competitors by CSV or individually.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Ring Assignments'), findsNothing);
    expect(
      (await SharedPreferences.getInstance()).getBool('welcome_intro_seen'),
      isTrue,
    );
  });

  testWidgets('assignment screen generates rings by competitor rank', (
    tester,
  ) async {
    competitorsSignal.value = [
      for (var index = 0; index < 9; index += 1)
        Competitor(
          id: 'youth-$index',
          firstName: 'Youth',
          lastName: '$index',
          ataNumber: '100$index',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.green,
        ),
      const Competitor(
        id: 'teen-1',
        firstName: 'Teen',
        lastName: 'One',
        ataNumber: '2001',
        ageGroup: AgeGroup.teenThirteenFourteen,
        rank: BeltRank.green,
      ),
    ];
    judgesSignal.value = _testJudges(centerCount: 2, cornerCount: 4);
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 4;
    rankOrderSignal.value = BeltRank.values;

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Center judges: 2'), findsOneWidget);

    await tester.tap(find.text('Generate Assignments'));
    await tester.pumpAndSettle();

    expect(find.text('Round 1 - Ring 1 - Green'), findsOneWidget);
    expect(find.text('Center 0'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Round 1 - Ring 2 - Green'), 160);
    expect(find.text('Round 1 - Ring 2 - Green'), findsOneWidget);

    await tester.tap(find.text('Round 1 - Ring 2 - Green'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Assignment'), findsOneWidget);
  });

  testWidgets(
    'assignment generation clears stale assignments before rebuilding',
    (tester) async {
      competitorsSignal.value = const [
        Competitor(
          id: 'youth-1',
          firstName: 'Youth',
          lastName: 'One',
          ataNumber: '1001',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.green,
        ),
      ];
      judgesSignal.value = const [];
      generatedManualAssignmentsSignal.value = const [
        GeneratedRingAssignment(
          id: 'stale',
          ringNumber: 99,
          rank: BeltRank.ninthDegree,
          competitors: [],
        ),
      ];
      ringCountSignal.value = 4;
      rankOrderSignal.value = BeltRank.values;

      await tester.pumpWidget(const RingAssignmentsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Assignments'));
      await tester.pumpAndSettle();

      expect(find.text('Round 1 - Ring 99 - 9th Degree'), findsOneWidget);

      await tester.tap(find.text('Generate Assignments'));
      await tester.pumpAndSettle();

      expect(find.text('Round 1 - Ring 99 - 9th Degree'), findsNothing);
      expect(find.text('Round 1 - Ring 1 - Green'), findsOneWidget);
    },
  );

  test('assignment generation continues into additional rounds', () {
    competitorsSignal.value = [
      for (var index = 0; index < 17; index += 1)
        Competitor(
          id: 'youth-$index',
          firstName: 'Youth',
          lastName: '$index',
          ataNumber: '100$index',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.green,
        ),
    ];
    judgesSignal.value = _testJudges(centerCount: 2, cornerCount: 4);
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 2;
    rankOrderSignal.value = BeltRank.values;

    generateManualAssignments();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(assignments, hasLength(3));
    expect(assignments[0].roundNumber, 1);
    expect(assignments[0].ringNumber, 1);
    expect(assignments[1].roundNumber, 1);
    expect(assignments[1].ringNumber, 2);
    expect(assignments[2].roundNumber, 2);
    expect(assignments[2].ringNumber, 1);
  });

  test('assignment generation uses all eight rings before round two', () {
    competitorsSignal.value = [
      for (var index = 0; index < 9; index += 1)
        Competitor(
          id: 'competitor-$index',
          firstName: 'Competitor',
          lastName: '$index',
          ataNumber: '100$index',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.values[index],
        ),
    ];
    judgesSignal.value = _testJudges(centerCount: 8, cornerCount: 16);
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 8;
    rankOrderSignal.value = BeltRank.values;

    generateManualAssignments();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(assignments, hasLength(9));
    expect(assignments[7].roundNumber, 1);
    expect(assignments[7].ringNumber, 8);
    expect(assignments[8].roundNumber, 2);
    expect(assignments[8].ringNumber, 1);
  });

  test('assignment generation limits rings by available judges', () {
    competitorsSignal.value = [
      for (var index = 0; index < 5; index += 1)
        Competitor(
          id: 'competitor-$index',
          firstName: 'Competitor',
          lastName: '$index',
          ataNumber: '100$index',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.values[index],
        ),
    ];
    judgesSignal.value = _testJudges(centerCount: 2, cornerCount: 4);
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 8;
    rankOrderSignal.value = BeltRank.values;

    generateManualAssignments();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(assignments, hasLength(5));
    expect(assignments[0].roundNumber, 1);
    expect(assignments[0].ringNumber, 1);
    expect(assignments[1].roundNumber, 1);
    expect(assignments[1].ringNumber, 2);
    expect(assignments[2].roundNumber, 2);
    expect(assignments[2].ringNumber, 1);
  });

  test(
    'assignment generation reserves center judges before assigning corners',
    () {
      competitorsSignal.value = [
        for (var index = 0; index < 3; index += 1)
          Competitor(
            id: 'competitor-$index',
            firstName: 'Competitor',
            lastName: '$index',
            ataNumber: '100$index',
            ageGroup: AgeGroup.youthNineTen,
            rank: BeltRank.values[index],
          ),
      ];
      judgesSignal.value = _testJudges(centerCount: 3, cornerCount: 6);
      generatedManualAssignmentsSignal.value = const [];
      ringCountSignal.value = 3;
      rankOrderSignal.value = BeltRank.values;

      generateManualAssignments();

      final assignments = generatedManualAssignmentsSignal.value;

      expect(assignments, hasLength(3));
      expect(
        assignments.every((assignment) => assignment.roundNumber == 1),
        isTrue,
      );
      expect(
        assignments.every((assignment) => assignment.centerJudge != null),
        isTrue,
      );
      expect(
        assignments
            .expand(
              (assignment) => [
                assignment.cornerJudgeOne,
                assignment.cornerJudgeTwo,
              ],
            )
            .whereType<Judge>()
            .every(canCenterJudge),
        isFalse,
      );
    },
  );

  testWidgets('assignment generation uses edited ring count signal', (
    tester,
  ) async {
    competitorsSignal.value = [
      for (var index = 0; index < 17; index += 1)
        Competitor(
          id: 'youth-$index',
          firstName: 'Youth',
          lastName: '$index',
          ataNumber: '100$index',
          ageGroup: AgeGroup.youthNineTen,
          rank: BeltRank.green,
        ),
    ];
    judgesSignal.value = _testJudges(centerCount: 2, cornerCount: 4);
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 4;

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rings'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '2');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Staffed rings per round: 2 of 2'),
      findsOneWidget,
    );

    await tester.tap(find.text('Generate Assignments'));
    await tester.pumpAndSettle();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(ringCountSignal.value, 2);
    expect(assignments, hasLength(3));
    expect(assignments[2].roundNumber, 2);
    expect(assignments[2].ringNumber, 1);
  });

  test('assignment generation follows rank order', () {
    competitorsSignal.value = const [
      Competitor(
        id: 'youth-1',
        firstName: 'Youth',
        lastName: 'One',
        ataNumber: '1001',
        ageGroup: AgeGroup.youthNineTen,
        rank: BeltRank.green,
      ),
      Competitor(
        id: 'teen-1',
        firstName: 'Teen',
        lastName: 'One',
        ataNumber: '2001',
        ageGroup: AgeGroup.teenThirteenFourteen,
        rank: BeltRank.firstDegree,
      ),
    ];
    judgesSignal.value = const [];
    generatedManualAssignmentsSignal.value = const [];
    ringCountSignal.value = 4;
    rankOrderSignal.value = const [BeltRank.firstDegree, BeltRank.green];

    generateManualAssignments();

    final assignments = generatedManualAssignmentsSignal.value;

    expect(assignments, hasLength(2));
    expect(assignments[0].rank, BeltRank.firstDegree);
    expect(assignments[1].rank, BeltRank.green);
  });

  test(
    'saving assignment removes selected judges from other rings in same round',
    () {
      const centerJudge = Judge(
        id: 'center',
        name: 'Center Judge',
        rank: BeltRank.fifthDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      );
      const cornerJudge = Judge(
        id: 'corner',
        name: 'Corner Judge',
        rank: BeltRank.thirdDegree,
        schoolId: 'east',
        qualification: JudgeQualification.corner,
        isAvailable: true,
      );
      generatedManualAssignmentsSignal.value = const [
        GeneratedRingAssignment(
          id: 'ring-1',
          roundNumber: 1,
          ringNumber: 1,
          rank: BeltRank.green,
          competitors: [],
          centerJudge: centerJudge,
          cornerJudgeOne: cornerJudge,
        ),
        GeneratedRingAssignment(
          id: 'ring-2',
          roundNumber: 1,
          ringNumber: 2,
          rank: BeltRank.firstDegree,
          competitors: [],
        ),
      ];

      saveGeneratedManualAssignment(
        const GeneratedRingAssignment(
          id: 'ring-2',
          roundNumber: 1,
          ringNumber: 2,
          rank: BeltRank.firstDegree,
          competitors: [],
          centerJudge: centerJudge,
          cornerJudgeOne: cornerJudge,
        ),
      );

      final ringOne = generatedManualAssignmentsSignal.value.firstWhere(
        (assignment) => assignment.id == 'ring-1',
      );
      final ringTwo = generatedManualAssignmentsSignal.value.firstWhere(
        (assignment) => assignment.id == 'ring-2',
      );

      expect(ringOne.centerJudge, isNull);
      expect(ringOne.cornerJudgeOne, isNull);
      expect(ringTwo.centerJudge?.id, 'center');
      expect(ringTwo.cornerJudgeOne?.id, 'corner');
    },
  );

  test('saving assignment leaves replaced judges unassigned', () {
    const ringOneCenter = Judge(
      id: 'ring-one-center',
      name: 'Ring One Center',
      rank: BeltRank.fifthDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    const ringTwoCenter = Judge(
      id: 'ring-two-center',
      name: 'Ring Two Center',
      rank: BeltRank.fifthDegree,
      schoolId: 'south',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    const ringOneCorner = Judge(
      id: 'ring-one-corner',
      name: 'Ring One Corner',
      rank: BeltRank.thirdDegree,
      schoolId: 'east',
      qualification: JudgeQualification.corner,
      isAvailable: true,
    );
    const ringTwoCorner = Judge(
      id: 'ring-two-corner',
      name: 'Ring Two Corner',
      rank: BeltRank.thirdDegree,
      schoolId: 'west',
      qualification: JudgeQualification.corner,
      isAvailable: true,
    );
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'ring-1',
        roundNumber: 1,
        ringNumber: 1,
        rank: BeltRank.green,
        competitors: [],
        centerJudge: ringOneCenter,
        cornerJudgeOne: ringOneCorner,
      ),
      GeneratedRingAssignment(
        id: 'ring-2',
        roundNumber: 1,
        ringNumber: 2,
        rank: BeltRank.firstDegree,
        competitors: [],
        centerJudge: ringTwoCenter,
        cornerJudgeOne: ringTwoCorner,
      ),
    ];

    saveGeneratedManualAssignment(
      const GeneratedRingAssignment(
        id: 'ring-2',
        roundNumber: 1,
        ringNumber: 2,
        rank: BeltRank.firstDegree,
        competitors: [],
        centerJudge: ringOneCenter,
        cornerJudgeOne: ringOneCorner,
      ),
    );

    final ringOne = generatedManualAssignmentsSignal.value.firstWhere(
      (assignment) => assignment.id == 'ring-1',
    );
    final ringTwo = generatedManualAssignmentsSignal.value.firstWhere(
      (assignment) => assignment.id == 'ring-2',
    );

    expect(ringOne.centerJudge, isNull);
    expect(ringOne.cornerJudgeOne, isNull);
    expect(ringTwo.centerJudge?.id, 'ring-one-center');
    expect(ringTwo.cornerJudgeOne?.id, 'ring-one-corner');
  });

  test('saving assignment allows the same judges in another round', () {
    const centerJudge = Judge(
      id: 'center',
      name: 'Center Judge',
      rank: BeltRank.fifthDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'round-1-ring-1',
        roundNumber: 1,
        ringNumber: 1,
        rank: BeltRank.green,
        competitors: [],
        centerJudge: centerJudge,
      ),
      GeneratedRingAssignment(
        id: 'round-2-ring-1',
        roundNumber: 2,
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [],
      ),
    ];

    saveGeneratedManualAssignment(
      const GeneratedRingAssignment(
        id: 'round-2-ring-1',
        roundNumber: 2,
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [],
        centerJudge: centerJudge,
      ),
    );

    final roundOne = generatedManualAssignmentsSignal.value.firstWhere(
      (assignment) => assignment.id == 'round-1-ring-1',
    );
    final roundTwo = generatedManualAssignmentsSignal.value.firstWhere(
      (assignment) => assignment.id == 'round-2-ring-1',
    );

    expect(roundOne.centerJudge?.id, 'center');
    expect(roundTwo.centerJudge?.id, 'center');
  });

  testWidgets('assignment editor clears unavailable selected judges', (
    tester,
  ) async {
    judgesSignal.value = const [
      Judge(
        id: 'unavailable-center',
        name: 'Unavailable Center',
        rank: BeltRank.fifthDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: false,
      ),
    ];
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'ring-1',
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [],
        centerJudge: Judge(
          id: 'unavailable-center',
          name: 'Unavailable Center',
          rank: BeltRank.fifthDegree,
          schoolId: 'north',
          qualification: JudgeQualification.center,
          isAvailable: false,
        ),
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Round 1 - Ring 1 - 1st Degree'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(generatedManualAssignmentsSignal.value.single.centerJudge, isNull);
  });

  testWidgets(
    'assignment editor shows judges assigned to other rings in same round',
    (tester) async {
      const assignedCenter = Judge(
        id: 'assigned-center',
        name: 'Assigned Center',
        rank: BeltRank.fifthDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      );
      const openCenter = Judge(
        id: 'open-center',
        name: 'Open Center',
        rank: BeltRank.fifthDegree,
        schoolId: 'south',
        qualification: JudgeQualification.center,
        isAvailable: true,
      );
      judgesSignal.value = const [assignedCenter, openCenter];
      generatedManualAssignmentsSignal.value = const [
        GeneratedRingAssignment(
          id: 'ring-1',
          roundNumber: 1,
          ringNumber: 1,
          rank: BeltRank.firstDegree,
          competitors: [],
        ),
        GeneratedRingAssignment(
          id: 'ring-2',
          roundNumber: 1,
          ringNumber: 2,
          rank: BeltRank.secondDegree,
          competitors: [],
          centerJudge: assignedCenter,
        ),
      ];

      await tester.pumpWidget(const RingAssignmentsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Assignments'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Round 1 - Ring 1 - 1st Degree'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(DropdownButtonFormField<String>, 'Center judge'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Open Center (Unassigned)'), findsOneWidget);
      expect(find.text('Assigned Center (Assigned)'), findsOneWidget);
    },
  );

  testWidgets(
    'assignment editor only shows center-qualified judges in center selector',
    (tester) async {
      const centerJudge = Judge(
        id: 'center',
        name: 'Center Judge',
        rank: BeltRank.fifthDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      );
      const cornerJudge = Judge(
        id: 'corner',
        name: 'Corner Judge',
        rank: BeltRank.thirdDegree,
        schoolId: 'south',
        qualification: JudgeQualification.corner,
        isAvailable: true,
      );
      judgesSignal.value = const [centerJudge, cornerJudge];
      generatedManualAssignmentsSignal.value = const [
        GeneratedRingAssignment(
          id: 'ring-1',
          roundNumber: 1,
          ringNumber: 1,
          rank: BeltRank.firstDegree,
          competitors: [],
        ),
      ];

      await tester.pumpWidget(const RingAssignmentsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Assignments'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Round 1 - Ring 1 - 1st Degree'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(DropdownButtonFormField<String>, 'Center judge'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Center Judge (Unassigned)'), findsOneWidget);
      expect(find.text('Corner Judge'), findsNothing);
    },
  );

  testWidgets(
    'assignment editor marks center-qualified judges in corner selector',
    (tester) async {
      const centerJudge = Judge(
        id: 'center',
        name: 'Center Judge',
        rank: BeltRank.fifthDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      );
      const cornerJudge = Judge(
        id: 'corner',
        name: 'Corner Judge',
        rank: BeltRank.thirdDegree,
        schoolId: 'south',
        qualification: JudgeQualification.corner,
        isAvailable: true,
      );
      judgesSignal.value = const [centerJudge, cornerJudge];
      generatedManualAssignmentsSignal.value = const [
        GeneratedRingAssignment(
          id: 'ring-1',
          roundNumber: 1,
          ringNumber: 1,
          rank: BeltRank.firstDegree,
          competitors: [],
        ),
      ];

      await tester.pumpWidget(const RingAssignmentsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Assignments'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Round 1 - Ring 1 - 1st Degree'));
      await tester.pumpAndSettle();

      await tester.tap(
        find
            .widgetWithText(DropdownButtonFormField<String>, 'Corner judge')
            .first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Center Judge (Center, Unassigned)'), findsOneWidget);
      expect(find.text('Corner Judge (Unassigned)'), findsOneWidget);
    },
  );

  testWidgets('assignment editor shows judges assigned in another round', (
    tester,
  ) async {
    const assignedCenter = Judge(
      id: 'assigned-center',
      name: 'Assigned Center',
      rank: BeltRank.fifthDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    judgesSignal.value = const [assignedCenter];
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'round-1-ring-1',
        roundNumber: 1,
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [],
        centerJudge: assignedCenter,
      ),
      GeneratedRingAssignment(
        id: 'round-2-ring-1',
        roundNumber: 2,
        ringNumber: 1,
        rank: BeltRank.secondDegree,
        competitors: [],
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Next round'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Round 2 - Ring 1 - 2nd Degree'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(DropdownButtonFormField<String>, 'Center judge'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Assigned Center (Unassigned)'), findsOneWidget);
  });

  testWidgets('assignment rows warn when judges are missing', (tester) async {
    competitorsSignal.value = const [
      Competitor(
        id: 'competitor-1',
        firstName: 'Missing',
        lastName: 'Judges',
        ataNumber: '1001',
        ageGroup: AgeGroup.youthNineTen,
        rank: BeltRank.firstDegree,
      ),
    ];
    judgesSignal.value = const [];
    generatedManualAssignmentsSignal.value = const [];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Assignments'));
    await tester.pumpAndSettle();

    expect(find.text('Round 1 - Ring 1 - 1st Degree'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_outlined), findsWidgets);
  });

  testWidgets('assignment display cycles through the current round', (
    tester,
  ) async {
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'round-1-ring-1',
        roundNumber: 1,
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [],
      ),
      GeneratedRingAssignment(
        id: 'round-1-ring-2',
        roundNumber: 1,
        ringNumber: 2,
        rank: BeltRank.secondDegree,
        competitors: [],
      ),
      GeneratedRingAssignment(
        id: 'round-2-ring-1',
        roundNumber: 2,
        ringNumber: 1,
        rank: BeltRank.thirdDegree,
        competitors: [],
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Next round'));
    await tester.pumpAndSettle();

    expect(find.text('Round 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Display round'));
    await tester.pumpAndSettle();

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Ring 1'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('Ring 2'), findsOneWidget);
    expect(find.text('2 of 2'), findsOneWidget);
    expect(find.text('3rd Degree'), findsNothing);

    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Ring 1'), findsOneWidget);
    expect(find.text('3rd Degree'), findsNothing);

    await tester.tap(find.byTooltip('Next round'));
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('Round 2'), findsOneWidget);
    expect(find.text('Ring 1'), findsWidgets);
    expect(find.text('3rd Degree'), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Close display'));
    await tester.pumpAndSettle();
  });

  testWidgets('assignment display does not truncate long names', (
    tester,
  ) async {
    const longCompetitorName = 'Alexandria Cassandra Montgomery-Worthington';
    const longJudgeName = 'Professor Maximilian Jonathan Featherstone';
    const longJudge = Judge(
      id: 'long-judge',
      name: longJudgeName,
      rank: BeltRank.fifthDegree,
      schoolId: 'north',
      qualification: JudgeQualification.center,
      isAvailable: true,
    );
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'round-1-ring-1',
        roundNumber: 1,
        ringNumber: 1,
        rank: BeltRank.firstDegree,
        competitors: [
          Competitor(
            id: 'long-competitor',
            firstName: 'Alexandria Cassandra',
            lastName: 'Montgomery-Worthington',
            ataNumber: '1001',
            ageGroup: AgeGroup.youthNineTen,
            rank: BeltRank.firstDegree,
          ),
        ],
        centerJudge: longJudge,
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Display round'));
    await tester.pumpAndSettle();

    final competitorText = tester.widget<Text>(
      find.text(longCompetitorName).last,
    );
    final judgeText = tester.widget<Text>(find.text(longJudgeName).last);

    expect(competitorText.maxLines, isNull);
    expect(competitorText.overflow, isNull);
    expect(judgeText.maxLines, isNull);
    expect(judgeText.overflow, isNull);

    await tester.tap(find.byTooltip('Close display'));
    await tester.pumpAndSettle();
  });

  testWidgets('judges screen adds and edits a judge', (tester) async {
    judgesSignal.value = const [];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Judges'));
    await tester.pumpAndSettle();

    expect(find.text('No judges yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Judge'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'First name'),
      'Nora',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Last name'),
      'Bennett',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'ATA number'),
      '730184',
    );
    await tester.enterText(find.widgetWithText(TextField, 'School'), 'north');
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nora Bennett'), findsOneWidget);
    expect(find.textContaining('ATA 730184'), findsOneWidget);

    await tester.tap(find.text('Nora Bennett'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Judge'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Last name'),
      'Foster',
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nora Foster'), findsOneWidget);
    expect(find.text('Nora Bennett'), findsNothing);
  });

  testWidgets('judges screen deletes a judge', (tester) async {
    judgesSignal.value = const [
      Judge(
        id: 'delete-me',
        name: 'Delete Me',
        ataNumber: '9911',
        rank: BeltRank.thirdDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      ),
    ];
    generatedManualAssignmentsSignal.value = const [];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Judges'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete Me'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Judge'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -160));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Me'), findsNothing);
    expect(find.text('No judges yet'), findsOneWidget);
  });

  testWidgets('judges screen clears all judges', (tester) async {
    judgesSignal.value = const [
      Judge(
        id: 'clear-me',
        name: 'Clear Me',
        ataNumber: '9911',
        rank: BeltRank.thirdDegree,
        schoolId: 'north',
        qualification: JudgeQualification.center,
        isAvailable: true,
      ),
    ];
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'assignment',
        ringNumber: 1,
        rank: BeltRank.thirdDegree,
        competitors: [],
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Judges'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear All'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear All'));
    await tester.pumpAndSettle();

    expect(judgesSignal.value, isEmpty);
    expect(generatedManualAssignmentsSignal.value, isEmpty);
    expect(find.text('No judges yet'), findsOneWidget);
  });

  testWidgets('competitors screen deletes a competitor', (tester) async {
    competitorsSignal.value = const [
      Competitor(
        id: 'delete-competitor',
        firstName: 'Delete',
        lastName: 'Competitor',
        ataNumber: '8822',
        ageGroup: AgeGroup.youthNineTen,
        rank: BeltRank.green,
      ),
    ];
    generatedManualAssignmentsSignal.value = const [];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete Competitor'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Competitor'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Competitor'), findsNothing);
    expect(find.text('No competitors yet'), findsOneWidget);
  });

  testWidgets('competitors screen clears all competitors', (tester) async {
    competitorsSignal.value = const [
      Competitor(
        id: 'clear-competitor',
        firstName: 'Clear',
        lastName: 'Competitor',
        ataNumber: '8822',
        ageGroup: AgeGroup.youthNineTen,
        rank: BeltRank.green,
      ),
    ];
    generatedManualAssignmentsSignal.value = const [
      GeneratedRingAssignment(
        id: 'assignment',
        ringNumber: 1,
        rank: BeltRank.green,
        competitors: [],
      ),
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear All'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear All'));
    await tester.pumpAndSettle();

    expect(competitorsSignal.value, isEmpty);
    expect(generatedManualAssignmentsSignal.value, isEmpty);
    expect(find.text('No competitors yet'), findsOneWidget);
  });

  testWidgets('ring screen edits ring count and rank order', (tester) async {
    ringCountSignal.value = 4;
    rankOrderSignal.value = const [
      BeltRank.firstDegree,
      BeltRank.secondDegree,
      BeltRank.white,
    ];

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rings'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '5');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(ringCountSignal.value, 5);
    expect(find.text('Rank Order'), findsOneWidget);
    expect(find.text('1st Degree'), findsOneWidget);

    await tester.tap(find.byTooltip('Move down').first);
    await tester.pumpAndSettle();

    expect(rankOrderSignal.value.first, BeltRank.secondDegree);
    expect(rankOrderSignal.value[1], BeltRank.firstDegree);
    expect(
      tester.getTopLeft(find.text('2nd Degree')).dy,
      lessThan(tester.getTopLeft(find.text('1st Degree')).dy),
    );
  });

  testWidgets('ring count field can be cleared before entering a new value', (
    tester,
  ) async {
    ringCountSignal.value = 4;

    await tester.pumpWidget(const RingAssignmentsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rings'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    final emptyField = tester.widget<TextField>(find.byType(TextField));
    expect(emptyField.controller?.text, '');
    expect(ringCountSignal.value, 4);

    await tester.enterText(find.byType(TextField), '8');
    await tester.pumpAndSettle();

    expect(ringCountSignal.value, 8);
  });
}

List<Judge> _testJudges({required int centerCount, required int cornerCount}) {
  return [
    for (var index = 0; index < centerCount; index += 1)
      Judge(
        id: 'center-$index',
        name: 'Center $index',
        rank: BeltRank.fifthDegree,
        schoolId: 'center-school-$index',
        qualification: JudgeQualification.center,
        isAvailable: true,
      ),
    for (var index = 0; index < cornerCount; index += 1)
      Judge(
        id: 'corner-$index',
        name: 'Corner $index',
        rank: BeltRank.thirdDegree,
        schoolId: 'corner-school-$index',
        qualification: JudgeQualification.corner,
        isAvailable: true,
      ),
  ];
}
