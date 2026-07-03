// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseDetailEvent {

 RequestCourseDetailModel? get params;
/// Create a copy of CourseDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailEventCopyWith<CourseDetailEvent> get copyWith => _$CourseDetailEventCopyWithImpl<CourseDetailEvent>(this as CourseDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'CourseDetailEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $CourseDetailEventCopyWith<$Res>  {
  factory $CourseDetailEventCopyWith(CourseDetailEvent value, $Res Function(CourseDetailEvent) _then) = _$CourseDetailEventCopyWithImpl;
@useResult
$Res call({
 RequestCourseDetailModel? params
});




}
/// @nodoc
class _$CourseDetailEventCopyWithImpl<$Res>
    implements $CourseDetailEventCopyWith<$Res> {
  _$CourseDetailEventCopyWithImpl(this._self, this._then);

  final CourseDetailEvent _self;
  final $Res Function(CourseDetailEvent) _then;

/// Create a copy of CourseDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestCourseDetailModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDetailEvent].
extension CourseDetailEventPatterns on CourseDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnCourseDetail value)?  courseDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnCourseDetail() when courseDetail != null:
return courseDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnCourseDetail value)  courseDetail,}){
final _that = this;
switch (_that) {
case _OnCourseDetail():
return courseDetail(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnCourseDetail value)?  courseDetail,}){
final _that = this;
switch (_that) {
case _OnCourseDetail() when courseDetail != null:
return courseDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestCourseDetailModel? params)?  courseDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnCourseDetail() when courseDetail != null:
return courseDetail(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestCourseDetailModel? params)  courseDetail,}) {final _that = this;
switch (_that) {
case _OnCourseDetail():
return courseDetail(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestCourseDetailModel? params)?  courseDetail,}) {final _that = this;
switch (_that) {
case _OnCourseDetail() when courseDetail != null:
return courseDetail(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnCourseDetail implements CourseDetailEvent {
  const _OnCourseDetail({this.params});
  

@override final  RequestCourseDetailModel? params;

/// Create a copy of CourseDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnCourseDetailCopyWith<_OnCourseDetail> get copyWith => __$OnCourseDetailCopyWithImpl<_OnCourseDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCourseDetail&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'CourseDetailEvent.courseDetail(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnCourseDetailCopyWith<$Res> implements $CourseDetailEventCopyWith<$Res> {
  factory _$OnCourseDetailCopyWith(_OnCourseDetail value, $Res Function(_OnCourseDetail) _then) = __$OnCourseDetailCopyWithImpl;
@override @useResult
$Res call({
 RequestCourseDetailModel? params
});




}
/// @nodoc
class __$OnCourseDetailCopyWithImpl<$Res>
    implements _$OnCourseDetailCopyWith<$Res> {
  __$OnCourseDetailCopyWithImpl(this._self, this._then);

  final _OnCourseDetail _self;
  final $Res Function(_OnCourseDetail) _then;

/// Create a copy of CourseDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnCourseDetail(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestCourseDetailModel?,
  ));
}


}

/// @nodoc
mixin _$CourseDetailState {

 bool get isLoading;
/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailStateCopyWith<CourseDetailState> get copyWith => _$CourseDetailStateCopyWithImpl<CourseDetailState>(this as CourseDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'CourseDetailState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $CourseDetailStateCopyWith<$Res>  {
  factory $CourseDetailStateCopyWith(CourseDetailState value, $Res Function(CourseDetailState) _then) = _$CourseDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$CourseDetailStateCopyWithImpl<$Res>
    implements $CourseDetailStateCopyWith<$Res> {
  _$CourseDetailStateCopyWithImpl(this._self, this._then);

  final CourseDetailState _self;
  final $Res Function(CourseDetailState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDetailState].
extension CourseDetailStatePatterns on CourseDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CourseDetailLoading value)?  loading,TResult Function( _CourseDetailError value)?  error,TResult Function( _CourseDetailSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetailLoading() when loading != null:
return loading(_that);case _CourseDetailError() when error != null:
return error(_that);case _CourseDetailSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CourseDetailLoading value)  loading,required TResult Function( _CourseDetailError value)  error,required TResult Function( _CourseDetailSuccess value)  success,}){
final _that = this;
switch (_that) {
case _CourseDetailLoading():
return loading(_that);case _CourseDetailError():
return error(_that);case _CourseDetailSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CourseDetailLoading value)?  loading,TResult? Function( _CourseDetailError value)?  error,TResult? Function( _CourseDetailSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _CourseDetailLoading() when loading != null:
return loading(_that);case _CourseDetailError() when error != null:
return error(_that);case _CourseDetailSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  CourseDetailModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetailLoading() when loading != null:
return loading(_that.isLoading);case _CourseDetailError() when error != null:
return error(_that.isLoading,_that.message);case _CourseDetailSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  CourseDetailModel data)  success,}) {final _that = this;
switch (_that) {
case _CourseDetailLoading():
return loading(_that.isLoading);case _CourseDetailError():
return error(_that.isLoading,_that.message);case _CourseDetailSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  CourseDetailModel data)?  success,}) {final _that = this;
switch (_that) {
case _CourseDetailLoading() when loading != null:
return loading(_that.isLoading);case _CourseDetailError() when error != null:
return error(_that.isLoading,_that.message);case _CourseDetailSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _CourseDetailLoading implements CourseDetailState {
  const _CourseDetailLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailLoadingCopyWith<_CourseDetailLoading> get copyWith => __$CourseDetailLoadingCopyWithImpl<_CourseDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetailLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'CourseDetailState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailLoadingCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory _$CourseDetailLoadingCopyWith(_CourseDetailLoading value, $Res Function(_CourseDetailLoading) _then) = __$CourseDetailLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$CourseDetailLoadingCopyWithImpl<$Res>
    implements _$CourseDetailLoadingCopyWith<$Res> {
  __$CourseDetailLoadingCopyWithImpl(this._self, this._then);

  final _CourseDetailLoading _self;
  final $Res Function(_CourseDetailLoading) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_CourseDetailLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _CourseDetailError implements CourseDetailState {
  const _CourseDetailError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailErrorCopyWith<_CourseDetailError> get copyWith => __$CourseDetailErrorCopyWithImpl<_CourseDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetailError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'CourseDetailState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailErrorCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory _$CourseDetailErrorCopyWith(_CourseDetailError value, $Res Function(_CourseDetailError) _then) = __$CourseDetailErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$CourseDetailErrorCopyWithImpl<$Res>
    implements _$CourseDetailErrorCopyWith<$Res> {
  __$CourseDetailErrorCopyWithImpl(this._self, this._then);

  final _CourseDetailError _self;
  final $Res Function(_CourseDetailError) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_CourseDetailError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CourseDetailSuccess implements CourseDetailState {
  const _CourseDetailSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  CourseDetailModel data;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailSuccessCopyWith<_CourseDetailSuccess> get copyWith => __$CourseDetailSuccessCopyWithImpl<_CourseDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetailSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'CourseDetailState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailSuccessCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory _$CourseDetailSuccessCopyWith(_CourseDetailSuccess value, $Res Function(_CourseDetailSuccess) _then) = __$CourseDetailSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, CourseDetailModel data
});




}
/// @nodoc
class __$CourseDetailSuccessCopyWithImpl<$Res>
    implements _$CourseDetailSuccessCopyWith<$Res> {
  __$CourseDetailSuccessCopyWithImpl(this._self, this._then);

  final _CourseDetailSuccess _self;
  final $Res Function(_CourseDetailSuccess) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_CourseDetailSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CourseDetailModel,
  ));
}


}

// dart format on
