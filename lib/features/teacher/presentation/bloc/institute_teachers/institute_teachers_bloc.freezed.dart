// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institute_teachers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstituteTeachersEvent {

 RequestInstituteIdModel? get params;
/// Create a copy of InstituteTeachersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstituteTeachersEventCopyWith<InstituteTeachersEvent> get copyWith => _$InstituteTeachersEventCopyWithImpl<InstituteTeachersEvent>(this as InstituteTeachersEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstituteTeachersEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'InstituteTeachersEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $InstituteTeachersEventCopyWith<$Res>  {
  factory $InstituteTeachersEventCopyWith(InstituteTeachersEvent value, $Res Function(InstituteTeachersEvent) _then) = _$InstituteTeachersEventCopyWithImpl;
@useResult
$Res call({
 RequestInstituteIdModel? params
});




}
/// @nodoc
class _$InstituteTeachersEventCopyWithImpl<$Res>
    implements $InstituteTeachersEventCopyWith<$Res> {
  _$InstituteTeachersEventCopyWithImpl(this._self, this._then);

  final InstituteTeachersEvent _self;
  final $Res Function(InstituteTeachersEvent) _then;

/// Create a copy of InstituteTeachersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstituteIdModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstituteTeachersEvent].
extension InstituteTeachersEventPatterns on InstituteTeachersEvent {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestInstituteIdModel? params)?  load,required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestInstituteIdModel? params)  load,}) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestInstituteIdModel? params)?  load,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements InstituteTeachersEvent {
  const _OnLoad({this.params});
  

@override final  RequestInstituteIdModel? params;

/// Create a copy of InstituteTeachersEvent
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
  return 'InstituteTeachersEvent.load(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnLoadCopyWith<$Res> implements $InstituteTeachersEventCopyWith<$Res> {
  factory _$OnLoadCopyWith(_OnLoad value, $Res Function(_OnLoad) _then) = __$OnLoadCopyWithImpl;
@override @useResult
$Res call({
 RequestInstituteIdModel? params
});




}
/// @nodoc
class __$OnLoadCopyWithImpl<$Res>
    implements _$OnLoadCopyWith<$Res> {
  __$OnLoadCopyWithImpl(this._self, this._then);

  final _OnLoad _self;
  final $Res Function(_OnLoad) _then;

/// Create a copy of InstituteTeachersEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnLoad(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstituteIdModel?,
  ));
}


}

