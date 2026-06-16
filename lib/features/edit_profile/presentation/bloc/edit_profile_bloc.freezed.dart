// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent {

 RequestEditProfileModel? get params;
/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileEventCopyWith<EditProfileEvent> get copyWith => _$EditProfileEventCopyWithImpl<EditProfileEvent>(this as EditProfileEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'EditProfileEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $EditProfileEventCopyWith<$Res>  {
  factory $EditProfileEventCopyWith(EditProfileEvent value, $Res Function(EditProfileEvent) _then) = _$EditProfileEventCopyWithImpl;
@useResult
$Res call({
 RequestEditProfileModel? params
});




}
/// @nodoc
class _$EditProfileEventCopyWithImpl<$Res>
    implements $EditProfileEventCopyWith<$Res> {
  _$EditProfileEventCopyWithImpl(this._self, this._then);

  final EditProfileEvent _self;
  final $Res Function(EditProfileEvent) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestEditProfileModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnEditProfile value)?  editProfile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnEditProfile() when editProfile != null:
return editProfile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnEditProfile value)  editProfile,}){
final _that = this;
switch (_that) {
case _OnEditProfile():
return editProfile(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnEditProfile value)?  editProfile,}){
final _that = this;
switch (_that) {
case _OnEditProfile() when editProfile != null:
return editProfile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestEditProfileModel? params)?  editProfile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnEditProfile() when editProfile != null:
return editProfile(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestEditProfileModel? params)  editProfile,}) {final _that = this;
switch (_that) {
case _OnEditProfile():
return editProfile(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestEditProfileModel? params)?  editProfile,}) {final _that = this;
switch (_that) {
case _OnEditProfile() when editProfile != null:
return editProfile(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnEditProfile implements EditProfileEvent {
  const _OnEditProfile({this.params});
  

@override final  RequestEditProfileModel? params;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnEditProfileCopyWith<_OnEditProfile> get copyWith => __$OnEditProfileCopyWithImpl<_OnEditProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnEditProfile&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'EditProfileEvent.editProfile(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnEditProfileCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$OnEditProfileCopyWith(_OnEditProfile value, $Res Function(_OnEditProfile) _then) = __$OnEditProfileCopyWithImpl;
@override @useResult
$Res call({
 RequestEditProfileModel? params
});




}
/// @nodoc
class __$OnEditProfileCopyWithImpl<$Res>
    implements _$OnEditProfileCopyWith<$Res> {
  __$OnEditProfileCopyWithImpl(this._self, this._then);

  final _OnEditProfile _self;
  final $Res Function(_OnEditProfile) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnEditProfile(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestEditProfileModel?,
  ));
}


}

/// @nodoc
mixin _$EditProfileState {

 bool get isLoading;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'EditProfileState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EditProfileLoading value)?  loading,TResult Function( _EditProfileError value)?  error,TResult Function( _EditProfileSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileLoading() when loading != null:
return loading(_that);case _EditProfileError() when error != null:
return error(_that);case _EditProfileSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EditProfileLoading value)  loading,required TResult Function( _EditProfileError value)  error,required TResult Function( _EditProfileSuccess value)  success,}){
final _that = this;
switch (_that) {
case _EditProfileLoading():
return loading(_that);case _EditProfileError():
return error(_that);case _EditProfileSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EditProfileLoading value)?  loading,TResult? Function( _EditProfileError value)?  error,TResult? Function( _EditProfileSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _EditProfileLoading() when loading != null:
return loading(_that);case _EditProfileError() when error != null:
return error(_that);case _EditProfileSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  EditProfileModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileLoading() when loading != null:
return loading(_that.isLoading);case _EditProfileError() when error != null:
return error(_that.isLoading,_that.message);case _EditProfileSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  EditProfileModel data)  success,}) {final _that = this;
switch (_that) {
case _EditProfileLoading():
return loading(_that.isLoading);case _EditProfileError():
return error(_that.isLoading,_that.message);case _EditProfileSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  EditProfileModel data)?  success,}) {final _that = this;
switch (_that) {
case _EditProfileLoading() when loading != null:
return loading(_that.isLoading);case _EditProfileError() when error != null:
return error(_that.isLoading,_that.message);case _EditProfileSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileLoading implements EditProfileState {
  const _EditProfileLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileLoadingCopyWith<_EditProfileLoading> get copyWith => __$EditProfileLoadingCopyWithImpl<_EditProfileLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'EditProfileState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$EditProfileLoadingCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileLoadingCopyWith(_EditProfileLoading value, $Res Function(_EditProfileLoading) _then) = __$EditProfileLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$EditProfileLoadingCopyWithImpl<$Res>
    implements _$EditProfileLoadingCopyWith<$Res> {
  __$EditProfileLoadingCopyWithImpl(this._self, this._then);

  final _EditProfileLoading _self;
  final $Res Function(_EditProfileLoading) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_EditProfileLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _EditProfileError implements EditProfileState {
  const _EditProfileError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileErrorCopyWith<_EditProfileError> get copyWith => __$EditProfileErrorCopyWithImpl<_EditProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'EditProfileState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$EditProfileErrorCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileErrorCopyWith(_EditProfileError value, $Res Function(_EditProfileError) _then) = __$EditProfileErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$EditProfileErrorCopyWithImpl<$Res>
    implements _$EditProfileErrorCopyWith<$Res> {
  __$EditProfileErrorCopyWithImpl(this._self, this._then);

  final _EditProfileError _self;
  final $Res Function(_EditProfileError) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_EditProfileError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EditProfileSuccess implements EditProfileState {
  const _EditProfileSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  EditProfileModel data;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileSuccessCopyWith<_EditProfileSuccess> get copyWith => __$EditProfileSuccessCopyWithImpl<_EditProfileSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'EditProfileState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$EditProfileSuccessCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileSuccessCopyWith(_EditProfileSuccess value, $Res Function(_EditProfileSuccess) _then) = __$EditProfileSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, EditProfileModel data
});




}
/// @nodoc
class __$EditProfileSuccessCopyWithImpl<$Res>
    implements _$EditProfileSuccessCopyWith<$Res> {
  __$EditProfileSuccessCopyWithImpl(this._self, this._then);

  final _EditProfileSuccess _self;
  final $Res Function(_EditProfileSuccess) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_EditProfileSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EditProfileModel,
  ));
}


}

// dart format on
