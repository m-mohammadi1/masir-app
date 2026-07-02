// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_username_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmitUsernameEvent {

 RequestSubmitUsernameModel? get params;
/// Create a copy of SubmitUsernameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitUsernameEventCopyWith<SubmitUsernameEvent> get copyWith => _$SubmitUsernameEventCopyWithImpl<SubmitUsernameEvent>(this as SubmitUsernameEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitUsernameEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubmitUsernameEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $SubmitUsernameEventCopyWith<$Res>  {
  factory $SubmitUsernameEventCopyWith(SubmitUsernameEvent value, $Res Function(SubmitUsernameEvent) _then) = _$SubmitUsernameEventCopyWithImpl;
@useResult
$Res call({
 RequestSubmitUsernameModel? params
});




}
/// @nodoc
class _$SubmitUsernameEventCopyWithImpl<$Res>
    implements $SubmitUsernameEventCopyWith<$Res> {
  _$SubmitUsernameEventCopyWithImpl(this._self, this._then);

  final SubmitUsernameEvent _self;
  final $Res Function(SubmitUsernameEvent) _then;

/// Create a copy of SubmitUsernameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubmitUsernameModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitUsernameEvent].
extension SubmitUsernameEventPatterns on SubmitUsernameEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSubmitUsername value)?  submitUsername,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSubmitUsername() when submitUsername != null:
return submitUsername(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSubmitUsername value)  submitUsername,}){
final _that = this;
switch (_that) {
case _OnSubmitUsername():
return submitUsername(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSubmitUsername value)?  submitUsername,}){
final _that = this;
switch (_that) {
case _OnSubmitUsername() when submitUsername != null:
return submitUsername(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestSubmitUsernameModel? params)?  submitUsername,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSubmitUsername() when submitUsername != null:
return submitUsername(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestSubmitUsernameModel? params)  submitUsername,}) {final _that = this;
switch (_that) {
case _OnSubmitUsername():
return submitUsername(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestSubmitUsernameModel? params)?  submitUsername,}) {final _that = this;
switch (_that) {
case _OnSubmitUsername() when submitUsername != null:
return submitUsername(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnSubmitUsername implements SubmitUsernameEvent {
  const _OnSubmitUsername({this.params});
  

@override final  RequestSubmitUsernameModel? params;

/// Create a copy of SubmitUsernameEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnSubmitUsernameCopyWith<_OnSubmitUsername> get copyWith => __$OnSubmitUsernameCopyWithImpl<_OnSubmitUsername>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSubmitUsername&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubmitUsernameEvent.submitUsername(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnSubmitUsernameCopyWith<$Res> implements $SubmitUsernameEventCopyWith<$Res> {
  factory _$OnSubmitUsernameCopyWith(_OnSubmitUsername value, $Res Function(_OnSubmitUsername) _then) = __$OnSubmitUsernameCopyWithImpl;
@override @useResult
$Res call({
 RequestSubmitUsernameModel? params
});




}
/// @nodoc
class __$OnSubmitUsernameCopyWithImpl<$Res>
    implements _$OnSubmitUsernameCopyWith<$Res> {
  __$OnSubmitUsernameCopyWithImpl(this._self, this._then);

  final _OnSubmitUsername _self;
  final $Res Function(_OnSubmitUsername) _then;

/// Create a copy of SubmitUsernameEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnSubmitUsername(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubmitUsernameModel?,
  ));
}


}

