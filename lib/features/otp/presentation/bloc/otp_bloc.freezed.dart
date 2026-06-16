// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpEvent {

 RequestOtpModel? get params;
/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpEventCopyWith<OtpEvent> get copyWith => _$OtpEventCopyWithImpl<OtpEvent>(this as OtpEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'OtpEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $OtpEventCopyWith<$Res>  {
  factory $OtpEventCopyWith(OtpEvent value, $Res Function(OtpEvent) _then) = _$OtpEventCopyWithImpl;
@useResult
$Res call({
 RequestOtpModel? params
});




}
/// @nodoc
class _$OtpEventCopyWithImpl<$Res>
    implements $OtpEventCopyWith<$Res> {
  _$OtpEventCopyWithImpl(this._self, this._then);

  final OtpEvent _self;
  final $Res Function(OtpEvent) _then;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestOtpModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpEvent].
extension OtpEventPatterns on OtpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnOtp value)?  otp,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnOtp() when otp != null:
return otp(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnOtp value)  otp,}){
final _that = this;
switch (_that) {
case _OnOtp():
return otp(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnOtp value)?  otp,}){
final _that = this;
switch (_that) {
case _OnOtp() when otp != null:
return otp(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestOtpModel? params)?  otp,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnOtp() when otp != null:
return otp(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestOtpModel? params)  otp,}) {final _that = this;
switch (_that) {
case _OnOtp():
return otp(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestOtpModel? params)?  otp,}) {final _that = this;
switch (_that) {
case _OnOtp() when otp != null:
return otp(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnOtp implements OtpEvent {
  const _OnOtp({this.params});
  

@override final  RequestOtpModel? params;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnOtpCopyWith<_OnOtp> get copyWith => __$OnOtpCopyWithImpl<_OnOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnOtp&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'OtpEvent.otp(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnOtpCopyWith<$Res> implements $OtpEventCopyWith<$Res> {
  factory _$OnOtpCopyWith(_OnOtp value, $Res Function(_OnOtp) _then) = __$OnOtpCopyWithImpl;
@override @useResult
$Res call({
 RequestOtpModel? params
});




}
/// @nodoc
class __$OnOtpCopyWithImpl<$Res>
    implements _$OnOtpCopyWith<$Res> {
  __$OnOtpCopyWithImpl(this._self, this._then);

  final _OnOtp _self;
  final $Res Function(_OnOtp) _then;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnOtp(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestOtpModel?,
  ));
}


}

/// @nodoc
mixin _$OtpState {

 bool get isLoading;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'OtpState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OtpLoading value)?  loading,TResult Function( _OtpError value)?  error,TResult Function( _OtpSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpLoading() when loading != null:
return loading(_that);case _OtpError() when error != null:
return error(_that);case _OtpSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OtpLoading value)  loading,required TResult Function( _OtpError value)  error,required TResult Function( _OtpSuccess value)  success,}){
final _that = this;
switch (_that) {
case _OtpLoading():
return loading(_that);case _OtpError():
return error(_that);case _OtpSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OtpLoading value)?  loading,TResult? Function( _OtpError value)?  error,TResult? Function( _OtpSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _OtpLoading() when loading != null:
return loading(_that);case _OtpError() when error != null:
return error(_that);case _OtpSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  OtpModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpLoading() when loading != null:
return loading(_that.isLoading);case _OtpError() when error != null:
return error(_that.isLoading,_that.message);case _OtpSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  OtpModel data)  success,}) {final _that = this;
switch (_that) {
case _OtpLoading():
return loading(_that.isLoading);case _OtpError():
return error(_that.isLoading,_that.message);case _OtpSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  OtpModel data)?  success,}) {final _that = this;
switch (_that) {
case _OtpLoading() when loading != null:
return loading(_that.isLoading);case _OtpError() when error != null:
return error(_that.isLoading,_that.message);case _OtpSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _OtpLoading implements OtpState {
  const _OtpLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpLoadingCopyWith<_OtpLoading> get copyWith => __$OtpLoadingCopyWithImpl<_OtpLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'OtpState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$OtpLoadingCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpLoadingCopyWith(_OtpLoading value, $Res Function(_OtpLoading) _then) = __$OtpLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$OtpLoadingCopyWithImpl<$Res>
    implements _$OtpLoadingCopyWith<$Res> {
  __$OtpLoadingCopyWithImpl(this._self, this._then);

  final _OtpLoading _self;
  final $Res Function(_OtpLoading) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_OtpLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _OtpError implements OtpState {
  const _OtpError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpErrorCopyWith<_OtpError> get copyWith => __$OtpErrorCopyWithImpl<_OtpError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'OtpState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$OtpErrorCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpErrorCopyWith(_OtpError value, $Res Function(_OtpError) _then) = __$OtpErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$OtpErrorCopyWithImpl<$Res>
    implements _$OtpErrorCopyWith<$Res> {
  __$OtpErrorCopyWithImpl(this._self, this._then);

  final _OtpError _self;
  final $Res Function(_OtpError) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_OtpError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _OtpSuccess implements OtpState {
  const _OtpSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  OtpModel data;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpSuccessCopyWith<_OtpSuccess> get copyWith => __$OtpSuccessCopyWithImpl<_OtpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'OtpState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$OtpSuccessCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpSuccessCopyWith(_OtpSuccess value, $Res Function(_OtpSuccess) _then) = __$OtpSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, OtpModel data
});




}
/// @nodoc
class __$OtpSuccessCopyWithImpl<$Res>
    implements _$OtpSuccessCopyWith<$Res> {
  __$OtpSuccessCopyWithImpl(this._self, this._then);

  final _OtpSuccess _self;
  final $Res Function(_OtpSuccess) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_OtpSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OtpModel,
  ));
}


}

// dart format on
