// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outline_course_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OutlineCourseEvent {

 RequestOutlineCourseModel? get params;
/// Create a copy of OutlineCourseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutlineCourseEventCopyWith<OutlineCourseEvent> get copyWith => _$OutlineCourseEventCopyWithImpl<OutlineCourseEvent>(this as OutlineCourseEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutlineCourseEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'OutlineCourseEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $OutlineCourseEventCopyWith<$Res>  {
  factory $OutlineCourseEventCopyWith(OutlineCourseEvent value, $Res Function(OutlineCourseEvent) _then) = _$OutlineCourseEventCopyWithImpl;
@useResult
$Res call({
 RequestOutlineCourseModel? params
});




}
/// @nodoc
class _$OutlineCourseEventCopyWithImpl<$Res>
    implements $OutlineCourseEventCopyWith<$Res> {
  _$OutlineCourseEventCopyWithImpl(this._self, this._then);

  final OutlineCourseEvent _self;
  final $Res Function(OutlineCourseEvent) _then;

/// Create a copy of OutlineCourseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestOutlineCourseModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutlineCourseEvent].
extension OutlineCourseEventPatterns on OutlineCourseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnOutlineCourse value)?  outlineCourse,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnOutlineCourse() when outlineCourse != null:
return outlineCourse(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnOutlineCourse value)  outlineCourse,}){
final _that = this;
switch (_that) {
case _OnOutlineCourse():
return outlineCourse(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnOutlineCourse value)?  outlineCourse,}){
final _that = this;
switch (_that) {
case _OnOutlineCourse() when outlineCourse != null:
return outlineCourse(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestOutlineCourseModel? params)?  outlineCourse,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnOutlineCourse() when outlineCourse != null:
return outlineCourse(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestOutlineCourseModel? params)  outlineCourse,}) {final _that = this;
switch (_that) {
case _OnOutlineCourse():
return outlineCourse(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestOutlineCourseModel? params)?  outlineCourse,}) {final _that = this;
switch (_that) {
case _OnOutlineCourse() when outlineCourse != null:
return outlineCourse(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnOutlineCourse implements OutlineCourseEvent {
  const _OnOutlineCourse({this.params});
  

@override final  RequestOutlineCourseModel? params;

/// Create a copy of OutlineCourseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnOutlineCourseCopyWith<_OnOutlineCourse> get copyWith => __$OnOutlineCourseCopyWithImpl<_OnOutlineCourse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnOutlineCourse&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'OutlineCourseEvent.outlineCourse(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnOutlineCourseCopyWith<$Res> implements $OutlineCourseEventCopyWith<$Res> {
  factory _$OnOutlineCourseCopyWith(_OnOutlineCourse value, $Res Function(_OnOutlineCourse) _then) = __$OnOutlineCourseCopyWithImpl;
@override @useResult
$Res call({
 RequestOutlineCourseModel? params
});




}
/// @nodoc
class __$OnOutlineCourseCopyWithImpl<$Res>
    implements _$OnOutlineCourseCopyWith<$Res> {
  __$OnOutlineCourseCopyWithImpl(this._self, this._then);

  final _OnOutlineCourse _self;
  final $Res Function(_OnOutlineCourse) _then;

/// Create a copy of OutlineCourseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnOutlineCourse(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestOutlineCourseModel?,
  ));
}


}

