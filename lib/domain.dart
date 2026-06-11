import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain.freezed.dart';
part 'domain.g.dart';

enum EventType {
  forms,
  weapons,
  combatWeapons,
  sparring,
  creativeForms,
  creativeWeapons,
  xmaForms,
  xmaWeapons,
}

enum AgeGroup {
  tinyTigers,
  youthSevenEight,
  youthNineTen,
  youthElevenTwelve,
  teenThirteenFourteen,
  teenFifteenSeventeen,
  adultEighteenTwentyNine,
  adultThirtyThirtyNine,
  adultFortyFortyNine,
  adultFiftyFiftyNine,
  adultSixtySixtyNine,
  adultSeventySeventyNine,
}

enum BeltRank {
  white,
  orange,
  yellow,
  camo,
  green,
  purple,
  blue,
  brown,
  red,
  firstDegree,
  secondDegree,
  thirdDegree,
  fourthDegree,
  fifthDegree,
  sixthDegree,
  seventhDegree,
  eighthDegree,
  ninthDegree,
}

enum JudgeQualification {
  none,
  corner,
  center,
}

enum StaffRole {
  centerJudge,
  cornerJudge,
  timekeeper,
  scorekeeper,
}

enum AssignmentSeverity {
  ok,
  warning,
  error,
}

class Competitor {
  const Competitor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.ataNumber,
    required this.ageGroup,
    required this.rank,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String ataNumber;
  final AgeGroup ageGroup;
  final BeltRank rank;

  String get name => '$firstName $lastName';
}

class GeneratedRingAssignment {
  const GeneratedRingAssignment({
    required this.id,
    this.roundNumber = 1,
    required this.ringNumber,
    required this.rank,
    required this.competitors,
    this.centerJudge,
    this.cornerJudgeOne,
    this.cornerJudgeTwo,
  });

  final String id;
  final int roundNumber;
  final int ringNumber;
  final BeltRank rank;
  final List<Competitor> competitors;
  final Judge? centerJudge;
  final Judge? cornerJudgeOne;
  final Judge? cornerJudgeTwo;

  GeneratedRingAssignment copyWith({
    int? roundNumber,
    int? ringNumber,
    BeltRank? rank,
    List<Competitor>? competitors,
    Judge? centerJudge,
    Judge? cornerJudgeOne,
    Judge? cornerJudgeTwo,
  }) {
    return GeneratedRingAssignment(
      id: id,
      roundNumber: roundNumber ?? this.roundNumber,
      ringNumber: ringNumber ?? this.ringNumber,
      rank: rank ?? this.rank,
      competitors: competitors ?? this.competitors,
      centerJudge: centerJudge ?? this.centerJudge,
      cornerJudgeOne: cornerJudgeOne ?? this.cornerJudgeOne,
      cornerJudgeTwo: cornerJudgeTwo ?? this.cornerJudgeTwo,
    );
  }
}

@freezed
abstract class Division with _$Division {
  const factory Division({
    required String id,
    required String name,
    required EventType eventType,
    required BeltRank minRank,
    required BeltRank maxRank,
    required int competitorCount,
    required int maxCompetitorsPerRing,
    required bool requiresChampionshipRound,
  }) = _Division;

  factory Division.fromJson(Map<String, dynamic> json) =>
      _$DivisionFromJson(json);
}

@freezed
abstract class Ring with _$Ring {
  const factory Ring({
    required String id,
    required int number,
    required String name,
    required EventType eventType,
    required BeltRank minStudentRank,
    required BeltRank maxStudentRank,
    required List<String> schoolIdsRepresented,
    required bool isChampionshipRing,
    String? parentDivisionId,
    @Default([]) List<String> sourceRingIds,
    int? expectedCompetitorCount,
  }) = _Ring;

  factory Ring.fromJson(Map<String, dynamic> json) => _$RingFromJson(json);
}

@freezed
abstract class ManualRingSetup with _$ManualRingSetup {
  const factory ManualRingSetup({
    required String id,
    required int ringNumber,
    AgeGroup? ageGroup,
  }) = _ManualRingSetup;

  factory ManualRingSetup.fromJson(Map<String, dynamic> json) =>
      _$ManualRingSetupFromJson(json);
}

@freezed
abstract class RingStaffingRequirement with _$RingStaffingRequirement {
  const factory RingStaffingRequirement({
    required int centerJudges,
    required int cornerJudges,
    required int timekeepers,
    required int scorekeepers,
  }) = _RingStaffingRequirement;

