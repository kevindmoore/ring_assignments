// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Division _$DivisionFromJson(Map<String, dynamic> json) => _Division(
  id: json['id'] as String,
  name: json['name'] as String,
  eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
  minRank: $enumDecode(_$BeltRankEnumMap, json['minRank']),
  maxRank: $enumDecode(_$BeltRankEnumMap, json['maxRank']),
  competitorCount: (json['competitorCount'] as num).toInt(),
  maxCompetitorsPerRing: (json['maxCompetitorsPerRing'] as num).toInt(),
  requiresChampionshipRound: json['requiresChampionshipRound'] as bool,
);

Map<String, dynamic> _$DivisionToJson(_Division instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'eventType': _$EventTypeEnumMap[instance.eventType]!,
  'minRank': _$BeltRankEnumMap[instance.minRank]!,
  'maxRank': _$BeltRankEnumMap[instance.maxRank]!,
  'competitorCount': instance.competitorCount,
  'maxCompetitorsPerRing': instance.maxCompetitorsPerRing,
  'requiresChampionshipRound': instance.requiresChampionshipRound,
};

const _$EventTypeEnumMap = {
  EventType.forms: 'forms',
  EventType.weapons: 'weapons',
  EventType.combatWeapons: 'combatWeapons',
  EventType.sparring: 'sparring',
  EventType.creativeForms: 'creativeForms',
  EventType.creativeWeapons: 'creativeWeapons',
  EventType.xmaForms: 'xmaForms',
  EventType.xmaWeapons: 'xmaWeapons',
};

const _$BeltRankEnumMap = {
  BeltRank.white: 'white',
  BeltRank.orange: 'orange',
  BeltRank.yellow: 'yellow',
  BeltRank.camo: 'camo',
  BeltRank.green: 'green',
  BeltRank.purple: 'purple',
  BeltRank.blue: 'blue',
  BeltRank.brown: 'brown',
  BeltRank.red: 'red',
  BeltRank.firstDegree: 'firstDegree',
  BeltRank.secondDegree: 'secondDegree',
  BeltRank.thirdDegree: 'thirdDegree',
  BeltRank.fourthDegree: 'fourthDegree',
  BeltRank.fifthDegree: 'fifthDegree',
  BeltRank.sixthDegree: 'sixthDegree',
  BeltRank.seventhDegree: 'seventhDegree',
  BeltRank.eighthDegree: 'eighthDegree',
  BeltRank.ninthDegree: 'ninthDegree',
};

