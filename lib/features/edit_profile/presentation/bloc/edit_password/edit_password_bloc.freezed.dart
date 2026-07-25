// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_password_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditPasswordEvent {

 RequestEditPasswordModel? get params;
/// Create a copy of EditPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditPasswordEventCopyWith<EditPasswordEvent> get copyWith => _$EditPasswordEventCopyWithImpl<EditPasswordEvent>(this as EditPasswordEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPasswordEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'EditPasswordEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $EditPasswordEventCopyWith<$Res>  {
  factory $EditPasswordEventCopyWith(EditPasswordEvent value, $Res Function(EditPasswordEvent) _then) = _$EditPasswordEventCopyWithImpl;
@useResult
$Res call({
 RequestEditPasswordModel? params
});




}
/// @nodoc
class _$EditPasswordEventCopyWithImpl<$Res>
    implements $EditPasswordEventCopyWith<$Res> {
  _$EditPasswordEventCopyWithImpl(this._self, this._then);

  final EditPasswordEvent _self;
  final $Res Function(EditPasswordEvent) _then;

/// Create a copy of EditPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestEditPasswordModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditPasswordEvent].
extension EditPasswordEventPatterns on EditPasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnEditPassword value)?  editPassword,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnEditPassword() when editPassword != null:
return editPassword(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnEditPassword value)  editPassword,}){
final _that = this;
switch (_that) {
case _OnEditPassword():
return editPassword(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnEditPassword value)?  editPassword,}){
final _that = this;
switch (_that) {
case _OnEditPassword() when editPassword != null:
return editPassword(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestEditPasswordModel? params)?  editPassword,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnEditPassword() when editPassword != null:
return editPassword(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestEditPasswordModel? params)  editPassword,}) {final _that = this;
switch (_that) {
case _OnEditPassword():
return editPassword(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestEditPasswordModel? params)?  editPassword,}) {final _that = this;
switch (_that) {
case _OnEditPassword() when editPassword != null:
return editPassword(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnEditPassword implements EditPasswordEvent {
  const _OnEditPassword({this.params});
  

@override final  RequestEditPasswordModel? params;

/// Create a copy of EditPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnEditPasswordCopyWith<_OnEditPassword> get copyWith => __$OnEditPasswordCopyWithImpl<_OnEditPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnEditPassword&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'EditPasswordEvent.editPassword(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnEditPasswordCopyWith<$Res> implements $EditPasswordEventCopyWith<$Res> {
  factory _$OnEditPasswordCopyWith(_OnEditPassword value, $Res Function(_OnEditPassword) _then) = __$OnEditPasswordCopyWithImpl;
@override @useResult
$Res call({
 RequestEditPasswordModel? params
});




}
/// @nodoc
class __$OnEditPasswordCopyWithImpl<$Res>
    implements _$OnEditPasswordCopyWith<$Res> {
  __$OnEditPasswordCopyWithImpl(this._self, this._then);

  final _OnEditPassword _self;
  final $Res Function(_OnEditPassword) _then;

/// Create a copy of EditPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnEditPassword(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestEditPasswordModel?,
  ));
}


}