/// @nodoc
mixin _$InstituteTeachersState {

 bool get isLoading;
/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstituteTeachersStateCopyWith<InstituteTeachersState> get copyWith => _$InstituteTeachersStateCopyWithImpl<InstituteTeachersState>(this as InstituteTeachersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstituteTeachersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstituteTeachersState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $InstituteTeachersStateCopyWith<$Res>  {
  factory $InstituteTeachersStateCopyWith(InstituteTeachersState value, $Res Function(InstituteTeachersState) _then) = _$InstituteTeachersStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$InstituteTeachersStateCopyWithImpl<$Res>
    implements $InstituteTeachersStateCopyWith<$Res> {
  _$InstituteTeachersStateCopyWithImpl(this._self, this._then);

  final InstituteTeachersState _self;
  final $Res Function(InstituteTeachersState) _then;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InstituteTeachersState].
extension InstituteTeachersStatePatterns on InstituteTeachersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InstituteTeachersLoading value)?  loading,TResult Function( _InstituteTeachersError value)?  error,TResult Function( _InstituteTeachersSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstituteTeachersLoading() when loading != null:
return loading(_that);case _InstituteTeachersError() when error != null:
return error(_that);case _InstituteTeachersSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InstituteTeachersLoading value)  loading,required TResult Function( _InstituteTeachersError value)  error,required TResult Function( _InstituteTeachersSuccess value)  success,}){
final _that = this;
switch (_that) {
case _InstituteTeachersLoading():
return loading(_that);case _InstituteTeachersError():
return error(_that);case _InstituteTeachersSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InstituteTeachersLoading value)?  loading,TResult? Function( _InstituteTeachersError value)?  error,TResult? Function( _InstituteTeachersSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _InstituteTeachersLoading() when loading != null:
return loading(_that);case _InstituteTeachersError() when error != null:
return error(_that);case _InstituteTeachersSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<TeacherModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstituteTeachersLoading() when loading != null:
return loading(_that.isLoading);case _InstituteTeachersError() when error != null:
return error(_that.isLoading,_that.message);case _InstituteTeachersSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<TeacherModel> data)  success,}) {final _that = this;
switch (_that) {
case _InstituteTeachersLoading():
return loading(_that.isLoading);case _InstituteTeachersError():
return error(_that.isLoading,_that.message);case _InstituteTeachersSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<TeacherModel> data)?  success,}) {final _that = this;
switch (_that) {
case _InstituteTeachersLoading() when loading != null:
return loading(_that.isLoading);case _InstituteTeachersError() when error != null:
return error(_that.isLoading,_that.message);case _InstituteTeachersSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _InstituteTeachersLoading implements InstituteTeachersState {
  const _InstituteTeachersLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteTeachersLoadingCopyWith<_InstituteTeachersLoading> get copyWith => __$InstituteTeachersLoadingCopyWithImpl<_InstituteTeachersLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteTeachersLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstituteTeachersState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$InstituteTeachersLoadingCopyWith<$Res> implements $InstituteTeachersStateCopyWith<$Res> {
  factory _$InstituteTeachersLoadingCopyWith(_InstituteTeachersLoading value, $Res Function(_InstituteTeachersLoading) _then) = __$InstituteTeachersLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$InstituteTeachersLoadingCopyWithImpl<$Res>
    implements _$InstituteTeachersLoadingCopyWith<$Res> {
  __$InstituteTeachersLoadingCopyWithImpl(this._self, this._then);

  final _InstituteTeachersLoading _self;
  final $Res Function(_InstituteTeachersLoading) _then;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_InstituteTeachersLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _InstituteTeachersError implements InstituteTeachersState {
  const _InstituteTeachersError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteTeachersErrorCopyWith<_InstituteTeachersError> get copyWith => __$InstituteTeachersErrorCopyWithImpl<_InstituteTeachersError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteTeachersError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'InstituteTeachersState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$InstituteTeachersErrorCopyWith<$Res> implements $InstituteTeachersStateCopyWith<$Res> {
  factory _$InstituteTeachersErrorCopyWith(_InstituteTeachersError value, $Res Function(_InstituteTeachersError) _then) = __$InstituteTeachersErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$InstituteTeachersErrorCopyWithImpl<$Res>
    implements _$InstituteTeachersErrorCopyWith<$Res> {
  __$InstituteTeachersErrorCopyWithImpl(this._self, this._then);

  final _InstituteTeachersError _self;
  final $Res Function(_InstituteTeachersError) _then;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_InstituteTeachersError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InstituteTeachersSuccess implements InstituteTeachersState {
  const _InstituteTeachersSuccess(this.isLoading, final  List<TeacherModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<TeacherModel> _data;
 List<TeacherModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteTeachersSuccessCopyWith<_InstituteTeachersSuccess> get copyWith => __$InstituteTeachersSuccessCopyWithImpl<_InstituteTeachersSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteTeachersSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'InstituteTeachersState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$InstituteTeachersSuccessCopyWith<$Res> implements $InstituteTeachersStateCopyWith<$Res> {
  factory _$InstituteTeachersSuccessCopyWith(_InstituteTeachersSuccess value, $Res Function(_InstituteTeachersSuccess) _then) = __$InstituteTeachersSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<TeacherModel> data
});




}
/// @nodoc
class __$InstituteTeachersSuccessCopyWithImpl<$Res>
    implements _$InstituteTeachersSuccessCopyWith<$Res> {
  __$InstituteTeachersSuccessCopyWithImpl(this._self, this._then);

  final _InstituteTeachersSuccess _self;
  final $Res Function(_InstituteTeachersSuccess) _then;

/// Create a copy of InstituteTeachersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_InstituteTeachersSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<TeacherModel>,
  ));
}


}

// dart format on
