// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_submit_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizSubmitEvent {

 RequestQuizSubmitModel? get params;
/// Create a copy of QuizSubmitEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSubmitEventCopyWith<QuizSubmitEvent> get copyWith => _$QuizSubmitEventCopyWithImpl<QuizSubmitEvent>(this as QuizSubmitEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSubmitEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'QuizSubmitEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $QuizSubmitEventCopyWith<$Res>  {
  factory $QuizSubmitEventCopyWith(QuizSubmitEvent value, $Res Function(QuizSubmitEvent) _then) = _$QuizSubmitEventCopyWithImpl;
@useResult
$Res call({
 RequestQuizSubmitModel? params
});




}
/// @nodoc
class _$QuizSubmitEventCopyWithImpl<$Res>
    implements $QuizSubmitEventCopyWith<$Res> {
  _$QuizSubmitEventCopyWithImpl(this._self, this._then);

  final QuizSubmitEvent _self;
  final $Res Function(QuizSubmitEvent) _then;

/// Create a copy of QuizSubmitEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestQuizSubmitModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSubmitEvent].
extension QuizSubmitEventPatterns on QuizSubmitEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnQuizSubmit value)?  quizSubmit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnQuizSubmit() when quizSubmit != null:
return quizSubmit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnQuizSubmit value)  quizSubmit,}){
final _that = this;
switch (_that) {
case _OnQuizSubmit():
return quizSubmit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnQuizSubmit value)?  quizSubmit,}){
final _that = this;
switch (_that) {
case _OnQuizSubmit() when quizSubmit != null:
return quizSubmit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestQuizSubmitModel? params)?  quizSubmit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnQuizSubmit() when quizSubmit != null:
return quizSubmit(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestQuizSubmitModel? params)  quizSubmit,}) {final _that = this;
switch (_that) {
case _OnQuizSubmit():
return quizSubmit(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestQuizSubmitModel? params)?  quizSubmit,}) {final _that = this;
switch (_that) {
case _OnQuizSubmit() when quizSubmit != null:
return quizSubmit(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnQuizSubmit implements QuizSubmitEvent {
  const _OnQuizSubmit({this.params});
  

@override final  RequestQuizSubmitModel? params;

/// Create a copy of QuizSubmitEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnQuizSubmitCopyWith<_OnQuizSubmit> get copyWith => __$OnQuizSubmitCopyWithImpl<_OnQuizSubmit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnQuizSubmit&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'QuizSubmitEvent.quizSubmit(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnQuizSubmitCopyWith<$Res> implements $QuizSubmitEventCopyWith<$Res> {
  factory _$OnQuizSubmitCopyWith(_OnQuizSubmit value, $Res Function(_OnQuizSubmit) _then) = __$OnQuizSubmitCopyWithImpl;
@override @useResult
$Res call({
 RequestQuizSubmitModel? params
});




}
/// @nodoc
class __$OnQuizSubmitCopyWithImpl<$Res>
    implements _$OnQuizSubmitCopyWith<$Res> {
  __$OnQuizSubmitCopyWithImpl(this._self, this._then);

  final _OnQuizSubmit _self;
  final $Res Function(_OnQuizSubmit) _then;

/// Create a copy of QuizSubmitEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnQuizSubmit(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestQuizSubmitModel?,
  ));
}


}

