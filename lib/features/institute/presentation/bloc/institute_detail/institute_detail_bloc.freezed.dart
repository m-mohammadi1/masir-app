// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institute_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstituteDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstituteDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InstituteDetailEvent()';
}


}

/// @nodoc
class $InstituteDetailEventCopyWith<$Res>  {
$InstituteDetailEventCopyWith(InstituteDetailEvent _, $Res Function(InstituteDetailEvent) __);
}


/// Adds pattern-matching-related methods to [InstituteDetailEvent].
extension InstituteDetailEventPatterns on InstituteDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnLoad value)?  load,TResult Function( _OnMarkJoined value)?  markJoined,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnMarkJoined() when markJoined != null:
return markJoined(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnLoad value)  load,required TResult Function( _OnMarkJoined value)  markJoined,}){
final _that = this;
switch (_that) {
case _OnLoad():
return load(_that);case _OnMarkJoined():
return markJoined(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnLoad value)?  load,TResult? Function( _OnMarkJoined value)?  markJoined,}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnMarkJoined() when markJoined != null:
return markJoined(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestInstituteIdModel? params)?  load,TResult Function()?  markJoined,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.params);case _OnMarkJoined() when markJoined != null:
return markJoined();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestInstituteIdModel? params)  load,required TResult Function()  markJoined,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load(_that.params);case _OnMarkJoined():
return markJoined();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestInstituteIdModel? params)?  load,TResult? Function()?  markJoined,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.params);case _OnMarkJoined() when markJoined != null:
return markJoined();case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements InstituteDetailEvent {
  const _OnLoad({this.params});
  

 final  RequestInstituteIdModel? params;

/// Create a copy of InstituteDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
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
  return 'InstituteDetailEvent.load(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnLoadCopyWith<$Res> implements $InstituteDetailEventCopyWith<$Res> {
  factory _$OnLoadCopyWith(_OnLoad value, $Res Function(_OnLoad) _then) = __$OnLoadCopyWithImpl;
@useResult
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

/// Create a copy of InstituteDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnLoad(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstituteIdModel?,
  ));
}


}

/// @nodoc


class _OnMarkJoined implements InstituteDetailEvent {
  const _OnMarkJoined();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMarkJoined);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InstituteDetailEvent.markJoined()';
}


}




/// @nodoc
mixin _$InstituteDetailState {

 bool get isLoading;
/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstituteDetailStateCopyWith<InstituteDetailState> get copyWith => _$InstituteDetailStateCopyWithImpl<InstituteDetailState>(this as InstituteDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstituteDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstituteDetailState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $InstituteDetailStateCopyWith<$Res>  {
  factory $InstituteDetailStateCopyWith(InstituteDetailState value, $Res Function(InstituteDetailState) _then) = _$InstituteDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$InstituteDetailStateCopyWithImpl<$Res>
    implements $InstituteDetailStateCopyWith<$Res> {
  _$InstituteDetailStateCopyWithImpl(this._self, this._then);

  final InstituteDetailState _self;
  final $Res Function(InstituteDetailState) _then;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InstituteDetailState].
extension InstituteDetailStatePatterns on InstituteDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InstituteDetailLoading value)?  loading,TResult Function( _InstituteDetailError value)?  error,TResult Function( _InstituteDetailSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstituteDetailLoading() when loading != null:
return loading(_that);case _InstituteDetailError() when error != null:
return error(_that);case _InstituteDetailSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InstituteDetailLoading value)  loading,required TResult Function( _InstituteDetailError value)  error,required TResult Function( _InstituteDetailSuccess value)  success,}){
final _that = this;
switch (_that) {
case _InstituteDetailLoading():
return loading(_that);case _InstituteDetailError():
return error(_that);case _InstituteDetailSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InstituteDetailLoading value)?  loading,TResult? Function( _InstituteDetailError value)?  error,TResult? Function( _InstituteDetailSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _InstituteDetailLoading() when loading != null:
return loading(_that);case _InstituteDetailError() when error != null:
return error(_that);case _InstituteDetailSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  InstituteDetailModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstituteDetailLoading() when loading != null:
return loading(_that.isLoading);case _InstituteDetailError() when error != null:
return error(_that.isLoading,_that.message);case _InstituteDetailSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  InstituteDetailModel data)  success,}) {final _that = this;
switch (_that) {
case _InstituteDetailLoading():
return loading(_that.isLoading);case _InstituteDetailError():
return error(_that.isLoading,_that.message);case _InstituteDetailSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  InstituteDetailModel data)?  success,}) {final _that = this;
switch (_that) {
case _InstituteDetailLoading() when loading != null:
return loading(_that.isLoading);case _InstituteDetailError() when error != null:
return error(_that.isLoading,_that.message);case _InstituteDetailSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _InstituteDetailLoading implements InstituteDetailState {
  const _InstituteDetailLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteDetailLoadingCopyWith<_InstituteDetailLoading> get copyWith => __$InstituteDetailLoadingCopyWithImpl<_InstituteDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteDetailLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstituteDetailState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$InstituteDetailLoadingCopyWith<$Res> implements $InstituteDetailStateCopyWith<$Res> {
  factory _$InstituteDetailLoadingCopyWith(_InstituteDetailLoading value, $Res Function(_InstituteDetailLoading) _then) = __$InstituteDetailLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$InstituteDetailLoadingCopyWithImpl<$Res>
    implements _$InstituteDetailLoadingCopyWith<$Res> {
  __$InstituteDetailLoadingCopyWithImpl(this._self, this._then);

  final _InstituteDetailLoading _self;
  final $Res Function(_InstituteDetailLoading) _then;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_InstituteDetailLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _InstituteDetailError implements InstituteDetailState {
  const _InstituteDetailError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteDetailErrorCopyWith<_InstituteDetailError> get copyWith => __$InstituteDetailErrorCopyWithImpl<_InstituteDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteDetailError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'InstituteDetailState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$InstituteDetailErrorCopyWith<$Res> implements $InstituteDetailStateCopyWith<$Res> {
  factory _$InstituteDetailErrorCopyWith(_InstituteDetailError value, $Res Function(_InstituteDetailError) _then) = __$InstituteDetailErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$InstituteDetailErrorCopyWithImpl<$Res>
    implements _$InstituteDetailErrorCopyWith<$Res> {
  __$InstituteDetailErrorCopyWithImpl(this._self, this._then);

  final _InstituteDetailError _self;
  final $Res Function(_InstituteDetailError) _then;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_InstituteDetailError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InstituteDetailSuccess implements InstituteDetailState {
  const _InstituteDetailSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  InstituteDetailModel data;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstituteDetailSuccessCopyWith<_InstituteDetailSuccess> get copyWith => __$InstituteDetailSuccessCopyWithImpl<_InstituteDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstituteDetailSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'InstituteDetailState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$InstituteDetailSuccessCopyWith<$Res> implements $InstituteDetailStateCopyWith<$Res> {
  factory _$InstituteDetailSuccessCopyWith(_InstituteDetailSuccess value, $Res Function(_InstituteDetailSuccess) _then) = __$InstituteDetailSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, InstituteDetailModel data
});




}
/// @nodoc
class __$InstituteDetailSuccessCopyWithImpl<$Res>
    implements _$InstituteDetailSuccessCopyWith<$Res> {
  __$InstituteDetailSuccessCopyWithImpl(this._self, this._then);

  final _InstituteDetailSuccess _self;
  final $Res Function(_InstituteDetailSuccess) _then;

/// Create a copy of InstituteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_InstituteDetailSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InstituteDetailModel,
  ));
}


}

// dart format on