/// @nodoc
mixin _$SubmitUsernameState {

 bool get isLoading;
/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitUsernameStateCopyWith<SubmitUsernameState> get copyWith => _$SubmitUsernameStateCopyWithImpl<SubmitUsernameState>(this as SubmitUsernameState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitUsernameState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubmitUsernameState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $SubmitUsernameStateCopyWith<$Res>  {
  factory $SubmitUsernameStateCopyWith(SubmitUsernameState value, $Res Function(SubmitUsernameState) _then) = _$SubmitUsernameStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$SubmitUsernameStateCopyWithImpl<$Res>
    implements $SubmitUsernameStateCopyWith<$Res> {
  _$SubmitUsernameStateCopyWithImpl(this._self, this._then);

  final SubmitUsernameState _self;
  final $Res Function(SubmitUsernameState) _then;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitUsernameState].
extension SubmitUsernameStatePatterns on SubmitUsernameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SubmitUsernameLoading value)?  loading,TResult Function( _SubmitUsernameError value)?  error,TResult Function( _SubmitUsernameSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitUsernameLoading() when loading != null:
return loading(_that);case _SubmitUsernameError() when error != null:
return error(_that);case _SubmitUsernameSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SubmitUsernameLoading value)  loading,required TResult Function( _SubmitUsernameError value)  error,required TResult Function( _SubmitUsernameSuccess value)  success,}){
final _that = this;
switch (_that) {
case _SubmitUsernameLoading():
return loading(_that);case _SubmitUsernameError():
return error(_that);case _SubmitUsernameSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SubmitUsernameLoading value)?  loading,TResult? Function( _SubmitUsernameError value)?  error,TResult? Function( _SubmitUsernameSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _SubmitUsernameLoading() when loading != null:
return loading(_that);case _SubmitUsernameError() when error != null:
return error(_that);case _SubmitUsernameSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  UserModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitUsernameLoading() when loading != null:
return loading(_that.isLoading);case _SubmitUsernameError() when error != null:
return error(_that.isLoading,_that.message);case _SubmitUsernameSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  UserModel data)  success,}) {final _that = this;
switch (_that) {
case _SubmitUsernameLoading():
return loading(_that.isLoading);case _SubmitUsernameError():
return error(_that.isLoading,_that.message);case _SubmitUsernameSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  UserModel data)?  success,}) {final _that = this;
switch (_that) {
case _SubmitUsernameLoading() when loading != null:
return loading(_that.isLoading);case _SubmitUsernameError() when error != null:
return error(_that.isLoading,_that.message);case _SubmitUsernameSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _SubmitUsernameLoading implements SubmitUsernameState {
  const _SubmitUsernameLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitUsernameLoadingCopyWith<_SubmitUsernameLoading> get copyWith => __$SubmitUsernameLoadingCopyWithImpl<_SubmitUsernameLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitUsernameLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubmitUsernameState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SubmitUsernameLoadingCopyWith<$Res> implements $SubmitUsernameStateCopyWith<$Res> {
  factory _$SubmitUsernameLoadingCopyWith(_SubmitUsernameLoading value, $Res Function(_SubmitUsernameLoading) _then) = __$SubmitUsernameLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$SubmitUsernameLoadingCopyWithImpl<$Res>
    implements _$SubmitUsernameLoadingCopyWith<$Res> {
  __$SubmitUsernameLoadingCopyWithImpl(this._self, this._then);

  final _SubmitUsernameLoading _self;
  final $Res Function(_SubmitUsernameLoading) _then;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_SubmitUsernameLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SubmitUsernameError implements SubmitUsernameState {
  const _SubmitUsernameError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitUsernameErrorCopyWith<_SubmitUsernameError> get copyWith => __$SubmitUsernameErrorCopyWithImpl<_SubmitUsernameError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitUsernameError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'SubmitUsernameState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SubmitUsernameErrorCopyWith<$Res> implements $SubmitUsernameStateCopyWith<$Res> {
  factory _$SubmitUsernameErrorCopyWith(_SubmitUsernameError value, $Res Function(_SubmitUsernameError) _then) = __$SubmitUsernameErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$SubmitUsernameErrorCopyWithImpl<$Res>
    implements _$SubmitUsernameErrorCopyWith<$Res> {
  __$SubmitUsernameErrorCopyWithImpl(this._self, this._then);

  final _SubmitUsernameError _self;
  final $Res Function(_SubmitUsernameError) _then;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_SubmitUsernameError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitUsernameSuccess implements SubmitUsernameState {
  const _SubmitUsernameSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  UserModel data;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitUsernameSuccessCopyWith<_SubmitUsernameSuccess> get copyWith => __$SubmitUsernameSuccessCopyWithImpl<_SubmitUsernameSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitUsernameSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'SubmitUsernameState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SubmitUsernameSuccessCopyWith<$Res> implements $SubmitUsernameStateCopyWith<$Res> {
  factory _$SubmitUsernameSuccessCopyWith(_SubmitUsernameSuccess value, $Res Function(_SubmitUsernameSuccess) _then) = __$SubmitUsernameSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, UserModel data
});




}
/// @nodoc
class __$SubmitUsernameSuccessCopyWithImpl<$Res>
    implements _$SubmitUsernameSuccessCopyWith<$Res> {
  __$SubmitUsernameSuccessCopyWithImpl(this._self, this._then);

  final _SubmitUsernameSuccess _self;
  final $Res Function(_SubmitUsernameSuccess) _then;

/// Create a copy of SubmitUsernameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_SubmitUsernameSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}


}

// dart format on
