// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribe_course_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscribeCourseEvent {

 RequestSubscribeCourseModel? get params;
/// Create a copy of SubscribeCourseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscribeCourseEventCopyWith<SubscribeCourseEvent> get copyWith => _$SubscribeCourseEventCopyWithImpl<SubscribeCourseEvent>(this as SubscribeCourseEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscribeCourseEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubscribeCourseEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $SubscribeCourseEventCopyWith<$Res>  {
  factory $SubscribeCourseEventCopyWith(SubscribeCourseEvent value, $Res Function(SubscribeCourseEvent) _then) = _$SubscribeCourseEventCopyWithImpl;
@useResult
$Res call({
 RequestSubscribeCourseModel? params
});




}
/// @nodoc
class _$SubscribeCourseEventCopyWithImpl<$Res>
    implements $SubscribeCourseEventCopyWith<$Res> {
  _$SubscribeCourseEventCopyWithImpl(this._self, this._then);

  final SubscribeCourseEvent _self;
  final $Res Function(SubscribeCourseEvent) _then;

/// Create a copy of SubscribeCourseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubscribeCourseModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscribeCourseEvent].
extension SubscribeCourseEventPatterns on SubscribeCourseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSubscribeCourse value)?  subscribeCourse,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSubscribeCourse() when subscribeCourse != null:
return subscribeCourse(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSubscribeCourse value)  subscribeCourse,}){
final _that = this;
switch (_that) {
case _OnSubscribeCourse():
return subscribeCourse(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSubscribeCourse value)?  subscribeCourse,}){
final _that = this;
switch (_that) {
case _OnSubscribeCourse() when subscribeCourse != null:
return subscribeCourse(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestSubscribeCourseModel? params)?  subscribeCourse,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSubscribeCourse() when subscribeCourse != null:
return subscribeCourse(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestSubscribeCourseModel? params)  subscribeCourse,}) {final _that = this;
switch (_that) {
case _OnSubscribeCourse():
return subscribeCourse(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestSubscribeCourseModel? params)?  subscribeCourse,}) {final _that = this;
switch (_that) {
case _OnSubscribeCourse() when subscribeCourse != null:
return subscribeCourse(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnSubscribeCourse implements SubscribeCourseEvent {
  const _OnSubscribeCourse({this.params});
  

@override final  RequestSubscribeCourseModel? params;

/// Create a copy of SubscribeCourseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnSubscribeCourseCopyWith<_OnSubscribeCourse> get copyWith => __$OnSubscribeCourseCopyWithImpl<_OnSubscribeCourse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSubscribeCourse&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubscribeCourseEvent.subscribeCourse(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnSubscribeCourseCopyWith<$Res> implements $SubscribeCourseEventCopyWith<$Res> {
  factory _$OnSubscribeCourseCopyWith(_OnSubscribeCourse value, $Res Function(_OnSubscribeCourse) _then) = __$OnSubscribeCourseCopyWithImpl;
@override @useResult
$Res call({
 RequestSubscribeCourseModel? params
});




}
/// @nodoc
class __$OnSubscribeCourseCopyWithImpl<$Res>
    implements _$OnSubscribeCourseCopyWith<$Res> {
  __$OnSubscribeCourseCopyWithImpl(this._self, this._then);

  final _OnSubscribeCourse _self;
  final $Res Function(_OnSubscribeCourse) _then;

/// Create a copy of SubscribeCourseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnSubscribeCourse(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubscribeCourseModel?,
  ));
}


}

