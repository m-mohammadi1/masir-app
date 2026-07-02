// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'courses_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoursesEvent {

 RequestCoursesModel? get params;
/// Create a copy of CoursesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoursesEventCopyWith<CoursesEvent> get copyWith => _$CoursesEventCopyWithImpl<CoursesEvent>(this as CoursesEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'CoursesEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $CoursesEventCopyWith<$Res>  {
  factory $CoursesEventCopyWith(CoursesEvent value, $Res Function(CoursesEvent) _then) = _$CoursesEventCopyWithImpl;
@useResult
$Res call({
 RequestCoursesModel? params
});




}
/// @nodoc
class _$CoursesEventCopyWithImpl<$Res>
    implements $CoursesEventCopyWith<$Res> {
  _$CoursesEventCopyWithImpl(this._self, this._then);

  final CoursesEvent _self;
  final $Res Function(CoursesEvent) _then;

/// Create a copy of CoursesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestCoursesModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoursesEvent].
extension CoursesEventPatterns on CoursesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnCourses value)?  courses,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnCourses() when courses != null:
return courses(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnCourses value)  courses,}){
final _that = this;
switch (_that) {
case _OnCourses():
return courses(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnCourses value)?  courses,}){
final _that = this;
switch (_that) {
case _OnCourses() when courses != null:
return courses(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestCoursesModel? params)?  courses,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnCourses() when courses != null:
return courses(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestCoursesModel? params)  courses,}) {final _that = this;
switch (_that) {
case _OnCourses():
return courses(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestCoursesModel? params)?  courses,}) {final _that = this;
switch (_that) {
case _OnCourses() when courses != null:
return courses(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnCourses implements CoursesEvent {
  const _OnCourses({this.params});
  

@override final  RequestCoursesModel? params;

/// Create a copy of CoursesEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnCoursesCopyWith<_OnCourses> get copyWith => __$OnCoursesCopyWithImpl<_OnCourses>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnCourses&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'CoursesEvent.courses(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnCoursesCopyWith<$Res> implements $CoursesEventCopyWith<$Res> {
  factory _$OnCoursesCopyWith(_OnCourses value, $Res Function(_OnCourses) _then) = __$OnCoursesCopyWithImpl;
@override @useResult
$Res call({
 RequestCoursesModel? params
});




}
/// @nodoc
class __$OnCoursesCopyWithImpl<$Res>
    implements _$OnCoursesCopyWith<$Res> {
  __$OnCoursesCopyWithImpl(this._self, this._then);

  final _OnCourses _self;
  final $Res Function(_OnCourses) _then;

/// Create a copy of CoursesEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnCourses(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestCoursesModel?,
  ));
}


}

/// @nodoc
mixin _$CoursesState {

 bool get isLoading;
/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoursesStateCopyWith<CoursesState> get copyWith => _$CoursesStateCopyWithImpl<CoursesState>(this as CoursesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'CoursesState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $CoursesStateCopyWith<$Res>  {
  factory $CoursesStateCopyWith(CoursesState value, $Res Function(CoursesState) _then) = _$CoursesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$CoursesStateCopyWithImpl<$Res>
    implements $CoursesStateCopyWith<$Res> {
  _$CoursesStateCopyWithImpl(this._self, this._then);

  final CoursesState _self;
  final $Res Function(CoursesState) _then;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CoursesState].
extension CoursesStatePatterns on CoursesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CoursesLoading value)?  loading,TResult Function( _CoursesError value)?  error,TResult Function( _CoursesSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoursesLoading() when loading != null:
return loading(_that);case _CoursesError() when error != null:
return error(_that);case _CoursesSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CoursesLoading value)  loading,required TResult Function( _CoursesError value)  error,required TResult Function( _CoursesSuccess value)  success,}){
final _that = this;
switch (_that) {
case _CoursesLoading():
return loading(_that);case _CoursesError():
return error(_that);case _CoursesSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CoursesLoading value)?  loading,TResult? Function( _CoursesError value)?  error,TResult? Function( _CoursesSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _CoursesLoading() when loading != null:
return loading(_that);case _CoursesError() when error != null:
return error(_that);case _CoursesSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<CoursesModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoursesLoading() when loading != null:
return loading(_that.isLoading);case _CoursesError() when error != null:
return error(_that.isLoading,_that.message);case _CoursesSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<CoursesModel> data)  success,}) {final _that = this;
switch (_that) {
case _CoursesLoading():
return loading(_that.isLoading);case _CoursesError():
return error(_that.isLoading,_that.message);case _CoursesSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<CoursesModel> data)?  success,}) {final _that = this;
switch (_that) {
case _CoursesLoading() when loading != null:
return loading(_that.isLoading);case _CoursesError() when error != null:
return error(_that.isLoading,_that.message);case _CoursesSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _CoursesLoading implements CoursesState {
  const _CoursesLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoursesLoadingCopyWith<_CoursesLoading> get copyWith => __$CoursesLoadingCopyWithImpl<_CoursesLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoursesLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'CoursesState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$CoursesLoadingCopyWith<$Res> implements $CoursesStateCopyWith<$Res> {
  factory _$CoursesLoadingCopyWith(_CoursesLoading value, $Res Function(_CoursesLoading) _then) = __$CoursesLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$CoursesLoadingCopyWithImpl<$Res>
    implements _$CoursesLoadingCopyWith<$Res> {
  __$CoursesLoadingCopyWithImpl(this._self, this._then);

  final _CoursesLoading _self;
  final $Res Function(_CoursesLoading) _then;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_CoursesLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _CoursesError implements CoursesState {
  const _CoursesError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoursesErrorCopyWith<_CoursesError> get copyWith => __$CoursesErrorCopyWithImpl<_CoursesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoursesError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'CoursesState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$CoursesErrorCopyWith<$Res> implements $CoursesStateCopyWith<$Res> {
  factory _$CoursesErrorCopyWith(_CoursesError value, $Res Function(_CoursesError) _then) = __$CoursesErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$CoursesErrorCopyWithImpl<$Res>
    implements _$CoursesErrorCopyWith<$Res> {
  __$CoursesErrorCopyWithImpl(this._self, this._then);

  final _CoursesError _self;
  final $Res Function(_CoursesError) _then;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_CoursesError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CoursesSuccess implements CoursesState {
  const _CoursesSuccess(this.isLoading, final  List<CoursesModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<CoursesModel> _data;
 List<CoursesModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoursesSuccessCopyWith<_CoursesSuccess> get copyWith => __$CoursesSuccessCopyWithImpl<_CoursesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoursesSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'CoursesState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CoursesSuccessCopyWith<$Res> implements $CoursesStateCopyWith<$Res> {
  factory _$CoursesSuccessCopyWith(_CoursesSuccess value, $Res Function(_CoursesSuccess) _then) = __$CoursesSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<CoursesModel> data
});




}
/// @nodoc
class __$CoursesSuccessCopyWithImpl<$Res>
    implements _$CoursesSuccessCopyWith<$Res> {
  __$CoursesSuccessCopyWithImpl(this._self, this._then);

  final _CoursesSuccess _self;
  final $Res Function(_CoursesSuccess) _then;

/// Create a copy of CoursesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_CoursesSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CoursesModel>,
  ));
}


}

// dart format on
