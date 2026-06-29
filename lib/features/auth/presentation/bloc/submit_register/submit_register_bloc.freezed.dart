// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_register_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmitRegisterEvent {

 RequestSubmitRegisterModel? get params;
/// Create a copy of SubmitRegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitRegisterEventCopyWith<SubmitRegisterEvent> get copyWith => _$SubmitRegisterEventCopyWithImpl<SubmitRegisterEvent>(this as SubmitRegisterEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitRegisterEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubmitRegisterEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $SubmitRegisterEventCopyWith<$Res>  {
  factory $SubmitRegisterEventCopyWith(SubmitRegisterEvent value, $Res Function(SubmitRegisterEvent) _then) = _$SubmitRegisterEventCopyWithImpl;
@useResult
$Res call({
 RequestSubmitRegisterModel? params
});




}
/// @nodoc
class _$SubmitRegisterEventCopyWithImpl<$Res>
    implements $SubmitRegisterEventCopyWith<$Res> {
  _$SubmitRegisterEventCopyWithImpl(this._self, this._then);

  final SubmitRegisterEvent _self;
  final $Res Function(SubmitRegisterEvent) _then;

/// Create a copy of SubmitRegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubmitRegisterModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitRegisterEvent].
extension SubmitRegisterEventPatterns on SubmitRegisterEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnSubmitRegister value)?  submitRegister,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnSubmitRegister() when submitRegister != null:
return submitRegister(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnSubmitRegister value)  submitRegister,}){
final _that = this;
switch (_that) {
case _OnSubmitRegister():
return submitRegister(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnSubmitRegister value)?  submitRegister,}){
final _that = this;
switch (_that) {
case _OnSubmitRegister() when submitRegister != null:
return submitRegister(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestSubmitRegisterModel? params)?  submitRegister,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnSubmitRegister() when submitRegister != null:
return submitRegister(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestSubmitRegisterModel? params)  submitRegister,}) {final _that = this;
switch (_that) {
case _OnSubmitRegister():
return submitRegister(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestSubmitRegisterModel? params)?  submitRegister,}) {final _that = this;
switch (_that) {
case _OnSubmitRegister() when submitRegister != null:
return submitRegister(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnSubmitRegister implements SubmitRegisterEvent {
  const _OnSubmitRegister({this.params});
  

@override final  RequestSubmitRegisterModel? params;

/// Create a copy of SubmitRegisterEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnSubmitRegisterCopyWith<_OnSubmitRegister> get copyWith => __$OnSubmitRegisterCopyWithImpl<_OnSubmitRegister>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnSubmitRegister&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'SubmitRegisterEvent.submitRegister(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnSubmitRegisterCopyWith<$Res> implements $SubmitRegisterEventCopyWith<$Res> {
  factory _$OnSubmitRegisterCopyWith(_OnSubmitRegister value, $Res Function(_OnSubmitRegister) _then) = __$OnSubmitRegisterCopyWithImpl;
@override @useResult
$Res call({
 RequestSubmitRegisterModel? params
});




}
/// @nodoc
class __$OnSubmitRegisterCopyWithImpl<$Res>
    implements _$OnSubmitRegisterCopyWith<$Res> {
  __$OnSubmitRegisterCopyWithImpl(this._self, this._then);

  final _OnSubmitRegister _self;
  final $Res Function(_OnSubmitRegister) _then;

/// Create a copy of SubmitRegisterEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnSubmitRegister(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestSubmitRegisterModel?,
  ));
}


}