/// @nodoc
mixin _$OutlineCourseState {

 bool get isLoading;
/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutlineCourseStateCopyWith<OutlineCourseState> get copyWith => _$OutlineCourseStateCopyWithImpl<OutlineCourseState>(this as OutlineCourseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutlineCourseState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'OutlineCourseState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $OutlineCourseStateCopyWith<$Res>  {
  factory $OutlineCourseStateCopyWith(OutlineCourseState value, $Res Function(OutlineCourseState) _then) = _$OutlineCourseStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$OutlineCourseStateCopyWithImpl<$Res>
    implements $OutlineCourseStateCopyWith<$Res> {
  _$OutlineCourseStateCopyWithImpl(this._self, this._then);

  final OutlineCourseState _self;
  final $Res Function(OutlineCourseState) _then;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OutlineCourseState].
extension OutlineCourseStatePatterns on OutlineCourseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OutlineCourseLoading value)?  loading,TResult Function( _OutlineCourseError value)?  error,TResult Function( _OutlineCourseSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutlineCourseLoading() when loading != null:
return loading(_that);case _OutlineCourseError() when error != null:
return error(_that);case _OutlineCourseSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OutlineCourseLoading value)  loading,required TResult Function( _OutlineCourseError value)  error,required TResult Function( _OutlineCourseSuccess value)  success,}){
final _that = this;
switch (_that) {
case _OutlineCourseLoading():
return loading(_that);case _OutlineCourseError():
return error(_that);case _OutlineCourseSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OutlineCourseLoading value)?  loading,TResult? Function( _OutlineCourseError value)?  error,TResult? Function( _OutlineCourseSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _OutlineCourseLoading() when loading != null:
return loading(_that);case _OutlineCourseError() when error != null:
return error(_that);case _OutlineCourseSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  OutlineCourseModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutlineCourseLoading() when loading != null:
return loading(_that.isLoading);case _OutlineCourseError() when error != null:
return error(_that.isLoading,_that.message);case _OutlineCourseSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  OutlineCourseModel data)  success,}) {final _that = this;
switch (_that) {
case _OutlineCourseLoading():
return loading(_that.isLoading);case _OutlineCourseError():
return error(_that.isLoading,_that.message);case _OutlineCourseSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  OutlineCourseModel data)?  success,}) {final _that = this;
switch (_that) {
case _OutlineCourseLoading() when loading != null:
return loading(_that.isLoading);case _OutlineCourseError() when error != null:
return error(_that.isLoading,_that.message);case _OutlineCourseSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _OutlineCourseLoading implements OutlineCourseState {
  const _OutlineCourseLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutlineCourseLoadingCopyWith<_OutlineCourseLoading> get copyWith => __$OutlineCourseLoadingCopyWithImpl<_OutlineCourseLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutlineCourseLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'OutlineCourseState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$OutlineCourseLoadingCopyWith<$Res> implements $OutlineCourseStateCopyWith<$Res> {
  factory _$OutlineCourseLoadingCopyWith(_OutlineCourseLoading value, $Res Function(_OutlineCourseLoading) _then) = __$OutlineCourseLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$OutlineCourseLoadingCopyWithImpl<$Res>
    implements _$OutlineCourseLoadingCopyWith<$Res> {
  __$OutlineCourseLoadingCopyWithImpl(this._self, this._then);

  final _OutlineCourseLoading _self;
  final $Res Function(_OutlineCourseLoading) _then;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_OutlineCourseLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _OutlineCourseError implements OutlineCourseState {
  const _OutlineCourseError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutlineCourseErrorCopyWith<_OutlineCourseError> get copyWith => __$OutlineCourseErrorCopyWithImpl<_OutlineCourseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutlineCourseError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'OutlineCourseState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$OutlineCourseErrorCopyWith<$Res> implements $OutlineCourseStateCopyWith<$Res> {
  factory _$OutlineCourseErrorCopyWith(_OutlineCourseError value, $Res Function(_OutlineCourseError) _then) = __$OutlineCourseErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$OutlineCourseErrorCopyWithImpl<$Res>
    implements _$OutlineCourseErrorCopyWith<$Res> {
  __$OutlineCourseErrorCopyWithImpl(this._self, this._then);

  final _OutlineCourseError _self;
  final $Res Function(_OutlineCourseError) _then;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_OutlineCourseError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _OutlineCourseSuccess implements OutlineCourseState {
  const _OutlineCourseSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  OutlineCourseModel data;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutlineCourseSuccessCopyWith<_OutlineCourseSuccess> get copyWith => __$OutlineCourseSuccessCopyWithImpl<_OutlineCourseSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutlineCourseSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'OutlineCourseState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$OutlineCourseSuccessCopyWith<$Res> implements $OutlineCourseStateCopyWith<$Res> {
  factory _$OutlineCourseSuccessCopyWith(_OutlineCourseSuccess value, $Res Function(_OutlineCourseSuccess) _then) = __$OutlineCourseSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, OutlineCourseModel data
});




}
/// @nodoc
class __$OutlineCourseSuccessCopyWithImpl<$Res>
    implements _$OutlineCourseSuccessCopyWith<$Res> {
  __$OutlineCourseSuccessCopyWithImpl(this._self, this._then);

  final _OutlineCourseSuccess _self;
  final $Res Function(_OutlineCourseSuccess) _then;

/// Create a copy of OutlineCourseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_OutlineCourseSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OutlineCourseModel,
  ));
}


}

// dart format on