/// @nodoc
mixin _$SubscribeCourseState {

 bool get isLoading;
/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscribeCourseStateCopyWith<SubscribeCourseState> get copyWith => _$SubscribeCourseStateCopyWithImpl<SubscribeCourseState>(this as SubscribeCourseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscribeCourseState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubscribeCourseState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $SubscribeCourseStateCopyWith<$Res>  {
  factory $SubscribeCourseStateCopyWith(SubscribeCourseState value, $Res Function(SubscribeCourseState) _then) = _$SubscribeCourseStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$SubscribeCourseStateCopyWithImpl<$Res>
    implements $SubscribeCourseStateCopyWith<$Res> {
  _$SubscribeCourseStateCopyWithImpl(this._self, this._then);

  final SubscribeCourseState _self;
  final $Res Function(SubscribeCourseState) _then;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscribeCourseState].
extension SubscribeCourseStatePatterns on SubscribeCourseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SubscribeCourseLoading value)?  loading,TResult Function( _SubscribeCourseError value)?  error,TResult Function( _SubscribeCourseSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscribeCourseLoading() when loading != null:
return loading(_that);case _SubscribeCourseError() when error != null:
return error(_that);case _SubscribeCourseSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SubscribeCourseLoading value)  loading,required TResult Function( _SubscribeCourseError value)  error,required TResult Function( _SubscribeCourseSuccess value)  success,}){
final _that = this;
switch (_that) {
case _SubscribeCourseLoading():
return loading(_that);case _SubscribeCourseError():
return error(_that);case _SubscribeCourseSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SubscribeCourseLoading value)?  loading,TResult? Function( _SubscribeCourseError value)?  error,TResult? Function( _SubscribeCourseSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _SubscribeCourseLoading() when loading != null:
return loading(_that);case _SubscribeCourseError() when error != null:
return error(_that);case _SubscribeCourseSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  SubscribeCourseModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscribeCourseLoading() when loading != null:
return loading(_that.isLoading);case _SubscribeCourseError() when error != null:
return error(_that.isLoading,_that.message);case _SubscribeCourseSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  SubscribeCourseModel data)  success,}) {final _that = this;
switch (_that) {
case _SubscribeCourseLoading():
return loading(_that.isLoading);case _SubscribeCourseError():
return error(_that.isLoading,_that.message);case _SubscribeCourseSuccess():
return success(_that.isLoading,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  SubscribeCourseModel data)?  success,}) {final _that = this;
switch (_that) {
case _SubscribeCourseLoading() when loading != null:
return loading(_that.isLoading);case _SubscribeCourseError() when error != null:
return error(_that.isLoading,_that.message);case _SubscribeCourseSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _SubscribeCourseLoading implements SubscribeCourseState {
  const _SubscribeCourseLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribeCourseLoadingCopyWith<_SubscribeCourseLoading> get copyWith => __$SubscribeCourseLoadingCopyWithImpl<_SubscribeCourseLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribeCourseLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubscribeCourseState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SubscribeCourseLoadingCopyWith<$Res> implements $SubscribeCourseStateCopyWith<$Res> {
  factory _$SubscribeCourseLoadingCopyWith(_SubscribeCourseLoading value, $Res Function(_SubscribeCourseLoading) _then) = __$SubscribeCourseLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$SubscribeCourseLoadingCopyWithImpl<$Res>
    implements _$SubscribeCourseLoadingCopyWith<$Res> {
  __$SubscribeCourseLoadingCopyWithImpl(this._self, this._then);

  final _SubscribeCourseLoading _self;
  final $Res Function(_SubscribeCourseLoading) _then;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_SubscribeCourseLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SubscribeCourseError implements SubscribeCourseState {
  const _SubscribeCourseError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribeCourseErrorCopyWith<_SubscribeCourseError> get copyWith => __$SubscribeCourseErrorCopyWithImpl<_SubscribeCourseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribeCourseError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'SubscribeCourseState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SubscribeCourseErrorCopyWith<$Res> implements $SubscribeCourseStateCopyWith<$Res> {
  factory _$SubscribeCourseErrorCopyWith(_SubscribeCourseError value, $Res Function(_SubscribeCourseError) _then) = __$SubscribeCourseErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$SubscribeCourseErrorCopyWithImpl<$Res>
    implements _$SubscribeCourseErrorCopyWith<$Res> {
  __$SubscribeCourseErrorCopyWithImpl(this._self, this._then);

  final _SubscribeCourseError _self;
  final $Res Function(_SubscribeCourseError) _then;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_SubscribeCourseError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubscribeCourseSuccess implements SubscribeCourseState {
  const _SubscribeCourseSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  SubscribeCourseModel data;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribeCourseSuccessCopyWith<_SubscribeCourseSuccess> get copyWith => __$SubscribeCourseSuccessCopyWithImpl<_SubscribeCourseSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribeCourseSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'SubscribeCourseState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SubscribeCourseSuccessCopyWith<$Res> implements $SubscribeCourseStateCopyWith<$Res> {
  factory _$SubscribeCourseSuccessCopyWith(_SubscribeCourseSuccess value, $Res Function(_SubscribeCourseSuccess) _then) = __$SubscribeCourseSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, SubscribeCourseModel data
});




}
/// @nodoc
class __$SubscribeCourseSuccessCopyWithImpl<$Res>
    implements _$SubscribeCourseSuccessCopyWith<$Res> {
  __$SubscribeCourseSuccessCopyWithImpl(this._self, this._then);

  final _SubscribeCourseSuccess _self;
  final $Res Function(_SubscribeCourseSuccess) _then;

/// Create a copy of SubscribeCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_SubscribeCourseSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SubscribeCourseModel,
  ));
}


}

// dart format on