/// @nodoc
mixin _$SubmitRegisterState {

 bool get isLoading;
/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitRegisterStateCopyWith<SubmitRegisterState> get copyWith => _$SubmitRegisterStateCopyWithImpl<SubmitRegisterState>(this as SubmitRegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitRegisterState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubmitRegisterState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $SubmitRegisterStateCopyWith<$Res>  {
  factory $SubmitRegisterStateCopyWith(SubmitRegisterState value, $Res Function(SubmitRegisterState) _then) = _$SubmitRegisterStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$SubmitRegisterStateCopyWithImpl<$Res>
    implements $SubmitRegisterStateCopyWith<$Res> {
  _$SubmitRegisterStateCopyWithImpl(this._self, this._then);

  final SubmitRegisterState _self;
  final $Res Function(SubmitRegisterState) _then;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitRegisterState].
extension SubmitRegisterStatePatterns on SubmitRegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SubmitRegisterLoading value)?  loading,TResult Function( _SubmitRegisterError value)?  error,TResult Function( _SubmitRegisterSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitRegisterLoading() when loading != null:
return loading(_that);case _SubmitRegisterError() when error != null:
return error(_that);case _SubmitRegisterSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SubmitRegisterLoading value)  loading,required TResult Function( _SubmitRegisterError value)  error,required TResult Function( _SubmitRegisterSuccess value)  success,}){
final _that = this;
switch (_that) {
case _SubmitRegisterLoading():
return loading(_that);case _SubmitRegisterError():
return error(_that);case _SubmitRegisterSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SubmitRegisterLoading value)?  loading,TResult? Function( _SubmitRegisterError value)?  error,TResult? Function( _SubmitRegisterSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _SubmitRegisterLoading() when loading != null:
return loading(_that);case _SubmitRegisterError() when error != null:
return error(_that);case _SubmitRegisterSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  SubmitRegisterModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitRegisterLoading() when loading != null:
return loading(_that.isLoading);case _SubmitRegisterError() when error != null:
return error(_that.isLoading,_that.message);case _SubmitRegisterSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  SubmitRegisterModel data)  success,}) {final _that = this;
switch (_that) {
case _SubmitRegisterLoading():
return loading(_that.isLoading);case _SubmitRegisterError():
return error(_that.isLoading,_that.message);case _SubmitRegisterSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  SubmitRegisterModel data)?  success,}) {final _that = this;
switch (_that) {
case _SubmitRegisterLoading() when loading != null:
return loading(_that.isLoading);case _SubmitRegisterError() when error != null:
return error(_that.isLoading,_that.message);case _SubmitRegisterSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _SubmitRegisterLoading implements SubmitRegisterState {
  const _SubmitRegisterLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitRegisterLoadingCopyWith<_SubmitRegisterLoading> get copyWith => __$SubmitRegisterLoadingCopyWithImpl<_SubmitRegisterLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitRegisterLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'SubmitRegisterState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$SubmitRegisterLoadingCopyWith<$Res> implements $SubmitRegisterStateCopyWith<$Res> {
  factory _$SubmitRegisterLoadingCopyWith(_SubmitRegisterLoading value, $Res Function(_SubmitRegisterLoading) _then) = __$SubmitRegisterLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$SubmitRegisterLoadingCopyWithImpl<$Res>
    implements _$SubmitRegisterLoadingCopyWith<$Res> {
  __$SubmitRegisterLoadingCopyWithImpl(this._self, this._then);

  final _SubmitRegisterLoading _self;
  final $Res Function(_SubmitRegisterLoading) _then;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_SubmitRegisterLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SubmitRegisterError implements SubmitRegisterState {
  const _SubmitRegisterError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitRegisterErrorCopyWith<_SubmitRegisterError> get copyWith => __$SubmitRegisterErrorCopyWithImpl<_SubmitRegisterError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitRegisterError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'SubmitRegisterState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SubmitRegisterErrorCopyWith<$Res> implements $SubmitRegisterStateCopyWith<$Res> {
  factory _$SubmitRegisterErrorCopyWith(_SubmitRegisterError value, $Res Function(_SubmitRegisterError) _then) = __$SubmitRegisterErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$SubmitRegisterErrorCopyWithImpl<$Res>
    implements _$SubmitRegisterErrorCopyWith<$Res> {
  __$SubmitRegisterErrorCopyWithImpl(this._self, this._then);

  final _SubmitRegisterError _self;
  final $Res Function(_SubmitRegisterError) _then;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_SubmitRegisterError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitRegisterSuccess implements SubmitRegisterState {
  const _SubmitRegisterSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  SubmitRegisterModel data;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitRegisterSuccessCopyWith<_SubmitRegisterSuccess> get copyWith => __$SubmitRegisterSuccessCopyWithImpl<_SubmitRegisterSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitRegisterSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'SubmitRegisterState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SubmitRegisterSuccessCopyWith<$Res> implements $SubmitRegisterStateCopyWith<$Res> {
  factory _$SubmitRegisterSuccessCopyWith(_SubmitRegisterSuccess value, $Res Function(_SubmitRegisterSuccess) _then) = __$SubmitRegisterSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, SubmitRegisterModel data
});




}
/// @nodoc
class __$SubmitRegisterSuccessCopyWithImpl<$Res>
    implements _$SubmitRegisterSuccessCopyWith<$Res> {
  __$SubmitRegisterSuccessCopyWithImpl(this._self, this._then);

  final _SubmitRegisterSuccess _self;
  final $Res Function(_SubmitRegisterSuccess) _then;

/// Create a copy of SubmitRegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_SubmitRegisterSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SubmitRegisterModel,
  ));
}


}

// dart format on
