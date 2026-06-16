// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_us_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AboutUsEvent {

 RequestAboutUsModel? get params;
/// Create a copy of AboutUsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutUsEventCopyWith<AboutUsEvent> get copyWith => _$AboutUsEventCopyWithImpl<AboutUsEvent>(this as AboutUsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutUsEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'AboutUsEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $AboutUsEventCopyWith<$Res>  {
  factory $AboutUsEventCopyWith(AboutUsEvent value, $Res Function(AboutUsEvent) _then) = _$AboutUsEventCopyWithImpl;
@useResult
$Res call({
 RequestAboutUsModel? params
});




}
/// @nodoc
class _$AboutUsEventCopyWithImpl<$Res>
    implements $AboutUsEventCopyWith<$Res> {
  _$AboutUsEventCopyWithImpl(this._self, this._then);

  final AboutUsEvent _self;
  final $Res Function(AboutUsEvent) _then;

/// Create a copy of AboutUsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestAboutUsModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutUsEvent].
extension AboutUsEventPatterns on AboutUsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnAboutUs value)?  aboutUs,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnAboutUs() when aboutUs != null:
return aboutUs(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnAboutUs value)  aboutUs,}){
final _that = this;
switch (_that) {
case _OnAboutUs():
return aboutUs(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnAboutUs value)?  aboutUs,}){
final _that = this;
switch (_that) {
case _OnAboutUs() when aboutUs != null:
return aboutUs(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestAboutUsModel? params)?  aboutUs,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnAboutUs() when aboutUs != null:
return aboutUs(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestAboutUsModel? params)  aboutUs,}) {final _that = this;
switch (_that) {
case _OnAboutUs():
return aboutUs(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestAboutUsModel? params)?  aboutUs,}) {final _that = this;
switch (_that) {
case _OnAboutUs() when aboutUs != null:
return aboutUs(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnAboutUs implements AboutUsEvent {
  const _OnAboutUs({this.params});
  

@override final  RequestAboutUsModel? params;

/// Create a copy of AboutUsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnAboutUsCopyWith<_OnAboutUs> get copyWith => __$OnAboutUsCopyWithImpl<_OnAboutUs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnAboutUs&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'AboutUsEvent.aboutUs(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnAboutUsCopyWith<$Res> implements $AboutUsEventCopyWith<$Res> {
  factory _$OnAboutUsCopyWith(_OnAboutUs value, $Res Function(_OnAboutUs) _then) = __$OnAboutUsCopyWithImpl;
@override @useResult
$Res call({
 RequestAboutUsModel? params
});




}
/// @nodoc
class __$OnAboutUsCopyWithImpl<$Res>
    implements _$OnAboutUsCopyWith<$Res> {
  __$OnAboutUsCopyWithImpl(this._self, this._then);

  final _OnAboutUs _self;
  final $Res Function(_OnAboutUs) _then;

/// Create a copy of AboutUsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnAboutUs(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestAboutUsModel?,
  ));
}


}

/// @nodoc
mixin _$AboutUsState {

 bool get isLoading;
/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AboutUsStateCopyWith<AboutUsState> get copyWith => _$AboutUsStateCopyWithImpl<AboutUsState>(this as AboutUsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AboutUsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AboutUsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AboutUsStateCopyWith<$Res>  {
  factory $AboutUsStateCopyWith(AboutUsState value, $Res Function(AboutUsState) _then) = _$AboutUsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$AboutUsStateCopyWithImpl<$Res>
    implements $AboutUsStateCopyWith<$Res> {
  _$AboutUsStateCopyWithImpl(this._self, this._then);

  final AboutUsState _self;
  final $Res Function(AboutUsState) _then;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AboutUsState].
extension AboutUsStatePatterns on AboutUsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AboutUsLoading value)?  loading,TResult Function( _AboutUsError value)?  error,TResult Function( _AboutUsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AboutUsLoading() when loading != null:
return loading(_that);case _AboutUsError() when error != null:
return error(_that);case _AboutUsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AboutUsLoading value)  loading,required TResult Function( _AboutUsError value)  error,required TResult Function( _AboutUsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _AboutUsLoading():
return loading(_that);case _AboutUsError():
return error(_that);case _AboutUsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AboutUsLoading value)?  loading,TResult? Function( _AboutUsError value)?  error,TResult? Function( _AboutUsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _AboutUsLoading() when loading != null:
return loading(_that);case _AboutUsError() when error != null:
return error(_that);case _AboutUsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  AboutUsModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AboutUsLoading() when loading != null:
return loading(_that.isLoading);case _AboutUsError() when error != null:
return error(_that.isLoading,_that.message);case _AboutUsSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  AboutUsModel data)  success,}) {final _that = this;
switch (_that) {
case _AboutUsLoading():
return loading(_that.isLoading);case _AboutUsError():
return error(_that.isLoading,_that.message);case _AboutUsSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  AboutUsModel data)?  success,}) {final _that = this;
switch (_that) {
case _AboutUsLoading() when loading != null:
return loading(_that.isLoading);case _AboutUsError() when error != null:
return error(_that.isLoading,_that.message);case _AboutUsSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _AboutUsLoading implements AboutUsState {
  const _AboutUsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutUsLoadingCopyWith<_AboutUsLoading> get copyWith => __$AboutUsLoadingCopyWithImpl<_AboutUsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutUsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AboutUsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AboutUsLoadingCopyWith<$Res> implements $AboutUsStateCopyWith<$Res> {
  factory _$AboutUsLoadingCopyWith(_AboutUsLoading value, $Res Function(_AboutUsLoading) _then) = __$AboutUsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$AboutUsLoadingCopyWithImpl<$Res>
    implements _$AboutUsLoadingCopyWith<$Res> {
  __$AboutUsLoadingCopyWithImpl(this._self, this._then);

  final _AboutUsLoading _self;
  final $Res Function(_AboutUsLoading) _then;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_AboutUsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AboutUsError implements AboutUsState {
  const _AboutUsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutUsErrorCopyWith<_AboutUsError> get copyWith => __$AboutUsErrorCopyWithImpl<_AboutUsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutUsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'AboutUsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AboutUsErrorCopyWith<$Res> implements $AboutUsStateCopyWith<$Res> {
  factory _$AboutUsErrorCopyWith(_AboutUsError value, $Res Function(_AboutUsError) _then) = __$AboutUsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$AboutUsErrorCopyWithImpl<$Res>
    implements _$AboutUsErrorCopyWith<$Res> {
  __$AboutUsErrorCopyWithImpl(this._self, this._then);

  final _AboutUsError _self;
  final $Res Function(_AboutUsError) _then;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_AboutUsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AboutUsSuccess implements AboutUsState {
  const _AboutUsSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  AboutUsModel data;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AboutUsSuccessCopyWith<_AboutUsSuccess> get copyWith => __$AboutUsSuccessCopyWithImpl<_AboutUsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AboutUsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'AboutUsState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AboutUsSuccessCopyWith<$Res> implements $AboutUsStateCopyWith<$Res> {
  factory _$AboutUsSuccessCopyWith(_AboutUsSuccess value, $Res Function(_AboutUsSuccess) _then) = __$AboutUsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, AboutUsModel data
});




}
/// @nodoc
class __$AboutUsSuccessCopyWithImpl<$Res>
    implements _$AboutUsSuccessCopyWith<$Res> {
  __$AboutUsSuccessCopyWithImpl(this._self, this._then);

  final _AboutUsSuccess _self;
  final $Res Function(_AboutUsSuccess) _then;

/// Create a copy of AboutUsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_AboutUsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AboutUsModel,
  ));
}


}

// dart format on
