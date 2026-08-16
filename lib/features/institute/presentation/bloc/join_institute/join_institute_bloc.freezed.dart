// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_institute_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinInstituteEvent {

 RequestInstituteIdModel? get params;
/// Create a copy of JoinInstituteEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinInstituteEventCopyWith<JoinInstituteEvent> get copyWith => _$JoinInstituteEventCopyWithImpl<JoinInstituteEvent>(this as JoinInstituteEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinInstituteEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'JoinInstituteEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $JoinInstituteEventCopyWith<$Res>  {
  factory $JoinInstituteEventCopyWith(JoinInstituteEvent value, $Res Function(JoinInstituteEvent) _then) = _$JoinInstituteEventCopyWithImpl;
@useResult
$Res call({
 RequestInstituteIdModel? params
});




}
/// @nodoc
class _$JoinInstituteEventCopyWithImpl<$Res>
    implements $JoinInstituteEventCopyWith<$Res> {
  _$JoinInstituteEventCopyWithImpl(this._self, this._then);

  final JoinInstituteEvent _self;
  final $Res Function(JoinInstituteEvent) _then;

/// Create a copy of JoinInstituteEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstituteIdModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinInstituteEvent].
extension JoinInstituteEventPatterns on JoinInstituteEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnJoin value)?  join,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnJoin() when join != null:
return join(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnJoin value)  join,}){
final _that = this;
switch (_that) {
case _OnJoin():
return join(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnJoin value)?  join,}){
final _that = this;
switch (_that) {
case _OnJoin() when join != null:
return join(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestInstituteIdModel? params)?  join,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnJoin() when join != null:
return join(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestInstituteIdModel? params)  join,}) {final _that = this;
switch (_that) {
case _OnJoin():
return join(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestInstituteIdModel? params)?  join,}) {final _that = this;
switch (_that) {
case _OnJoin() when join != null:
return join(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnJoin implements JoinInstituteEvent {
  const _OnJoin({this.params});
  

@override final  RequestInstituteIdModel? params;

/// Create a copy of JoinInstituteEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnJoinCopyWith<_OnJoin> get copyWith => __$OnJoinCopyWithImpl<_OnJoin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnJoin&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'JoinInstituteEvent.join(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnJoinCopyWith<$Res> implements $JoinInstituteEventCopyWith<$Res> {
  factory _$OnJoinCopyWith(_OnJoin value, $Res Function(_OnJoin) _then) = __$OnJoinCopyWithImpl;
@override @useResult
$Res call({
 RequestInstituteIdModel? params
});




}
/// @nodoc
class __$OnJoinCopyWithImpl<$Res>
    implements _$OnJoinCopyWith<$Res> {
  __$OnJoinCopyWithImpl(this._self, this._then);

  final _OnJoin _self;
  final $Res Function(_OnJoin) _then;

/// Create a copy of JoinInstituteEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnJoin(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstituteIdModel?,
  ));
}


}

/// @nodoc
mixin _$JoinInstituteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinInstituteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinInstituteState()';
}


}

/// @nodoc
class $JoinInstituteStateCopyWith<$Res>  {
$JoinInstituteStateCopyWith(JoinInstituteState _, $Res Function(JoinInstituteState) __);
}


/// Adds pattern-matching-related methods to [JoinInstituteState].
extension JoinInstituteStatePatterns on JoinInstituteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _JoinIdle value)?  idle,TResult Function( _JoinLoading value)?  loading,TResult Function( _JoinError value)?  error,TResult Function( _JoinSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinIdle() when idle != null:
return idle(_that);case _JoinLoading() when loading != null:
return loading(_that);case _JoinError() when error != null:
return error(_that);case _JoinSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _JoinIdle value)  idle,required TResult Function( _JoinLoading value)  loading,required TResult Function( _JoinError value)  error,required TResult Function( _JoinSuccess value)  success,}){
final _that = this;
switch (_that) {
case _JoinIdle():
return idle(_that);case _JoinLoading():
return loading(_that);case _JoinError():
return error(_that);case _JoinSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _JoinIdle value)?  idle,TResult? Function( _JoinLoading value)?  loading,TResult? Function( _JoinError value)?  error,TResult? Function( _JoinSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _JoinIdle() when idle != null:
return idle(_that);case _JoinLoading() when loading != null:
return loading(_that);case _JoinError() when error != null:
return error(_that);case _JoinSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function()?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinIdle() when idle != null:
return idle();case _JoinLoading() when loading != null:
return loading();case _JoinError() when error != null:
return error(_that.message);case _JoinSuccess() when success != null:
return success();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function()  success,}) {final _that = this;
switch (_that) {
case _JoinIdle():
return idle();case _JoinLoading():
return loading();case _JoinError():
return error(_that.message);case _JoinSuccess():
return success();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function()?  success,}) {final _that = this;
switch (_that) {
case _JoinIdle() when idle != null:
return idle();case _JoinLoading() when loading != null:
return loading();case _JoinError() when error != null:
return error(_that.message);case _JoinSuccess() when success != null:
return success();case _:
  return null;

}
}

}

/// @nodoc


class _JoinIdle implements JoinInstituteState {
  const _JoinIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinInstituteState.idle()';
}


}




/// @nodoc


class _JoinLoading implements JoinInstituteState {
  const _JoinLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinInstituteState.loading()';
}


}




/// @nodoc


class _JoinError implements JoinInstituteState {
  const _JoinError(this.message);
  

 final  String message;

/// Create a copy of JoinInstituteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinErrorCopyWith<_JoinError> get copyWith => __$JoinErrorCopyWithImpl<_JoinError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JoinInstituteState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$JoinErrorCopyWith<$Res> implements $JoinInstituteStateCopyWith<$Res> {
  factory _$JoinErrorCopyWith(_JoinError value, $Res Function(_JoinError) _then) = __$JoinErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$JoinErrorCopyWithImpl<$Res>
    implements _$JoinErrorCopyWith<$Res> {
  __$JoinErrorCopyWithImpl(this._self, this._then);

  final _JoinError _self;
  final $Res Function(_JoinError) _then;

/// Create a copy of JoinInstituteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_JoinError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _JoinSuccess implements JoinInstituteState {
  const _JoinSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinInstituteState.success()';
}


}




// dart format on
