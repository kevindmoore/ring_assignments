// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Division {

 String get id; String get name; EventType get eventType; BeltRank get minRank; BeltRank get maxRank; int get competitorCount; int get maxCompetitorsPerRing; bool get requiresChampionshipRound;
/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DivisionCopyWith<Division> get copyWith => _$DivisionCopyWithImpl<Division>(this as Division, _$identity);

  /// Serializes this Division to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Division&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.minRank, minRank) || other.minRank == minRank)&&(identical(other.maxRank, maxRank) || other.maxRank == maxRank)&&(identical(other.competitorCount, competitorCount) || other.competitorCount == competitorCount)&&(identical(other.maxCompetitorsPerRing, maxCompetitorsPerRing) || other.maxCompetitorsPerRing == maxCompetitorsPerRing)&&(identical(other.requiresChampionshipRound, requiresChampionshipRound) || other.requiresChampionshipRound == requiresChampionshipRound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,eventType,minRank,maxRank,competitorCount,maxCompetitorsPerRing,requiresChampionshipRound);

@override
String toString() {
  return 'Division(id: $id, name: $name, eventType: $eventType, minRank: $minRank, maxRank: $maxRank, competitorCount: $competitorCount, maxCompetitorsPerRing: $maxCompetitorsPerRing, requiresChampionshipRound: $requiresChampionshipRound)';
}


}

/// @nodoc
abstract mixin class $DivisionCopyWith<$Res>  {
  factory $DivisionCopyWith(Division value, $Res Function(Division) _then) = _$DivisionCopyWithImpl;
@useResult
$Res call({
 String id, String name, EventType eventType, BeltRank minRank, BeltRank maxRank, int competitorCount, int maxCompetitorsPerRing, bool requiresChampionshipRound
});




}
/// @nodoc
class _$DivisionCopyWithImpl<$Res>
    implements $DivisionCopyWith<$Res> {
  _$DivisionCopyWithImpl(this._self, this._then);

  final Division _self;
  final $Res Function(Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? eventType = null,Object? minRank = null,Object? maxRank = null,Object? competitorCount = null,Object? maxCompetitorsPerRing = null,Object? requiresChampionshipRound = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,minRank: null == minRank ? _self.minRank : minRank // ignore: cast_nullable_to_non_nullable
as BeltRank,maxRank: null == maxRank ? _self.maxRank : maxRank // ignore: cast_nullable_to_non_nullable
as BeltRank,competitorCount: null == competitorCount ? _self.competitorCount : competitorCount // ignore: cast_nullable_to_non_nullable
as int,maxCompetitorsPerRing: null == maxCompetitorsPerRing ? _self.maxCompetitorsPerRing : maxCompetitorsPerRing // ignore: cast_nullable_to_non_nullable
as int,requiresChampionshipRound: null == requiresChampionshipRound ? _self.requiresChampionshipRound : requiresChampionshipRound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Division].
extension DivisionPatterns on Division {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Division value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Division value)  $default,){
final _that = this;
switch (_that) {
case _Division():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Division value)?  $default,){
final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  EventType eventType,  BeltRank minRank,  BeltRank maxRank,  int competitorCount,  int maxCompetitorsPerRing,  bool requiresChampionshipRound)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.id,_that.name,_that.eventType,_that.minRank,_that.maxRank,_that.competitorCount,_that.maxCompetitorsPerRing,_that.requiresChampionshipRound);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  EventType eventType,  BeltRank minRank,  BeltRank maxRank,  int competitorCount,  int maxCompetitorsPerRing,  bool requiresChampionshipRound)  $default,) {final _that = this;
switch (_that) {
case _Division():
return $default(_that.id,_that.name,_that.eventType,_that.minRank,_that.maxRank,_that.competitorCount,_that.maxCompetitorsPerRing,_that.requiresChampionshipRound);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  EventType eventType,  BeltRank minRank,  BeltRank maxRank,  int competitorCount,  int maxCompetitorsPerRing,  bool requiresChampionshipRound)?  $default,) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.id,_that.name,_that.eventType,_that.minRank,_that.maxRank,_that.competitorCount,_that.maxCompetitorsPerRing,_that.requiresChampionshipRound);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Division implements Division {
  const _Division({required this.id, required this.name, required this.eventType, required this.minRank, required this.maxRank, required this.competitorCount, required this.maxCompetitorsPerRing, required this.requiresChampionshipRound});
  factory _Division.fromJson(Map<String, dynamic> json) => _$DivisionFromJson(json);

@override final  String id;
@override final  String name;
@override final  EventType eventType;
@override final  BeltRank minRank;
@override final  BeltRank maxRank;
@override final  int competitorCount;
@override final  int maxCompetitorsPerRing;
@override final  bool requiresChampionshipRound;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DivisionCopyWith<_Division> get copyWith => __$DivisionCopyWithImpl<_Division>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DivisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Division&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.minRank, minRank) || other.minRank == minRank)&&(identical(other.maxRank, maxRank) || other.maxRank == maxRank)&&(identical(other.competitorCount, competitorCount) || other.competitorCount == competitorCount)&&(identical(other.maxCompetitorsPerRing, maxCompetitorsPerRing) || other.maxCompetitorsPerRing == maxCompetitorsPerRing)&&(identical(other.requiresChampionshipRound, requiresChampionshipRound) || other.requiresChampionshipRound == requiresChampionshipRound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,eventType,minRank,maxRank,competitorCount,maxCompetitorsPerRing,requiresChampionshipRound);

@override
String toString() {
  return 'Division(id: $id, name: $name, eventType: $eventType, minRank: $minRank, maxRank: $maxRank, competitorCount: $competitorCount, maxCompetitorsPerRing: $maxCompetitorsPerRing, requiresChampionshipRound: $requiresChampionshipRound)';
}


}