/// @nodoc
mixin _$EditPasswordState {

 bool get isLoading;
/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditPasswordStateCopyWith<EditPasswordState> get copyWith => _$EditPasswordStateCopyWithImpl<EditPasswordState>(this as EditPasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditPasswordState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'EditPasswordState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $EditPasswordStateCopyWith<$Res>  {
  factory $EditPasswordStateCopyWith(EditPasswordState value, $Res Function(EditPasswordState) _then) = _$EditPasswordStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$EditPasswordStateCopyWithImpl<$Res>
    implements $EditPasswordStateCopyWith<$Res> {
  _$EditPasswordStateCopyWithImpl(this._self, this._then);

  final EditPasswordState _self;
  final $Res Function(EditPasswordState) _then;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EditPasswordState].
extension EditPasswordStatePatterns on EditPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EditPasswordLoading value)?  loading,TResult Function( _EditPasswordError value)?  error,TResult Function( _EditPasswordSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditPasswordLoading() when loading != null:
return loading(_that);case _EditPasswordError() when error != null:
return error(_that);case _EditPasswordSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EditPasswordLoading value)  loading,required TResult Function( _EditPasswordError value)  error,required TResult Function( _EditPasswordSuccess value)  success,}){
final _that = this;
switch (_that) {
case _EditPasswordLoading():
return loading(_that);case _EditPasswordError():
return error(_that);case _EditPasswordSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EditPasswordLoading value)?  loading,TResult? Function( _EditPasswordError value)?  error,TResult? Function( _EditPasswordSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _EditPasswordLoading() when loading != null:
return loading(_that);case _EditPasswordError() when error != null:
return error(_that);case _EditPasswordSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  EditPasswordModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditPasswordLoading() when loading != null:
return loading(_that.isLoading);case _EditPasswordError() when error != null:
return error(_that.isLoading,_that.message);case _EditPasswordSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  EditPasswordModel data)  success,}) {final _that = this;
switch (_that) {
case _EditPasswordLoading():
return loading(_that.isLoading);case _EditPasswordError():
return error(_that.isLoading,_that.message);case _EditPasswordSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  EditPasswordModel data)?  success,}) {final _that = this;
switch (_that) {
case _EditPasswordLoading() when loading != null:
return loading(_that.isLoading);case _EditPasswordError() when error != null:
return error(_that.isLoading,_that.message);case _EditPasswordSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _EditPasswordLoading implements EditPasswordState {
  const _EditPasswordLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditPasswordLoadingCopyWith<_EditPasswordLoading> get copyWith => __$EditPasswordLoadingCopyWithImpl<_EditPasswordLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditPasswordLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'EditPasswordState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$EditPasswordLoadingCopyWith<$Res> implements $EditPasswordStateCopyWith<$Res> {
  factory _$EditPasswordLoadingCopyWith(_EditPasswordLoading value, $Res Function(_EditPasswordLoading) _then) = __$EditPasswordLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$EditPasswordLoadingCopyWithImpl<$Res>
    implements _$EditPasswordLoadingCopyWith<$Res> {
  __$EditPasswordLoadingCopyWithImpl(this._self, this._then);

  final _EditPasswordLoading _self;
  final $Res Function(_EditPasswordLoading) _then;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_EditPasswordLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _EditPasswordError implements EditPasswordState {
  const _EditPasswordError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditPasswordErrorCopyWith<_EditPasswordError> get copyWith => __$EditPasswordErrorCopyWithImpl<_EditPasswordError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditPasswordError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'EditPasswordState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$EditPasswordErrorCopyWith<$Res> implements $EditPasswordStateCopyWith<$Res> {
  factory _$EditPasswordErrorCopyWith(_EditPasswordError value, $Res Function(_EditPasswordError) _then) = __$EditPasswordErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$EditPasswordErrorCopyWithImpl<$Res>
    implements _$EditPasswordErrorCopyWith<$Res> {
  __$EditPasswordErrorCopyWithImpl(this._self, this._then);

  final _EditPasswordError _self;
  final $Res Function(_EditPasswordError) _then;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_EditPasswordError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EditPasswordSuccess implements EditPasswordState {
  const _EditPasswordSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  EditPasswordModel data;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditPasswordSuccessCopyWith<_EditPasswordSuccess> get copyWith => __$EditPasswordSuccessCopyWithImpl<_EditPasswordSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditPasswordSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'EditPasswordState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$EditPasswordSuccessCopyWith<$Res> implements $EditPasswordStateCopyWith<$Res> {
  factory _$EditPasswordSuccessCopyWith(_EditPasswordSuccess value, $Res Function(_EditPasswordSuccess) _then) = __$EditPasswordSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, EditPasswordModel data
});




}
/// @nodoc
class __$EditPasswordSuccessCopyWithImpl<$Res>
    implements _$EditPasswordSuccessCopyWith<$Res> {
  __$EditPasswordSuccessCopyWithImpl(this._self, this._then);

  final _EditPasswordSuccess _self;
  final $Res Function(_EditPasswordSuccess) _then;

/// Create a copy of EditPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_EditPasswordSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EditPasswordModel,
  ));
}


}

// dart format on
