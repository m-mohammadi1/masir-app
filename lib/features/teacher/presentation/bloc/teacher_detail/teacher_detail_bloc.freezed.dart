// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherDetailEvent {

 RequestTeacherIdModel? get params;
/// Create a copy of TeacherDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDetailEventCopyWith<TeacherDetailEvent> get copyWith => _$TeacherDetailEventCopyWithImpl<TeacherDetailEvent>(this as TeacherDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDetailEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'TeacherDetailEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $TeacherDetailEventCopyWith<$Res>  {
  factory $TeacherDetailEventCopyWith(TeacherDetailEvent value, $Res Function(TeacherDetailEvent) _then) = _$TeacherDetailEventCopyWithImpl;
@useResult
$Res call({
 RequestTeacherIdModel? params
});




}
/// @nodoc
class _$TeacherDetailEventCopyWithImpl<$Res>
    implements $TeacherDetailEventCopyWith<$Res> {
  _$TeacherDetailEventCopyWithImpl(this._self, this._then);

  final TeacherDetailEvent _self;
  final $Res Function(TeacherDetailEvent) _then;

/// Create a copy of TeacherDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestTeacherIdModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherDetailEvent].
extension TeacherDetailEventPatterns on TeacherDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnLoad value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnLoad value)  load,}){
final _that = this;
switch (_that) {
case _OnLoad():
return load(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnLoad value)?  load,}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestTeacherIdModel? params)?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestTeacherIdModel? params)  load,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestTeacherIdModel? params)?  load,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements TeacherDetailEvent {
  const _OnLoad({this.params});
  

@override final  RequestTeacherIdModel? params;

/// Create a copy of TeacherDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnLoadCopyWith<_OnLoad> get copyWith => __$OnLoadCopyWithImpl<_OnLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'TeacherDetailEvent.load(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnLoadCopyWith<$Res> implements $TeacherDetailEventCopyWith<$Res> {
  factory _$OnLoadCopyWith(_OnLoad value, $Res Function(_OnLoad) _then) = __$OnLoadCopyWithImpl;
@override @useResult
$Res call({
 RequestTeacherIdModel? params
});




}
/// @nodoc
class __$OnLoadCopyWithImpl<$Res>
    implements _$OnLoadCopyWith<$Res> {
  __$OnLoadCopyWithImpl(this._self, this._then);

  final _OnLoad _self;
  final $Res Function(_OnLoad) _then;

/// Create a copy of TeacherDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnLoad(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestTeacherIdModel?,
  ));
}


}