  factory RingStaffingRequirement.fromJson(Map<String, dynamic> json) =>
      _$RingStaffingRequirementFromJson(json);
}

@freezed
abstract class Judge with _$Judge {
  const factory Judge({
    required String id,
    required String name,
    @Default('') String ataNumber,
    required BeltRank rank,
    required String schoolId,
    required JudgeQualification qualification,
    required bool isAvailable,
  }) = _Judge;

  factory Judge.fromJson(Map<String, dynamic> json) => _$JudgeFromJson(json);
}

@freezed
abstract class AssignmentRuleResult with _$AssignmentRuleResult {
  const factory AssignmentRuleResult({
    required bool allowed,
    required AssignmentSeverity severity,
    required String message,
  }) = _AssignmentRuleResult;

  factory AssignmentRuleResult.fromJson(Map<String, dynamic> json) =>
      _$AssignmentRuleResultFromJson(json);
}

@freezed
abstract class RingAssignment with _$RingAssignment {
  const factory RingAssignment({
    required Ring ring,
    Judge? centerJudge,
    @Default([]) List<Judge> cornerJudges,
    Judge? timekeeper,
    Judge? scorekeeper,
    @Default([]) List<AssignmentRuleResult> results,
  }) = _RingAssignment;

  factory RingAssignment.fromJson(Map<String, dynamic> json) =>
      _$RingAssignmentFromJson(json);
}

extension EventTypeDisplay on EventType {
  String get displayName {
    switch (this) {
      case EventType.forms:
        return 'Forms';
      case EventType.weapons:
        return 'Weapons';
      case EventType.combatWeapons:
        return 'Combat Weapons';
      case EventType.sparring:
        return 'Sparring';
      case EventType.creativeForms:
        return 'Creative Forms';
      case EventType.creativeWeapons:
        return 'Creative Weapons';
      case EventType.xmaForms:
        return 'XMA Forms';
      case EventType.xmaWeapons:
        return 'XMA Weapons';
    }
  }
}

extension AgeGroupDisplay on AgeGroup {
  String get displayName {
    switch (this) {
      case AgeGroup.tinyTigers:
        return 'Tiny Tigers 4-6';
      case AgeGroup.youthSevenEight:
        return 'Youth 7-8';
      case AgeGroup.youthNineTen:
        return 'Youth 9-10';
      case AgeGroup.youthElevenTwelve:
        return 'Youth 11-12';
      case AgeGroup.teenThirteenFourteen:
        return 'Teen 13-14';
      case AgeGroup.teenFifteenSeventeen:
        return 'Teen 15-17';
      case AgeGroup.adultEighteenTwentyNine:
        return 'Adult 18-29';
      case AgeGroup.adultThirtyThirtyNine:
        return 'Adult 30-39';
      case AgeGroup.adultFortyFortyNine:
        return 'Adult 40-49';
      case AgeGroup.adultFiftyFiftyNine:
        return 'Adult 50-59';
      case AgeGroup.adultSixtySixtyNine:
        return 'Adult 60-69';
      case AgeGroup.adultSeventySeventyNine:
        return 'Adult 70-79';
    }
  }
}

extension BeltRankDisplay on BeltRank {
  String get displayName {
    switch (this) {
      case BeltRank.white:
        return 'White';
      case BeltRank.orange:
        return 'Orange';
      case BeltRank.yellow:
        return 'Yellow';
      case BeltRank.camo:
        return 'Camo';
      case BeltRank.green:
        return 'Green';
      case BeltRank.purple:
        return 'Purple';
      case BeltRank.blue:
        return 'Blue';
      case BeltRank.brown:
        return 'Brown';
      case BeltRank.red:
        return 'Red';
      case BeltRank.firstDegree:
        return '1st Degree';
      case BeltRank.secondDegree:
        return '2nd Degree';
      case BeltRank.thirdDegree:
        return '3rd Degree';
      case BeltRank.fourthDegree:
        return '4th Degree';
      case BeltRank.fifthDegree:
        return '5th Degree';
      case BeltRank.sixthDegree:
        return '6th Degree';
      case BeltRank.seventhDegree:
        return '7th Degree';
      case BeltRank.eighthDegree:
        return '8th Degree';
      case BeltRank.ninthDegree:
        return '9th Degree';
    }
  }
}

extension JudgeQualificationDisplay on JudgeQualification {
  String get displayName {
    switch (this) {
      case JudgeQualification.none:
        return 'None';
      case JudgeQualification.corner:
        return 'Corner';
      case JudgeQualification.center:
        return 'Center';
    }
  }
}
