// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnAuth value)?  auth,TResult Function( _OnRefresh value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnAuth() when auth != null:
return auth(_that);case _OnRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnAuth value)  auth,required TResult Function( _OnRefresh value)  refresh,}){
final _that = this;
switch (_that) {
case _OnAuth():
return auth(_that);case _OnRefresh():
return refresh(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnAuth value)?  auth,TResult? Function( _OnRefresh value)?  refresh,}){
final _that = this;
switch (_that) {
case _OnAuth() when auth != null:
return auth(_that);case _OnRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestAuthModel? params)?  auth,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnAuth() when auth != null:
return auth(_that.params);case _OnRefresh() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestAuthModel? params)  auth,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case _OnAuth():
return auth(_that.params);case _OnRefresh():
return refresh();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestAuthModel? params)?  auth,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case _OnAuth() when auth != null:
return auth(_that.params);case _OnRefresh() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class _OnAuth implements AuthEvent {
  const _OnAuth({this.params});
  

 final  RequestAuthModel? params;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnAuthCopyWith<_OnAuth> get copyWith => __$OnAuthCopyWithImpl<_OnAuth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnAuth&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'AuthEvent.auth(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnAuthCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$OnAuthCopyWith(_OnAuth value, $Res Function(_OnAuth) _then) = __$OnAuthCopyWithImpl;
@useResult
$Res call({
 RequestAuthModel? params
});




}
/// @nodoc
class __$OnAuthCopyWithImpl<$Res>
    implements _$OnAuthCopyWith<$Res> {
  __$OnAuthCopyWithImpl(this._self, this._then);

  final _OnAuth _self;
  final $Res Function(_OnAuth) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnAuth(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestAuthModel?,
  ));
}


}

/// @nodoc


class _OnRefresh implements AuthEvent {
  const _OnRefresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnRefresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.refresh()';
}


}




/// @nodoc
mixin _$AuthState {

 bool get isLoading;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AuthState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AuthLoading value)?  loading,TResult Function( _AuthError value)?  error,TResult Function( _AuthSuccess value)?  success,TResult Function( _AuthRefresh value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthLoading() when loading != null:
return loading(_that);case _AuthError() when error != null:
return error(_that);case _AuthSuccess() when success != null:
return success(_that);case _AuthRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AuthLoading value)  loading,required TResult Function( _AuthError value)  error,required TResult Function( _AuthSuccess value)  success,required TResult Function( _AuthRefresh value)  refresh,}){
final _that = this;
switch (_that) {
case _AuthLoading():
return loading(_that);case _AuthError():
return error(_that);case _AuthSuccess():
return success(_that);case _AuthRefresh():
return refresh(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AuthLoading value)?  loading,TResult? Function( _AuthError value)?  error,TResult? Function( _AuthSuccess value)?  success,TResult? Function( _AuthRefresh value)?  refresh,}){
final _that = this;
switch (_that) {
case _AuthLoading() when loading != null:
return loading(_that);case _AuthError() when error != null:
return error(_that);case _AuthSuccess() when success != null:
return success(_that);case _AuthRefresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  AuthModel data)?  success,TResult Function( bool isLoading)?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthLoading() when loading != null:
return loading(_that.isLoading);case _AuthError() when error != null:
return error(_that.isLoading,_that.message);case _AuthSuccess() when success != null:
return success(_that.isLoading,_that.data);case _AuthRefresh() when refresh != null:
return refresh(_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  AuthModel data)  success,required TResult Function( bool isLoading)  refresh,}) {final _that = this;
switch (_that) {
case _AuthLoading():
return loading(_that.isLoading);case _AuthError():
return error(_that.isLoading,_that.message);case _AuthSuccess():
return success(_that.isLoading,_that.data);case _AuthRefresh():
return refresh(_that.isLoading);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  AuthModel data)?  success,TResult? Function( bool isLoading)?  refresh,}) {final _that = this;
switch (_that) {
case _AuthLoading() when loading != null:
return loading(_that.isLoading);case _AuthError() when error != null:
return error(_that.isLoading,_that.message);case _AuthSuccess() when success != null:
return success(_that.isLoading,_that.data);case _AuthRefresh() when refresh != null:
return refresh(_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _AuthLoading implements AuthState {
  const _AuthLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthLoadingCopyWith<_AuthLoading> get copyWith => __$AuthLoadingCopyWithImpl<_AuthLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AuthState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AuthLoadingCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthLoadingCopyWith(_AuthLoading value, $Res Function(_AuthLoading) _then) = __$AuthLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$AuthLoadingCopyWithImpl<$Res>
    implements _$AuthLoadingCopyWith<$Res> {
  __$AuthLoadingCopyWithImpl(this._self, this._then);

  final _AuthLoading _self;
  final $Res Function(_AuthLoading) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_AuthLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AuthError implements AuthState {
  const _AuthError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorCopyWith<_AuthError> get copyWith => __$AuthErrorCopyWithImpl<_AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'AuthState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthErrorCopyWith(_AuthError value, $Res Function(_AuthError) _then) = __$AuthErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$AuthErrorCopyWithImpl<$Res>
    implements _$AuthErrorCopyWith<$Res> {
  __$AuthErrorCopyWithImpl(this._self, this._then);

  final _AuthError _self;
  final $Res Function(_AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_AuthError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AuthSuccess implements AuthState {
  const _AuthSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  AuthModel data;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSuccessCopyWith<_AuthSuccess> get copyWith => __$AuthSuccessCopyWithImpl<_AuthSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'AuthState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AuthSuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthSuccessCopyWith(_AuthSuccess value, $Res Function(_AuthSuccess) _then) = __$AuthSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, AuthModel data
});




}
/// @nodoc
class __$AuthSuccessCopyWithImpl<$Res>
    implements _$AuthSuccessCopyWith<$Res> {
  __$AuthSuccessCopyWithImpl(this._self, this._then);

  final _AuthSuccess _self;
  final $Res Function(_AuthSuccess) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_AuthSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthModel,
  ));
}


}

/// @nodoc


class _AuthRefresh implements AuthState {
  const _AuthRefresh(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthRefreshCopyWith<_AuthRefresh> get copyWith => __$AuthRefreshCopyWithImpl<_AuthRefresh>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthRefresh&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AuthState.refresh(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AuthRefreshCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthRefreshCopyWith(_AuthRefresh value, $Res Function(_AuthRefresh) _then) = __$AuthRefreshCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$AuthRefreshCopyWithImpl<$Res>
    implements _$AuthRefreshCopyWith<$Res> {
  __$AuthRefreshCopyWithImpl(this._self, this._then);

  final _AuthRefresh _self;
  final $Res Function(_AuthRefresh) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_AuthRefresh(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