/// @nodoc
abstract mixin class _$DivisionCopyWith<$Res> implements $DivisionCopyWith<$Res> {
  factory _$DivisionCopyWith(_Division value, $Res Function(_Division) _then) = __$DivisionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, EventType eventType, BeltRank minRank, BeltRank maxRank, int competitorCount, int maxCompetitorsPerRing, bool requiresChampionshipRound
});




}
/// @nodoc
class __$DivisionCopyWithImpl<$Res>
    implements _$DivisionCopyWith<$Res> {
  __$DivisionCopyWithImpl(this._self, this._then);

  final _Division _self;
  final $Res Function(_Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? eventType = null,Object? minRank = null,Object? maxRank = null,Object? competitorCount = null,Object? maxCompetitorsPerRing = null,Object? requiresChampionshipRound = null,}) {
  return _then(_Division(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,minRank: null == minRank ? _self.minRank : minRank // ignore: cast_nullable_to_non_nullable
as BeltRank,maxRank: null == maxRank ? _self.maxRank : maxRank // ignore: cast_nullable_to_non_nullable
as BeltRank,competitorCount: null == competitorCount ? _self.competitorCount : competitorCount // ignore: cast_nullable_to_non_nullable
as int,maxCompetitorsPerRing: null == maxCompetitorsPerRing ? _self.maxCompetitorsPerRing : maxCompetitorsPerRing // ignore: cast_nullable_to_non_nullable
as int,requiresChampionshipRound: null == requiresChampionshipRound ? _self.requiresChampionshipRound : requiresChampionshipRound // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Ring {

 String get id; int get number; String get name; EventType get eventType; BeltRank get minStudentRank; BeltRank get maxStudentRank; List<String> get schoolIdsRepresented; bool get isChampionshipRing; String? get parentDivisionId; List<String> get sourceRingIds; int? get expectedCompetitorCount;
/// Create a copy of Ring
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RingCopyWith<Ring> get copyWith => _$RingCopyWithImpl<Ring>(this as Ring, _$identity);

  /// Serializes this Ring to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ring&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.minStudentRank, minStudentRank) || other.minStudentRank == minStudentRank)&&(identical(other.maxStudentRank, maxStudentRank) || other.maxStudentRank == maxStudentRank)&&const DeepCollectionEquality().equals(other.schoolIdsRepresented, schoolIdsRepresented)&&(identical(other.isChampionshipRing, isChampionshipRing) || other.isChampionshipRing == isChampionshipRing)&&(identical(other.parentDivisionId, parentDivisionId) || other.parentDivisionId == parentDivisionId)&&const DeepCollectionEquality().equals(other.sourceRingIds, sourceRingIds)&&(identical(other.expectedCompetitorCount, expectedCompetitorCount) || other.expectedCompetitorCount == expectedCompetitorCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,name,eventType,minStudentRank,maxStudentRank,const DeepCollectionEquality().hash(schoolIdsRepresented),isChampionshipRing,parentDivisionId,const DeepCollectionEquality().hash(sourceRingIds),expectedCompetitorCount);

@override
String toString() {
  return 'Ring(id: $id, number: $number, name: $name, eventType: $eventType, minStudentRank: $minStudentRank, maxStudentRank: $maxStudentRank, schoolIdsRepresented: $schoolIdsRepresented, isChampionshipRing: $isChampionshipRing, parentDivisionId: $parentDivisionId, sourceRingIds: $sourceRingIds, expectedCompetitorCount: $expectedCompetitorCount)';
}


}

/// @nodoc
abstract mixin class $RingCopyWith<$Res>  {
  factory $RingCopyWith(Ring value, $Res Function(Ring) _then) = _$RingCopyWithImpl;
@useResult
$Res call({
 String id, int number, String name, EventType eventType, BeltRank minStudentRank, BeltRank maxStudentRank, List<String> schoolIdsRepresented, bool isChampionshipRing, String? parentDivisionId, List<String> sourceRingIds, int? expectedCompetitorCount
});




}
/// @nodoc
class _$RingCopyWithImpl<$Res>
    implements $RingCopyWith<$Res> {
  _$RingCopyWithImpl(this._self, this._then);

  final Ring _self;
  final $Res Function(Ring) _then;

/// Create a copy of Ring
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? name = null,Object? eventType = null,Object? minStudentRank = null,Object? maxStudentRank = null,Object? schoolIdsRepresented = null,Object? isChampionshipRing = null,Object? parentDivisionId = freezed,Object? sourceRingIds = null,Object? expectedCompetitorCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,minStudentRank: null == minStudentRank ? _self.minStudentRank : minStudentRank // ignore: cast_nullable_to_non_nullable
as BeltRank,maxStudentRank: null == maxStudentRank ? _self.maxStudentRank : maxStudentRank // ignore: cast_nullable_to_non_nullable
as BeltRank,schoolIdsRepresented: null == schoolIdsRepresented ? _self.schoolIdsRepresented : schoolIdsRepresented // ignore: cast_nullable_to_non_nullable
as List<String>,isChampionshipRing: null == isChampionshipRing ? _self.isChampionshipRing : isChampionshipRing // ignore: cast_nullable_to_non_nullable
as bool,parentDivisionId: freezed == parentDivisionId ? _self.parentDivisionId : parentDivisionId // ignore: cast_nullable_to_non_nullable
as String?,sourceRingIds: null == sourceRingIds ? _self.sourceRingIds : sourceRingIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedCompetitorCount: freezed == expectedCompetitorCount ? _self.expectedCompetitorCount : expectedCompetitorCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ring].
extension RingPatterns on Ring {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ring value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ring() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ring value)  $default,){
final _that = this;
switch (_that) {
case _Ring():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ring value)?  $default,){
final _that = this;
switch (_that) {
case _Ring() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String name,  EventType eventType,  BeltRank minStudentRank,  BeltRank maxStudentRank,  List<String> schoolIdsRepresented,  bool isChampionshipRing,  String? parentDivisionId,  List<String> sourceRingIds,  int? expectedCompetitorCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ring() when $default != null:
return $default(_that.id,_that.number,_that.name,_that.eventType,_that.minStudentRank,_that.maxStudentRank,_that.schoolIdsRepresented,_that.isChampionshipRing,_that.parentDivisionId,_that.sourceRingIds,_that.expectedCompetitorCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String name,  EventType eventType,  BeltRank minStudentRank,  BeltRank maxStudentRank,  List<String> schoolIdsRepresented,  bool isChampionshipRing,  String? parentDivisionId,  List<String> sourceRingIds,  int? expectedCompetitorCount)  $default,) {final _that = this;
switch (_that) {
case _Ring():
return $default(_that.id,_that.number,_that.name,_that.eventType,_that.minStudentRank,_that.maxStudentRank,_that.schoolIdsRepresented,_that.isChampionshipRing,_that.parentDivisionId,_that.sourceRingIds,_that.expectedCompetitorCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String name,  EventType eventType,  BeltRank minStudentRank,  BeltRank maxStudentRank,  List<String> schoolIdsRepresented,  bool isChampionshipRing,  String? parentDivisionId,  List<String> sourceRingIds,  int? expectedCompetitorCount)?  $default,) {final _that = this;
switch (_that) {
case _Ring() when $default != null:
return $default(_that.id,_that.number,_that.name,_that.eventType,_that.minStudentRank,_that.maxStudentRank,_that.schoolIdsRepresented,_that.isChampionshipRing,_that.parentDivisionId,_that.sourceRingIds,_that.expectedCompetitorCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ring implements Ring {
  const _Ring({required this.id, required this.number, required this.name, required this.eventType, required this.minStudentRank, required this.maxStudentRank, required final  List<String> schoolIdsRepresented, required this.isChampionshipRing, this.parentDivisionId, final  List<String> sourceRingIds = const [], this.expectedCompetitorCount}): _schoolIdsRepresented = schoolIdsRepresented,_sourceRingIds = sourceRingIds;
  factory _Ring.fromJson(Map<String, dynamic> json) => _$RingFromJson(json);

@override final  String id;
@override final  int number;
@override final  String name;
@override final  EventType eventType;
@override final  BeltRank minStudentRank;
@override final  BeltRank maxStudentRank;
 final  List<String> _schoolIdsRepresented;
@override List<String> get schoolIdsRepresented {
  if (_schoolIdsRepresented is EqualUnmodifiableListView) return _schoolIdsRepresented;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schoolIdsRepresented);
}

@override final  bool isChampionshipRing;
@override final  String? parentDivisionId;
 final  List<String> _sourceRingIds;
@override@JsonKey() List<String> get sourceRingIds {
  if (_sourceRingIds is EqualUnmodifiableListView) return _sourceRingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sourceRingIds);
}

@override final  int? expectedCompetitorCount;

/// Create a copy of Ring
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RingCopyWith<_Ring> get copyWith => __$RingCopyWithImpl<_Ring>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ring&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.minStudentRank, minStudentRank) || other.minStudentRank == minStudentRank)&&(identical(other.maxStudentRank, maxStudentRank) || other.maxStudentRank == maxStudentRank)&&const DeepCollectionEquality().equals(other._schoolIdsRepresented, _schoolIdsRepresented)&&(identical(other.isChampionshipRing, isChampionshipRing) || other.isChampionshipRing == isChampionshipRing)&&(identical(other.parentDivisionId, parentDivisionId) || other.parentDivisionId == parentDivisionId)&&const DeepCollectionEquality().equals(other._sourceRingIds, _sourceRingIds)&&(identical(other.expectedCompetitorCount, expectedCompetitorCount) || other.expectedCompetitorCount == expectedCompetitorCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,name,eventType,minStudentRank,maxStudentRank,const DeepCollectionEquality().hash(_schoolIdsRepresented),isChampionshipRing,parentDivisionId,const DeepCollectionEquality().hash(_sourceRingIds),expectedCompetitorCount);

@override
String toString() {
  return 'Ring(id: $id, number: $number, name: $name, eventType: $eventType, minStudentRank: $minStudentRank, maxStudentRank: $maxStudentRank, schoolIdsRepresented: $schoolIdsRepresented, isChampionshipRing: $isChampionshipRing, parentDivisionId: $parentDivisionId, sourceRingIds: $sourceRingIds, expectedCompetitorCount: $expectedCompetitorCount)';
}


}

/// @nodoc
abstract mixin class _$RingCopyWith<$Res> implements $RingCopyWith<$Res> {
  factory _$RingCopyWith(_Ring value, $Res Function(_Ring) _then) = __$RingCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String name, EventType eventType, BeltRank minStudentRank, BeltRank maxStudentRank, List<String> schoolIdsRepresented, bool isChampionshipRing, String? parentDivisionId, List<String> sourceRingIds, int? expectedCompetitorCount
});




}
/// @nodoc
class __$RingCopyWithImpl<$Res>
    implements _$RingCopyWith<$Res> {
  __$RingCopyWithImpl(this._self, this._then);

  final _Ring _self;
  final $Res Function(_Ring) _then;

/// Create a copy of Ring
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? name = null,Object? eventType = null,Object? minStudentRank = null,Object? maxStudentRank = null,Object? schoolIdsRepresented = null,Object? isChampionshipRing = null,Object? parentDivisionId = freezed,Object? sourceRingIds = null,Object? expectedCompetitorCount = freezed,}) {
  return _then(_Ring(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,minStudentRank: null == minStudentRank ? _self.minStudentRank : minStudentRank // ignore: cast_nullable_to_non_nullable
as BeltRank,maxStudentRank: null == maxStudentRank ? _self.maxStudentRank : maxStudentRank // ignore: cast_nullable_to_non_nullable
as BeltRank,schoolIdsRepresented: null == schoolIdsRepresented ? _self._schoolIdsRepresented : schoolIdsRepresented // ignore: cast_nullable_to_non_nullable
as List<String>,isChampionshipRing: null == isChampionshipRing ? _self.isChampionshipRing : isChampionshipRing // ignore: cast_nullable_to_non_nullable
as bool,parentDivisionId: freezed == parentDivisionId ? _self.parentDivisionId : parentDivisionId // ignore: cast_nullable_to_non_nullable
as String?,sourceRingIds: null == sourceRingIds ? _self._sourceRingIds : sourceRingIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedCompetitorCount: freezed == expectedCompetitorCount ? _self.expectedCompetitorCount : expectedCompetitorCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ManualRingSetup {

 String get id; int get ringNumber; AgeGroup? get ageGroup;
/// Create a copy of ManualRingSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManualRingSetupCopyWith<ManualRingSetup> get copyWith => _$ManualRingSetupCopyWithImpl<ManualRingSetup>(this as ManualRingSetup, _$identity);

  /// Serializes this ManualRingSetup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManualRingSetup&&(identical(other.id, id) || other.id == id)&&(identical(other.ringNumber, ringNumber) || other.ringNumber == ringNumber)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ringNumber,ageGroup);

@override
String toString() {
  return 'ManualRingSetup(id: $id, ringNumber: $ringNumber, ageGroup: $ageGroup)';
}


}

/// @nodoc
abstract mixin class $ManualRingSetupCopyWith<$Res>  {
  factory $ManualRingSetupCopyWith(ManualRingSetup value, $Res Function(ManualRingSetup) _then) = _$ManualRingSetupCopyWithImpl;
@useResult
$Res call({
 String id, int ringNumber, AgeGroup? ageGroup
});




}
/// @nodoc
class _$ManualRingSetupCopyWithImpl<$Res>
    implements $ManualRingSetupCopyWith<$Res> {
  _$ManualRingSetupCopyWithImpl(this._self, this._then);

  final ManualRingSetup _self;
  final $Res Function(ManualRingSetup) _then;

/// Create a copy of ManualRingSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ringNumber = null,Object? ageGroup = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ringNumber: null == ringNumber ? _self.ringNumber : ringNumber // ignore: cast_nullable_to_non_nullable
as int,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as AgeGroup?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManualRingSetup].
extension ManualRingSetupPatterns on ManualRingSetup {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManualRingSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManualRingSetup() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManualRingSetup value)  $default,){
final _that = this;
switch (_that) {
case _ManualRingSetup():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManualRingSetup value)?  $default,){
final _that = this;
switch (_that) {
case _ManualRingSetup() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int ringNumber,  AgeGroup? ageGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManualRingSetup() when $default != null:
return $default(_that.id,_that.ringNumber,_that.ageGroup);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int ringNumber,  AgeGroup? ageGroup)  $default,) {final _that = this;
switch (_that) {
case _ManualRingSetup():
return $default(_that.id,_that.ringNumber,_that.ageGroup);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int ringNumber,  AgeGroup? ageGroup)?  $default,) {final _that = this;
switch (_that) {
case _ManualRingSetup() when $default != null:
return $default(_that.id,_that.ringNumber,_that.ageGroup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManualRingSetup implements ManualRingSetup {
  const _ManualRingSetup({required this.id, required this.ringNumber, this.ageGroup});
  factory _ManualRingSetup.fromJson(Map<String, dynamic> json) => _$ManualRingSetupFromJson(json);

@override final  String id;
@override final  int ringNumber;
@override final  AgeGroup? ageGroup;

/// Create a copy of ManualRingSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManualRingSetupCopyWith<_ManualRingSetup> get copyWith => __$ManualRingSetupCopyWithImpl<_ManualRingSetup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManualRingSetupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManualRingSetup&&(identical(other.id, id) || other.id == id)&&(identical(other.ringNumber, ringNumber) || other.ringNumber == ringNumber)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ringNumber,ageGroup);

@override
String toString() {
  return 'ManualRingSetup(id: $id, ringNumber: $ringNumber, ageGroup: $ageGroup)';
}


}

/// @nodoc
abstract mixin class _$ManualRingSetupCopyWith<$Res> implements $ManualRingSetupCopyWith<$Res> {
  factory _$ManualRingSetupCopyWith(_ManualRingSetup value, $Res Function(_ManualRingSetup) _then) = __$ManualRingSetupCopyWithImpl;
@override @useResult
$Res call({
 String id, int ringNumber, AgeGroup? ageGroup
});




}
/// @nodoc
class __$ManualRingSetupCopyWithImpl<$Res>
    implements _$ManualRingSetupCopyWith<$Res> {
  __$ManualRingSetupCopyWithImpl(this._self, this._then);

  final _ManualRingSetup _self;
  final $Res Function(_ManualRingSetup) _then;

/// Create a copy of ManualRingSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ringNumber = null,Object? ageGroup = freezed,}) {
  return _then(_ManualRingSetup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ringNumber: null == ringNumber ? _self.ringNumber : ringNumber // ignore: cast_nullable_to_non_nullable
as int,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as AgeGroup?,
  ));
}


}


/// @nodoc
mixin _$RingStaffingRequirement {

 int get centerJudges; int get cornerJudges; int get timekeepers; int get scorekeepers;
/// Create a copy of RingStaffingRequirement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RingStaffingRequirementCopyWith<RingStaffingRequirement> get copyWith => _$RingStaffingRequirementCopyWithImpl<RingStaffingRequirement>(this as RingStaffingRequirement, _$identity);

  /// Serializes this RingStaffingRequirement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RingStaffingRequirement&&(identical(other.centerJudges, centerJudges) || other.centerJudges == centerJudges)&&(identical(other.cornerJudges, cornerJudges) || other.cornerJudges == cornerJudges)&&(identical(other.timekeepers, timekeepers) || other.timekeepers == timekeepers)&&(identical(other.scorekeepers, scorekeepers) || other.scorekeepers == scorekeepers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,centerJudges,cornerJudges,timekeepers,scorekeepers);

@override
String toString() {
  return 'RingStaffingRequirement(centerJudges: $centerJudges, cornerJudges: $cornerJudges, timekeepers: $timekeepers, scorekeepers: $scorekeepers)';
}


}

/// @nodoc
abstract mixin class $RingStaffingRequirementCopyWith<$Res>  {
  factory $RingStaffingRequirementCopyWith(RingStaffingRequirement value, $Res Function(RingStaffingRequirement) _then) = _$RingStaffingRequirementCopyWithImpl;
@useResult
$Res call({
 int centerJudges, int cornerJudges, int timekeepers, int scorekeepers
});




}
/// @nodoc
class _$RingStaffingRequirementCopyWithImpl<$Res>
    implements $RingStaffingRequirementCopyWith<$Res> {
  _$RingStaffingRequirementCopyWithImpl(this._self, this._then);

  final RingStaffingRequirement _self;
  final $Res Function(RingStaffingRequirement) _then;

/// Create a copy of RingStaffingRequirement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? centerJudges = null,Object? cornerJudges = null,Object? timekeepers = null,Object? scorekeepers = null,}) {
  return _then(_self.copyWith(
centerJudges: null == centerJudges ? _self.centerJudges : centerJudges // ignore: cast_nullable_to_non_nullable
as int,cornerJudges: null == cornerJudges ? _self.cornerJudges : cornerJudges // ignore: cast_nullable_to_non_nullable
as int,timekeepers: null == timekeepers ? _self.timekeepers : timekeepers // ignore: cast_nullable_to_non_nullable
as int,scorekeepers: null == scorekeepers ? _self.scorekeepers : scorekeepers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RingStaffingRequirement].
extension RingStaffingRequirementPatterns on RingStaffingRequirement {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RingStaffingRequirement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RingStaffingRequirement() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RingStaffingRequirement value)  $default,){
final _that = this;
switch (_that) {
case _RingStaffingRequirement():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RingStaffingRequirement value)?  $default,){
final _that = this;
switch (_that) {
case _RingStaffingRequirement() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int centerJudges,  int cornerJudges,  int timekeepers,  int scorekeepers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RingStaffingRequirement() when $default != null:
return $default(_that.centerJudges,_that.cornerJudges,_that.timekeepers,_that.scorekeepers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int centerJudges,  int cornerJudges,  int timekeepers,  int scorekeepers)  $default,) {final _that = this;
switch (_that) {
case _RingStaffingRequirement():
return $default(_that.centerJudges,_that.cornerJudges,_that.timekeepers,_that.scorekeepers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int centerJudges,  int cornerJudges,  int timekeepers,  int scorekeepers)?  $default,) {final _that = this;
switch (_that) {
case _RingStaffingRequirement() when $default != null:
return $default(_that.centerJudges,_that.cornerJudges,_that.timekeepers,_that.scorekeepers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RingStaffingRequirement implements RingStaffingRequirement {
  const _RingStaffingRequirement({required this.centerJudges, required this.cornerJudges, required this.timekeepers, required this.scorekeepers});
  factory _RingStaffingRequirement.fromJson(Map<String, dynamic> json) => _$RingStaffingRequirementFromJson(json);

@override final  int centerJudges;
@override final  int cornerJudges;
@override final  int timekeepers;
@override final  int scorekeepers;

/// Create a copy of RingStaffingRequirement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RingStaffingRequirementCopyWith<_RingStaffingRequirement> get copyWith => __$RingStaffingRequirementCopyWithImpl<_RingStaffingRequirement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RingStaffingRequirementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RingStaffingRequirement&&(identical(other.centerJudges, centerJudges) || other.centerJudges == centerJudges)&&(identical(other.cornerJudges, cornerJudges) || other.cornerJudges == cornerJudges)&&(identical(other.timekeepers, timekeepers) || other.timekeepers == timekeepers)&&(identical(other.scorekeepers, scorekeepers) || other.scorekeepers == scorekeepers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,centerJudges,cornerJudges,timekeepers,scorekeepers);

@override
String toString() {
  return 'RingStaffingRequirement(centerJudges: $centerJudges, cornerJudges: $cornerJudges, timekeepers: $timekeepers, scorekeepers: $scorekeepers)';
}


}

/// @nodoc
abstract mixin class _$RingStaffingRequirementCopyWith<$Res> implements $RingStaffingRequirementCopyWith<$Res> {
  factory _$RingStaffingRequirementCopyWith(_RingStaffingRequirement value, $Res Function(_RingStaffingRequirement) _then) = __$RingStaffingRequirementCopyWithImpl;
@override @useResult
$Res call({
 int centerJudges, int cornerJudges, int timekeepers, int scorekeepers
});




}
/// @nodoc
class __$RingStaffingRequirementCopyWithImpl<$Res>
    implements _$RingStaffingRequirementCopyWith<$Res> {
  __$RingStaffingRequirementCopyWithImpl(this._self, this._then);

  final _RingStaffingRequirement _self;
  final $Res Function(_RingStaffingRequirement) _then;

/// Create a copy of RingStaffingRequirement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? centerJudges = null,Object? cornerJudges = null,Object? timekeepers = null,Object? scorekeepers = null,}) {
  return _then(_RingStaffingRequirement(
centerJudges: null == centerJudges ? _self.centerJudges : centerJudges // ignore: cast_nullable_to_non_nullable
as int,cornerJudges: null == cornerJudges ? _self.cornerJudges : cornerJudges // ignore: cast_nullable_to_non_nullable
as int,timekeepers: null == timekeepers ? _self.timekeepers : timekeepers // ignore: cast_nullable_to_non_nullable
as int,scorekeepers: null == scorekeepers ? _self.scorekeepers : scorekeepers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Judge {

 String get id; String get name; String get ataNumber; BeltRank get rank; String get schoolId; JudgeQualification get qualification; bool get isAvailable;
/// Create a copy of Judge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JudgeCopyWith<Judge> get copyWith => _$JudgeCopyWithImpl<Judge>(this as Judge, _$identity);

  /// Serializes this Judge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Judge&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ataNumber, ataNumber) || other.ataNumber == ataNumber)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ataNumber,rank,schoolId,qualification,isAvailable);

@override
String toString() {
  return 'Judge(id: $id, name: $name, ataNumber: $ataNumber, rank: $rank, schoolId: $schoolId, qualification: $qualification, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $JudgeCopyWith<$Res>  {
  factory $JudgeCopyWith(Judge value, $Res Function(Judge) _then) = _$JudgeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String ataNumber, BeltRank rank, String schoolId, JudgeQualification qualification, bool isAvailable
});




}
/// @nodoc
class _$JudgeCopyWithImpl<$Res>
    implements $JudgeCopyWith<$Res> {
  _$JudgeCopyWithImpl(this._self, this._then);

  final Judge _self;
  final $Res Function(Judge) _then;

/// Create a copy of Judge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ataNumber = null,Object? rank = null,Object? schoolId = null,Object? qualification = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ataNumber: null == ataNumber ? _self.ataNumber : ataNumber // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as BeltRank,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as JudgeQualification,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Judge].
extension JudgePatterns on Judge {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Judge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Judge() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Judge value)  $default,){
final _that = this;
switch (_that) {
case _Judge():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Judge value)?  $default,){
final _that = this;
switch (_that) {
case _Judge() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String ataNumber,  BeltRank rank,  String schoolId,  JudgeQualification qualification,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Judge() when $default != null:
return $default(_that.id,_that.name,_that.ataNumber,_that.rank,_that.schoolId,_that.qualification,_that.isAvailable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String ataNumber,  BeltRank rank,  String schoolId,  JudgeQualification qualification,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _Judge():
return $default(_that.id,_that.name,_that.ataNumber,_that.rank,_that.schoolId,_that.qualification,_that.isAvailable);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String ataNumber,  BeltRank rank,  String schoolId,  JudgeQualification qualification,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _Judge() when $default != null:
return $default(_that.id,_that.name,_that.ataNumber,_that.rank,_that.schoolId,_that.qualification,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Judge implements Judge {
  const _Judge({required this.id, required this.name, this.ataNumber = '', required this.rank, required this.schoolId, required this.qualification, required this.isAvailable});
  factory _Judge.fromJson(Map<String, dynamic> json) => _$JudgeFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String ataNumber;
@override final  BeltRank rank;
@override final  String schoolId;
@override final  JudgeQualification qualification;
@override final  bool isAvailable;

/// Create a copy of Judge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JudgeCopyWith<_Judge> get copyWith => __$JudgeCopyWithImpl<_Judge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JudgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Judge&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ataNumber, ataNumber) || other.ataNumber == ataNumber)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ataNumber,rank,schoolId,qualification,isAvailable);

@override
String toString() {
  return 'Judge(id: $id, name: $name, ataNumber: $ataNumber, rank: $rank, schoolId: $schoolId, qualification: $qualification, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$JudgeCopyWith<$Res> implements $JudgeCopyWith<$Res> {
  factory _$JudgeCopyWith(_Judge value, $Res Function(_Judge) _then) = __$JudgeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String ataNumber, BeltRank rank, String schoolId, JudgeQualification qualification, bool isAvailable
});




}
/// @nodoc
class __$JudgeCopyWithImpl<$Res>
    implements _$JudgeCopyWith<$Res> {
  __$JudgeCopyWithImpl(this._self, this._then);

  final _Judge _self;
  final $Res Function(_Judge) _then;

/// Create a copy of Judge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ataNumber = null,Object? rank = null,Object? schoolId = null,Object? qualification = null,Object? isAvailable = null,}) {
  return _then(_Judge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ataNumber: null == ataNumber ? _self.ataNumber : ataNumber // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as BeltRank,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as JudgeQualification,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AssignmentRuleResult {

 bool get allowed; AssignmentSeverity get severity; String get message;
/// Create a copy of AssignmentRuleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentRuleResultCopyWith<AssignmentRuleResult> get copyWith => _$AssignmentRuleResultCopyWithImpl<AssignmentRuleResult>(this as AssignmentRuleResult, _$identity);

  /// Serializes this AssignmentRuleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignmentRuleResult&&(identical(other.allowed, allowed) || other.allowed == allowed)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowed,severity,message);

@override
String toString() {
  return 'AssignmentRuleResult(allowed: $allowed, severity: $severity, message: $message)';
}


}

/// @nodoc
abstract mixin class $AssignmentRuleResultCopyWith<$Res>  {
  factory $AssignmentRuleResultCopyWith(AssignmentRuleResult value, $Res Function(AssignmentRuleResult) _then) = _$AssignmentRuleResultCopyWithImpl;
@useResult
$Res call({
 bool allowed, AssignmentSeverity severity, String message
});




}
/// @nodoc
class _$AssignmentRuleResultCopyWithImpl<$Res>
    implements $AssignmentRuleResultCopyWith<$Res> {
  _$AssignmentRuleResultCopyWithImpl(this._self, this._then);

  final AssignmentRuleResult _self;
  final $Res Function(AssignmentRuleResult) _then;

/// Create a copy of AssignmentRuleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowed = null,Object? severity = null,Object? message = null,}) {
  return _then(_self.copyWith(
allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AssignmentSeverity,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignmentRuleResult].
extension AssignmentRuleResultPatterns on AssignmentRuleResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignmentRuleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignmentRuleResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignmentRuleResult value)  $default,){
final _that = this;
switch (_that) {
case _AssignmentRuleResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignmentRuleResult value)?  $default,){
final _that = this;
switch (_that) {
case _AssignmentRuleResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allowed,  AssignmentSeverity severity,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignmentRuleResult() when $default != null:
return $default(_that.allowed,_that.severity,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allowed,  AssignmentSeverity severity,  String message)  $default,) {final _that = this;
switch (_that) {
case _AssignmentRuleResult():
return $default(_that.allowed,_that.severity,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allowed,  AssignmentSeverity severity,  String message)?  $default,) {final _that = this;
switch (_that) {
case _AssignmentRuleResult() when $default != null:
return $default(_that.allowed,_that.severity,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignmentRuleResult implements AssignmentRuleResult {
  const _AssignmentRuleResult({required this.allowed, required this.severity, required this.message});
  factory _AssignmentRuleResult.fromJson(Map<String, dynamic> json) => _$AssignmentRuleResultFromJson(json);

@override final  bool allowed;
@override final  AssignmentSeverity severity;
@override final  String message;

/// Create a copy of AssignmentRuleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentRuleResultCopyWith<_AssignmentRuleResult> get copyWith => __$AssignmentRuleResultCopyWithImpl<_AssignmentRuleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentRuleResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignmentRuleResult&&(identical(other.allowed, allowed) || other.allowed == allowed)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowed,severity,message);

@override
String toString() {
  return 'AssignmentRuleResult(allowed: $allowed, severity: $severity, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AssignmentRuleResultCopyWith<$Res> implements $AssignmentRuleResultCopyWith<$Res> {
  factory _$AssignmentRuleResultCopyWith(_AssignmentRuleResult value, $Res Function(_AssignmentRuleResult) _then) = __$AssignmentRuleResultCopyWithImpl;
@override @useResult
$Res call({
 bool allowed, AssignmentSeverity severity, String message
});




}
/// @nodoc
class __$AssignmentRuleResultCopyWithImpl<$Res>
    implements _$AssignmentRuleResultCopyWith<$Res> {
  __$AssignmentRuleResultCopyWithImpl(this._self, this._then);

  final _AssignmentRuleResult _self;
  final $Res Function(_AssignmentRuleResult) _then;

/// Create a copy of AssignmentRuleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allowed = null,Object? severity = null,Object? message = null,}) {
  return _then(_AssignmentRuleResult(
allowed: null == allowed ? _self.allowed : allowed // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AssignmentSeverity,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RingAssignment {

 Ring get ring; Judge? get centerJudge; List<Judge> get cornerJudges; Judge? get timekeeper; Judge? get scorekeeper; List<AssignmentRuleResult> get results;
/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RingAssignmentCopyWith<RingAssignment> get copyWith => _$RingAssignmentCopyWithImpl<RingAssignment>(this as RingAssignment, _$identity);

  /// Serializes this RingAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RingAssignment&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.centerJudge, centerJudge) || other.centerJudge == centerJudge)&&const DeepCollectionEquality().equals(other.cornerJudges, cornerJudges)&&(identical(other.timekeeper, timekeeper) || other.timekeeper == timekeeper)&&(identical(other.scorekeeper, scorekeeper) || other.scorekeeper == scorekeeper)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ring,centerJudge,const DeepCollectionEquality().hash(cornerJudges),timekeeper,scorekeeper,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'RingAssignment(ring: $ring, centerJudge: $centerJudge, cornerJudges: $cornerJudges, timekeeper: $timekeeper, scorekeeper: $scorekeeper, results: $results)';
}


}

/// @nodoc
abstract mixin class $RingAssignmentCopyWith<$Res>  {
  factory $RingAssignmentCopyWith(RingAssignment value, $Res Function(RingAssignment) _then) = _$RingAssignmentCopyWithImpl;
@useResult
$Res call({
 Ring ring, Judge? centerJudge, List<Judge> cornerJudges, Judge? timekeeper, Judge? scorekeeper, List<AssignmentRuleResult> results
});


$RingCopyWith<$Res> get ring;$JudgeCopyWith<$Res>? get centerJudge;$JudgeCopyWith<$Res>? get timekeeper;$JudgeCopyWith<$Res>? get scorekeeper;

}
/// @nodoc
class _$RingAssignmentCopyWithImpl<$Res>
    implements $RingAssignmentCopyWith<$Res> {
  _$RingAssignmentCopyWithImpl(this._self, this._then);

  final RingAssignment _self;
  final $Res Function(RingAssignment) _then;

/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ring = null,Object? centerJudge = freezed,Object? cornerJudges = null,Object? timekeeper = freezed,Object? scorekeeper = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
ring: null == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as Ring,centerJudge: freezed == centerJudge ? _self.centerJudge : centerJudge // ignore: cast_nullable_to_non_nullable
as Judge?,cornerJudges: null == cornerJudges ? _self.cornerJudges : cornerJudges // ignore: cast_nullable_to_non_nullable
as List<Judge>,timekeeper: freezed == timekeeper ? _self.timekeeper : timekeeper // ignore: cast_nullable_to_non_nullable
as Judge?,scorekeeper: freezed == scorekeeper ? _self.scorekeeper : scorekeeper // ignore: cast_nullable_to_non_nullable
as Judge?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<AssignmentRuleResult>,
  ));
}
/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RingCopyWith<$Res> get ring {
  
  return $RingCopyWith<$Res>(_self.ring, (value) {
    return _then(_self.copyWith(ring: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get centerJudge {
    if (_self.centerJudge == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.centerJudge!, (value) {
    return _then(_self.copyWith(centerJudge: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get timekeeper {
    if (_self.timekeeper == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.timekeeper!, (value) {
    return _then(_self.copyWith(timekeeper: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get scorekeeper {
    if (_self.scorekeeper == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.scorekeeper!, (value) {
    return _then(_self.copyWith(scorekeeper: value));
  });
}
}


/// Adds pattern-matching-related methods to [RingAssignment].
extension RingAssignmentPatterns on RingAssignment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RingAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RingAssignment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RingAssignment value)  $default,){
final _that = this;
switch (_that) {
case _RingAssignment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RingAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _RingAssignment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Ring ring,  Judge? centerJudge,  List<Judge> cornerJudges,  Judge? timekeeper,  Judge? scorekeeper,  List<AssignmentRuleResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RingAssignment() when $default != null:
return $default(_that.ring,_that.centerJudge,_that.cornerJudges,_that.timekeeper,_that.scorekeeper,_that.results);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Ring ring,  Judge? centerJudge,  List<Judge> cornerJudges,  Judge? timekeeper,  Judge? scorekeeper,  List<AssignmentRuleResult> results)  $default,) {final _that = this;
switch (_that) {
case _RingAssignment():
return $default(_that.ring,_that.centerJudge,_that.cornerJudges,_that.timekeeper,_that.scorekeeper,_that.results);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Ring ring,  Judge? centerJudge,  List<Judge> cornerJudges,  Judge? timekeeper,  Judge? scorekeeper,  List<AssignmentRuleResult> results)?  $default,) {final _that = this;
switch (_that) {
case _RingAssignment() when $default != null:
return $default(_that.ring,_that.centerJudge,_that.cornerJudges,_that.timekeeper,_that.scorekeeper,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RingAssignment implements RingAssignment {
  const _RingAssignment({required this.ring, this.centerJudge, final  List<Judge> cornerJudges = const [], this.timekeeper, this.scorekeeper, final  List<AssignmentRuleResult> results = const []}): _cornerJudges = cornerJudges,_results = results;
  factory _RingAssignment.fromJson(Map<String, dynamic> json) => _$RingAssignmentFromJson(json);

@override final  Ring ring;
@override final  Judge? centerJudge;
 final  List<Judge> _cornerJudges;
@override@JsonKey() List<Judge> get cornerJudges {
  if (_cornerJudges is EqualUnmodifiableListView) return _cornerJudges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cornerJudges);
}

@override final  Judge? timekeeper;
@override final  Judge? scorekeeper;
 final  List<AssignmentRuleResult> _results;
@override@JsonKey() List<AssignmentRuleResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RingAssignmentCopyWith<_RingAssignment> get copyWith => __$RingAssignmentCopyWithImpl<_RingAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RingAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RingAssignment&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.centerJudge, centerJudge) || other.centerJudge == centerJudge)&&const DeepCollectionEquality().equals(other._cornerJudges, _cornerJudges)&&(identical(other.timekeeper, timekeeper) || other.timekeeper == timekeeper)&&(identical(other.scorekeeper, scorekeeper) || other.scorekeeper == scorekeeper)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ring,centerJudge,const DeepCollectionEquality().hash(_cornerJudges),timekeeper,scorekeeper,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'RingAssignment(ring: $ring, centerJudge: $centerJudge, cornerJudges: $cornerJudges, timekeeper: $timekeeper, scorekeeper: $scorekeeper, results: $results)';
}


}

/// @nodoc
abstract mixin class _$RingAssignmentCopyWith<$Res> implements $RingAssignmentCopyWith<$Res> {
  factory _$RingAssignmentCopyWith(_RingAssignment value, $Res Function(_RingAssignment) _then) = __$RingAssignmentCopyWithImpl;
@override @useResult
$Res call({
 Ring ring, Judge? centerJudge, List<Judge> cornerJudges, Judge? timekeeper, Judge? scorekeeper, List<AssignmentRuleResult> results
});


@override $RingCopyWith<$Res> get ring;@override $JudgeCopyWith<$Res>? get centerJudge;@override $JudgeCopyWith<$Res>? get timekeeper;@override $JudgeCopyWith<$Res>? get scorekeeper;

}
/// @nodoc
class __$RingAssignmentCopyWithImpl<$Res>
    implements _$RingAssignmentCopyWith<$Res> {
  __$RingAssignmentCopyWithImpl(this._self, this._then);

  final _RingAssignment _self;
  final $Res Function(_RingAssignment) _then;

/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ring = null,Object? centerJudge = freezed,Object? cornerJudges = null,Object? timekeeper = freezed,Object? scorekeeper = freezed,Object? results = null,}) {
  return _then(_RingAssignment(
ring: null == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as Ring,centerJudge: freezed == centerJudge ? _self.centerJudge : centerJudge // ignore: cast_nullable_to_non_nullable
as Judge?,cornerJudges: null == cornerJudges ? _self._cornerJudges : cornerJudges // ignore: cast_nullable_to_non_nullable
as List<Judge>,timekeeper: freezed == timekeeper ? _self.timekeeper : timekeeper // ignore: cast_nullable_to_non_nullable
as Judge?,scorekeeper: freezed == scorekeeper ? _self.scorekeeper : scorekeeper // ignore: cast_nullable_to_non_nullable
as Judge?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<AssignmentRuleResult>,
  ));
}

/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RingCopyWith<$Res> get ring {
  
  return $RingCopyWith<$Res>(_self.ring, (value) {
    return _then(_self.copyWith(ring: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get centerJudge {
    if (_self.centerJudge == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.centerJudge!, (value) {
    return _then(_self.copyWith(centerJudge: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get timekeeper {
    if (_self.timekeeper == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.timekeeper!, (value) {
    return _then(_self.copyWith(timekeeper: value));
  });
}/// Create a copy of RingAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JudgeCopyWith<$Res>? get scorekeeper {
    if (_self.scorekeeper == null) {
    return null;
  }

  return $JudgeCopyWith<$Res>(_self.scorekeeper!, (value) {
    return _then(_self.copyWith(scorekeeper: value));
  });
}
}

// dart format on