/// @nodoc
mixin _$QuizSubmitState {

 bool get isLoading;
/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSubmitStateCopyWith<QuizSubmitState> get copyWith => _$QuizSubmitStateCopyWithImpl<QuizSubmitState>(this as QuizSubmitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSubmitState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'QuizSubmitState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $QuizSubmitStateCopyWith<$Res>  {
  factory $QuizSubmitStateCopyWith(QuizSubmitState value, $Res Function(QuizSubmitState) _then) = _$QuizSubmitStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$QuizSubmitStateCopyWithImpl<$Res>
    implements $QuizSubmitStateCopyWith<$Res> {
  _$QuizSubmitStateCopyWithImpl(this._self, this._then);

  final QuizSubmitState _self;
  final $Res Function(QuizSubmitState) _then;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSubmitState].
extension QuizSubmitStatePatterns on QuizSubmitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _QuizSubmitLoading value)?  loading,TResult Function( _QuizSubmitError value)?  error,TResult Function( _QuizSubmitSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSubmitLoading() when loading != null:
return loading(_that);case _QuizSubmitError() when error != null:
return error(_that);case _QuizSubmitSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _QuizSubmitLoading value)  loading,required TResult Function( _QuizSubmitError value)  error,required TResult Function( _QuizSubmitSuccess value)  success,}){
final _that = this;
switch (_that) {
case _QuizSubmitLoading():
return loading(_that);case _QuizSubmitError():
return error(_that);case _QuizSubmitSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _QuizSubmitLoading value)?  loading,TResult? Function( _QuizSubmitError value)?  error,TResult? Function( _QuizSubmitSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _QuizSubmitLoading() when loading != null:
return loading(_that);case _QuizSubmitError() when error != null:
return error(_that);case _QuizSubmitSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  QuizSubmitResponseModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSubmitLoading() when loading != null:
return loading(_that.isLoading);case _QuizSubmitError() when error != null:
return error(_that.isLoading,_that.message);case _QuizSubmitSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  QuizSubmitResponseModel data)  success,}) {final _that = this;
switch (_that) {
case _QuizSubmitLoading():
return loading(_that.isLoading);case _QuizSubmitError():
return error(_that.isLoading,_that.message);case _QuizSubmitSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  QuizSubmitResponseModel data)?  success,}) {final _that = this;
switch (_that) {
case _QuizSubmitLoading() when loading != null:
return loading(_that.isLoading);case _QuizSubmitError() when error != null:
return error(_that.isLoading,_that.message);case _QuizSubmitSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _QuizSubmitLoading implements QuizSubmitState {
  const _QuizSubmitLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSubmitLoadingCopyWith<_QuizSubmitLoading> get copyWith => __$QuizSubmitLoadingCopyWithImpl<_QuizSubmitLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSubmitLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'QuizSubmitState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$QuizSubmitLoadingCopyWith<$Res> implements $QuizSubmitStateCopyWith<$Res> {
  factory _$QuizSubmitLoadingCopyWith(_QuizSubmitLoading value, $Res Function(_QuizSubmitLoading) _then) = __$QuizSubmitLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$QuizSubmitLoadingCopyWithImpl<$Res>
    implements _$QuizSubmitLoadingCopyWith<$Res> {
  __$QuizSubmitLoadingCopyWithImpl(this._self, this._then);

  final _QuizSubmitLoading _self;
  final $Res Function(_QuizSubmitLoading) _then;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_QuizSubmitLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _QuizSubmitError implements QuizSubmitState {
  const _QuizSubmitError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSubmitErrorCopyWith<_QuizSubmitError> get copyWith => __$QuizSubmitErrorCopyWithImpl<_QuizSubmitError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSubmitError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'QuizSubmitState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$QuizSubmitErrorCopyWith<$Res> implements $QuizSubmitStateCopyWith<$Res> {
  factory _$QuizSubmitErrorCopyWith(_QuizSubmitError value, $Res Function(_QuizSubmitError) _then) = __$QuizSubmitErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$QuizSubmitErrorCopyWithImpl<$Res>
    implements _$QuizSubmitErrorCopyWith<$Res> {
  __$QuizSubmitErrorCopyWithImpl(this._self, this._then);

  final _QuizSubmitError _self;
  final $Res Function(_QuizSubmitError) _then;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_QuizSubmitError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _QuizSubmitSuccess implements QuizSubmitState {
  const _QuizSubmitSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  QuizSubmitResponseModel data;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSubmitSuccessCopyWith<_QuizSubmitSuccess> get copyWith => __$QuizSubmitSuccessCopyWithImpl<_QuizSubmitSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSubmitSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'QuizSubmitState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$QuizSubmitSuccessCopyWith<$Res> implements $QuizSubmitStateCopyWith<$Res> {
  factory _$QuizSubmitSuccessCopyWith(_QuizSubmitSuccess value, $Res Function(_QuizSubmitSuccess) _then) = __$QuizSubmitSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, QuizSubmitResponseModel data
});




}
/// @nodoc
class __$QuizSubmitSuccessCopyWithImpl<$Res>
    implements _$QuizSubmitSuccessCopyWith<$Res> {
  __$QuizSubmitSuccessCopyWithImpl(this._self, this._then);

  final _QuizSubmitSuccess _self;
  final $Res Function(_QuizSubmitSuccess) _then;

/// Create a copy of QuizSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_QuizSubmitSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizSubmitResponseModel,
  ));
}


}

// dart format on