_Ring _$RingFromJson(Map<String, dynamic> json) => _Ring(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
  minStudentRank: $enumDecode(_$BeltRankEnumMap, json['minStudentRank']),
  maxStudentRank: $enumDecode(_$BeltRankEnumMap, json['maxStudentRank']),
  schoolIdsRepresented: (json['schoolIdsRepresented'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isChampionshipRing: json['isChampionshipRing'] as bool,
  parentDivisionId: json['parentDivisionId'] as String?,
  sourceRingIds:
      (json['sourceRingIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  expectedCompetitorCount: (json['expectedCompetitorCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$RingToJson(_Ring instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'name': instance.name,
  'eventType': _$EventTypeEnumMap[instance.eventType]!,
  'minStudentRank': _$BeltRankEnumMap[instance.minStudentRank]!,
  'maxStudentRank': _$BeltRankEnumMap[instance.maxStudentRank]!,
  'schoolIdsRepresented': instance.schoolIdsRepresented,
  'isChampionshipRing': instance.isChampionshipRing,
  'parentDivisionId': instance.parentDivisionId,
  'sourceRingIds': instance.sourceRingIds,
  'expectedCompetitorCount': instance.expectedCompetitorCount,
};

_ManualRingSetup _$ManualRingSetupFromJson(Map<String, dynamic> json) =>
    _ManualRingSetup(
      id: json['id'] as String,
      ringNumber: (json['ringNumber'] as num).toInt(),
      ageGroup: $enumDecodeNullable(_$AgeGroupEnumMap, json['ageGroup']),
    );

Map<String, dynamic> _$ManualRingSetupToJson(_ManualRingSetup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ringNumber': instance.ringNumber,
      'ageGroup': _$AgeGroupEnumMap[instance.ageGroup],
    };

const _$AgeGroupEnumMap = {
  AgeGroup.tinyTigers: 'tinyTigers',
  AgeGroup.youthSevenEight: 'youthSevenEight',
  AgeGroup.youthNineTen: 'youthNineTen',
  AgeGroup.youthElevenTwelve: 'youthElevenTwelve',
  AgeGroup.teenThirteenFourteen: 'teenThirteenFourteen',
  AgeGroup.teenFifteenSeventeen: 'teenFifteenSeventeen',
  AgeGroup.adultEighteenTwentyNine: 'adultEighteenTwentyNine',
  AgeGroup.adultThirtyThirtyNine: 'adultThirtyThirtyNine',
  AgeGroup.adultFortyFortyNine: 'adultFortyFortyNine',
  AgeGroup.adultFiftyFiftyNine: 'adultFiftyFiftyNine',
  AgeGroup.adultSixtySixtyNine: 'adultSixtySixtyNine',
  AgeGroup.adultSeventySeventyNine: 'adultSeventySeventyNine',
};

_RingStaffingRequirement _$RingStaffingRequirementFromJson(
  Map<String, dynamic> json,
) => _RingStaffingRequirement(
  centerJudges: (json['centerJudges'] as num).toInt(),
  cornerJudges: (json['cornerJudges'] as num).toInt(),
  timekeepers: (json['timekeepers'] as num).toInt(),
  scorekeepers: (json['scorekeepers'] as num).toInt(),
);

Map<String, dynamic> _$RingStaffingRequirementToJson(
  _RingStaffingRequirement instance,
) => <String, dynamic>{
  'centerJudges': instance.centerJudges,
  'cornerJudges': instance.cornerJudges,
  'timekeepers': instance.timekeepers,
  'scorekeepers': instance.scorekeepers,
};

_Judge _$JudgeFromJson(Map<String, dynamic> json) => _Judge(
  id: json['id'] as String,
  name: json['name'] as String,
  ataNumber: json['ataNumber'] as String? ?? '',
  rank: $enumDecode(_$BeltRankEnumMap, json['rank']),
  schoolId: json['schoolId'] as String,
  qualification: $enumDecode(
    _$JudgeQualificationEnumMap,
    json['qualification'],
  ),
  isAvailable: json['isAvailable'] as bool,
);

Map<String, dynamic> _$JudgeToJson(_Judge instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'ataNumber': instance.ataNumber,
  'rank': _$BeltRankEnumMap[instance.rank]!,
  'schoolId': instance.schoolId,
  'qualification': _$JudgeQualificationEnumMap[instance.qualification]!,
  'isAvailable': instance.isAvailable,
};

const _$JudgeQualificationEnumMap = {
  JudgeQualification.none: 'none',
  JudgeQualification.corner: 'corner',
  JudgeQualification.center: 'center',
};

_AssignmentRuleResult _$AssignmentRuleResultFromJson(
  Map<String, dynamic> json,
) => _AssignmentRuleResult(
  allowed: json['allowed'] as bool,
  severity: $enumDecode(_$AssignmentSeverityEnumMap, json['severity']),
  message: json['message'] as String,
);

Map<String, dynamic> _$AssignmentRuleResultToJson(
  _AssignmentRuleResult instance,
) => <String, dynamic>{
  'allowed': instance.allowed,
  'severity': _$AssignmentSeverityEnumMap[instance.severity]!,
  'message': instance.message,
};

const _$AssignmentSeverityEnumMap = {
  AssignmentSeverity.ok: 'ok',
  AssignmentSeverity.warning: 'warning',
  AssignmentSeverity.error: 'error',
};

_RingAssignment _$RingAssignmentFromJson(Map<String, dynamic> json) =>
    _RingAssignment(
      ring: Ring.fromJson(json['ring'] as Map<String, dynamic>),
      centerJudge: json['centerJudge'] == null
          ? null
          : Judge.fromJson(json['centerJudge'] as Map<String, dynamic>),
      cornerJudges:
          (json['cornerJudges'] as List<dynamic>?)
              ?.map((e) => Judge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timekeeper: json['timekeeper'] == null
          ? null
          : Judge.fromJson(json['timekeeper'] as Map<String, dynamic>),
      scorekeeper: json['scorekeeper'] == null
          ? null
          : Judge.fromJson(json['scorekeeper'] as Map<String, dynamic>),
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (e) => AssignmentRuleResult.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RingAssignmentToJson(_RingAssignment instance) =>
    <String, dynamic>{
      'ring': instance.ring,
      'centerJudge': instance.centerJudge,
      'cornerJudges': instance.cornerJudges,
      'timekeeper': instance.timekeeper,
      'scorekeeper': instance.scorekeeper,
      'results': instance.results,
    };