/// @nodoc
mixin _$TeacherDetailState {

 bool get isLoading;
/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDetailStateCopyWith<TeacherDetailState> get copyWith => _$TeacherDetailStateCopyWithImpl<TeacherDetailState>(this as TeacherDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'TeacherDetailState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $TeacherDetailStateCopyWith<$Res>  {
  factory $TeacherDetailStateCopyWith(TeacherDetailState value, $Res Function(TeacherDetailState) _then) = _$TeacherDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$TeacherDetailStateCopyWithImpl<$Res>
    implements $TeacherDetailStateCopyWith<$Res> {
  _$TeacherDetailStateCopyWithImpl(this._self, this._then);

  final TeacherDetailState _self;
  final $Res Function(TeacherDetailState) _then;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherDetailState].
extension TeacherDetailStatePatterns on TeacherDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TeacherDetailLoading value)?  loading,TResult Function( _TeacherDetailError value)?  error,TResult Function( _TeacherDetailSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherDetailLoading() when loading != null:
return loading(_that);case _TeacherDetailError() when error != null:
return error(_that);case _TeacherDetailSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TeacherDetailLoading value)  loading,required TResult Function( _TeacherDetailError value)  error,required TResult Function( _TeacherDetailSuccess value)  success,}){
final _that = this;
switch (_that) {
case _TeacherDetailLoading():
return loading(_that);case _TeacherDetailError():
return error(_that);case _TeacherDetailSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TeacherDetailLoading value)?  loading,TResult? Function( _TeacherDetailError value)?  error,TResult? Function( _TeacherDetailSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _TeacherDetailLoading() when loading != null:
return loading(_that);case _TeacherDetailError() when error != null:
return error(_that);case _TeacherDetailSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  TeacherPageModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherDetailLoading() when loading != null:
return loading(_that.isLoading);case _TeacherDetailError() when error != null:
return error(_that.isLoading,_that.message);case _TeacherDetailSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  TeacherPageModel data)  success,}) {final _that = this;
switch (_that) {
case _TeacherDetailLoading():
return loading(_that.isLoading);case _TeacherDetailError():
return error(_that.isLoading,_that.message);case _TeacherDetailSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  TeacherPageModel data)?  success,}) {final _that = this;
switch (_that) {
case _TeacherDetailLoading() when loading != null:
return loading(_that.isLoading);case _TeacherDetailError() when error != null:
return error(_that.isLoading,_that.message);case _TeacherDetailSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherDetailLoading implements TeacherDetailState {
  const _TeacherDetailLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDetailLoadingCopyWith<_TeacherDetailLoading> get copyWith => __$TeacherDetailLoadingCopyWithImpl<_TeacherDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDetailLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'TeacherDetailState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$TeacherDetailLoadingCopyWith<$Res> implements $TeacherDetailStateCopyWith<$Res> {
  factory _$TeacherDetailLoadingCopyWith(_TeacherDetailLoading value, $Res Function(_TeacherDetailLoading) _then) = __$TeacherDetailLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$TeacherDetailLoadingCopyWithImpl<$Res>
    implements _$TeacherDetailLoadingCopyWith<$Res> {
  __$TeacherDetailLoadingCopyWithImpl(this._self, this._then);

  final _TeacherDetailLoading _self;
  final $Res Function(_TeacherDetailLoading) _then;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_TeacherDetailLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _TeacherDetailError implements TeacherDetailState {
  const _TeacherDetailError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDetailErrorCopyWith<_TeacherDetailError> get copyWith => __$TeacherDetailErrorCopyWithImpl<_TeacherDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDetailError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'TeacherDetailState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$TeacherDetailErrorCopyWith<$Res> implements $TeacherDetailStateCopyWith<$Res> {
  factory _$TeacherDetailErrorCopyWith(_TeacherDetailError value, $Res Function(_TeacherDetailError) _then) = __$TeacherDetailErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$TeacherDetailErrorCopyWithImpl<$Res>
    implements _$TeacherDetailErrorCopyWith<$Res> {
  __$TeacherDetailErrorCopyWithImpl(this._self, this._then);

  final _TeacherDetailError _self;
  final $Res Function(_TeacherDetailError) _then;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_TeacherDetailError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _TeacherDetailSuccess implements TeacherDetailState {
  const _TeacherDetailSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  TeacherPageModel data;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDetailSuccessCopyWith<_TeacherDetailSuccess> get copyWith => __$TeacherDetailSuccessCopyWithImpl<_TeacherDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDetailSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'TeacherDetailState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TeacherDetailSuccessCopyWith<$Res> implements $TeacherDetailStateCopyWith<$Res> {
  factory _$TeacherDetailSuccessCopyWith(_TeacherDetailSuccess value, $Res Function(_TeacherDetailSuccess) _then) = __$TeacherDetailSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, TeacherPageModel data
});




}
/// @nodoc
class __$TeacherDetailSuccessCopyWithImpl<$Res>
    implements _$TeacherDetailSuccessCopyWith<$Res> {
  __$TeacherDetailSuccessCopyWithImpl(this._self, this._then);

  final _TeacherDetailSuccess _self;
  final $Res Function(_TeacherDetailSuccess) _then;

/// Create a copy of TeacherDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_TeacherDetailSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TeacherPageModel,
  ));
}


}

// dart format on
