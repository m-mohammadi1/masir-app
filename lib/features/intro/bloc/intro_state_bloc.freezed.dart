// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intro_state_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IntroStateEvent {

 int get value;
/// Create a copy of IntroStateEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroStateEventCopyWith<IntroStateEvent> get copyWith => _$IntroStateEventCopyWithImpl<IntroStateEvent>(this as IntroStateEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroStateEvent&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'IntroStateEvent(value: $value)';
}


}

/// @nodoc
abstract mixin class $IntroStateEventCopyWith<$Res>  {
  factory $IntroStateEventCopyWith(IntroStateEvent value, $Res Function(IntroStateEvent) _then) = _$IntroStateEventCopyWithImpl;
@useResult
$Res call({
 int value
});




}
/// @nodoc
class _$IntroStateEventCopyWithImpl<$Res>
    implements $IntroStateEventCopyWith<$Res> {
  _$IntroStateEventCopyWithImpl(this._self, this._then);

  final IntroStateEvent _self;
  final $Res Function(IntroStateEvent) _then;

/// Create a copy of IntroStateEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IntroStateEvent].
extension IntroStateEventPatterns on IntroStateEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangeIndex value)?  changeIndex,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeIndex() when changeIndex != null:
return changeIndex(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangeIndex value)  changeIndex,}){
final _that = this;
switch (_that) {
case _ChangeIndex():
return changeIndex(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangeIndex value)?  changeIndex,}){
final _that = this;
switch (_that) {
case _ChangeIndex() when changeIndex != null:
return changeIndex(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int value)?  changeIndex,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeIndex() when changeIndex != null:
return changeIndex(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int value)  changeIndex,}) {final _that = this;
switch (_that) {
case _ChangeIndex():
return changeIndex(_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int value)?  changeIndex,}) {final _that = this;
switch (_that) {
case _ChangeIndex() when changeIndex != null:
return changeIndex(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeIndex implements IntroStateEvent {
  const _ChangeIndex({required this.value});
  

@override final  int value;

/// Create a copy of IntroStateEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeIndexCopyWith<_ChangeIndex> get copyWith => __$ChangeIndexCopyWithImpl<_ChangeIndex>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeIndex&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'IntroStateEvent.changeIndex(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeIndexCopyWith<$Res> implements $IntroStateEventCopyWith<$Res> {
  factory _$ChangeIndexCopyWith(_ChangeIndex value, $Res Function(_ChangeIndex) _then) = __$ChangeIndexCopyWithImpl;
@override @useResult
$Res call({
 int value
});




}
/// @nodoc
class __$ChangeIndexCopyWithImpl<$Res>
    implements _$ChangeIndexCopyWith<$Res> {
  __$ChangeIndexCopyWithImpl(this._self, this._then);

  final _ChangeIndex _self;
  final $Res Function(_ChangeIndex) _then;

/// Create a copy of IntroStateEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeIndex(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$IntroStateState {

 int get state;
/// Create a copy of IntroStateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroStateStateCopyWith<IntroStateState> get copyWith => _$IntroStateStateCopyWithImpl<IntroStateState>(this as IntroStateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroStateState&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'IntroStateState(state: $state)';
}


}

/// @nodoc
abstract mixin class $IntroStateStateCopyWith<$Res>  {
  factory $IntroStateStateCopyWith(IntroStateState value, $Res Function(IntroStateState) _then) = _$IntroStateStateCopyWithImpl;
@useResult
$Res call({
 int state
});




}
/// @nodoc
class _$IntroStateStateCopyWithImpl<$Res>
    implements $IntroStateStateCopyWith<$Res> {
  _$IntroStateStateCopyWithImpl(this._self, this._then);

  final IntroStateState _self;
  final $Res Function(IntroStateState) _then;

/// Create a copy of IntroStateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IntroStateState].
extension IntroStateStatePatterns on IntroStateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangeState value)?  changeState,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeState() when changeState != null:
return changeState(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangeState value)  changeState,}){
final _that = this;
switch (_that) {
case _ChangeState():
return changeState(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangeState value)?  changeState,}){
final _that = this;
switch (_that) {
case _ChangeState() when changeState != null:
return changeState(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int state)?  changeState,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeState() when changeState != null:
return changeState(_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int state)  changeState,}) {final _that = this;
switch (_that) {
case _ChangeState():
return changeState(_that.state);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int state)?  changeState,}) {final _that = this;
switch (_that) {
case _ChangeState() when changeState != null:
return changeState(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _ChangeState implements IntroStateState {
  const _ChangeState({required this.state});
  

@override final  int state;

/// Create a copy of IntroStateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeStateCopyWith<_ChangeState> get copyWith => __$ChangeStateCopyWithImpl<_ChangeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeState&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'IntroStateState.changeState(state: $state)';
}


}

/// @nodoc
abstract mixin class _$ChangeStateCopyWith<$Res> implements $IntroStateStateCopyWith<$Res> {
  factory _$ChangeStateCopyWith(_ChangeState value, $Res Function(_ChangeState) _then) = __$ChangeStateCopyWithImpl;
@override @useResult
$Res call({
 int state
});




}
/// @nodoc
class __$ChangeStateCopyWithImpl<$Res>
    implements _$ChangeStateCopyWith<$Res> {
  __$ChangeStateCopyWithImpl(this._self, this._then);

  final _ChangeState _self;
  final $Res Function(_ChangeState) _then;

/// Create a copy of IntroStateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(_ChangeState(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
