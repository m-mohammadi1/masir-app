// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizEvent()';
}


}

/// @nodoc
class $QuizEventCopyWith<$Res>  {
$QuizEventCopyWith(QuizEvent _, $Res Function(QuizEvent) __);
}


/// Adds pattern-matching-related methods to [QuizEvent].
extension QuizEventPatterns on QuizEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnQuiz value)?  quiz,TResult Function( _ChangeStepEvent value)?  changeStep,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnQuiz() when quiz != null:
return quiz(_that);case _ChangeStepEvent() when changeStep != null:
return changeStep(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnQuiz value)  quiz,required TResult Function( _ChangeStepEvent value)  changeStep,}){
final _that = this;
switch (_that) {
case _OnQuiz():
return quiz(_that);case _ChangeStepEvent():
return changeStep(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnQuiz value)?  quiz,TResult? Function( _ChangeStepEvent value)?  changeStep,}){
final _that = this;
switch (_that) {
case _OnQuiz() when quiz != null:
return quiz(_that);case _ChangeStepEvent() when changeStep != null:
return changeStep(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestQuizModel? params)?  quiz,TResult Function( int value)?  changeStep,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnQuiz() when quiz != null:
return quiz(_that.params);case _ChangeStepEvent() when changeStep != null:
return changeStep(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestQuizModel? params)  quiz,required TResult Function( int value)  changeStep,}) {final _that = this;
switch (_that) {
case _OnQuiz():
return quiz(_that.params);case _ChangeStepEvent():
return changeStep(_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestQuizModel? params)?  quiz,TResult? Function( int value)?  changeStep,}) {final _that = this;
switch (_that) {
case _OnQuiz() when quiz != null:
return quiz(_that.params);case _ChangeStepEvent() when changeStep != null:
return changeStep(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _OnQuiz implements QuizEvent {
  const _OnQuiz({this.params});
  

 final  RequestQuizModel? params;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnQuizCopyWith<_OnQuiz> get copyWith => __$OnQuizCopyWithImpl<_OnQuiz>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnQuiz&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'QuizEvent.quiz(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnQuizCopyWith<$Res> implements $QuizEventCopyWith<$Res> {
  factory _$OnQuizCopyWith(_OnQuiz value, $Res Function(_OnQuiz) _then) = __$OnQuizCopyWithImpl;
@useResult
$Res call({
 RequestQuizModel? params
});




}
/// @nodoc
class __$OnQuizCopyWithImpl<$Res>
    implements _$OnQuizCopyWith<$Res> {
  __$OnQuizCopyWithImpl(this._self, this._then);

  final _OnQuiz _self;
  final $Res Function(_OnQuiz) _then;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnQuiz(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestQuizModel?,
  ));
}


}

/// @nodoc


class _ChangeStepEvent implements QuizEvent {
  const _ChangeStepEvent({required this.value});
  

 final  int value;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeStepEventCopyWith<_ChangeStepEvent> get copyWith => __$ChangeStepEventCopyWithImpl<_ChangeStepEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeStepEvent&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'QuizEvent.changeStep(value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChangeStepEventCopyWith<$Res> implements $QuizEventCopyWith<$Res> {
  factory _$ChangeStepEventCopyWith(_ChangeStepEvent value, $Res Function(_ChangeStepEvent) _then) = __$ChangeStepEventCopyWithImpl;
@useResult
$Res call({
 int value
});




}
/// @nodoc
class __$ChangeStepEventCopyWithImpl<$Res>
    implements _$ChangeStepEventCopyWith<$Res> {
  __$ChangeStepEventCopyWithImpl(this._self, this._then);

  final _ChangeStepEvent _self;
  final $Res Function(_ChangeStepEvent) _then;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_ChangeStepEvent(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$QuizState {

 bool get isLoading; int get step;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,step);

@override
String toString() {
  return 'QuizState(isLoading: $isLoading, step: $step)';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int step
});




}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? step = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _QuizLoading value)?  loading,TResult Function( _ChangeIndex value)?  changeIndex,TResult Function( _QuizError value)?  error,TResult Function( _QuizSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizLoading() when loading != null:
return loading(_that);case _ChangeIndex() when changeIndex != null:
return changeIndex(_that);case _QuizError() when error != null:
return error(_that);case _QuizSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _QuizLoading value)  loading,required TResult Function( _ChangeIndex value)  changeIndex,required TResult Function( _QuizError value)  error,required TResult Function( _QuizSuccess value)  success,}){
final _that = this;
switch (_that) {
case _QuizLoading():
return loading(_that);case _ChangeIndex():
return changeIndex(_that);case _QuizError():
return error(_that);case _QuizSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _QuizLoading value)?  loading,TResult? Function( _ChangeIndex value)?  changeIndex,TResult? Function( _QuizError value)?  error,TResult? Function( _QuizSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _QuizLoading() when loading != null:
return loading(_that);case _ChangeIndex() when changeIndex != null:
return changeIndex(_that);case _QuizError() when error != null:
return error(_that);case _QuizSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading,  int step)?  loading,TResult Function( bool isLoading,  int step)?  changeIndex,TResult Function( bool isLoading,  int step,  String message)?  error,TResult Function( bool isLoading,  int step,  QuizModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizLoading() when loading != null:
return loading(_that.isLoading,_that.step);case _ChangeIndex() when changeIndex != null:
return changeIndex(_that.isLoading,_that.step);case _QuizError() when error != null:
return error(_that.isLoading,_that.step,_that.message);case _QuizSuccess() when success != null:
return success(_that.isLoading,_that.step,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading,  int step)  loading,required TResult Function( bool isLoading,  int step)  changeIndex,required TResult Function( bool isLoading,  int step,  String message)  error,required TResult Function( bool isLoading,  int step,  QuizModel data)  success,}) {final _that = this;
switch (_that) {
case _QuizLoading():
return loading(_that.isLoading,_that.step);case _ChangeIndex():
return changeIndex(_that.isLoading,_that.step);case _QuizError():
return error(_that.isLoading,_that.step,_that.message);case _QuizSuccess():
return success(_that.isLoading,_that.step,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading,  int step)?  loading,TResult? Function( bool isLoading,  int step)?  changeIndex,TResult? Function( bool isLoading,  int step,  String message)?  error,TResult? Function( bool isLoading,  int step,  QuizModel data)?  success,}) {final _that = this;
switch (_that) {
case _QuizLoading() when loading != null:
return loading(_that.isLoading,_that.step);case _ChangeIndex() when changeIndex != null:
return changeIndex(_that.isLoading,_that.step);case _QuizError() when error != null:
return error(_that.isLoading,_that.step,_that.message);case _QuizSuccess() when success != null:
return success(_that.isLoading,_that.step,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _QuizLoading implements QuizState {
  const _QuizLoading({required this.isLoading, required this.step});
  

@override final  bool isLoading;
@override final  int step;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizLoadingCopyWith<_QuizLoading> get copyWith => __$QuizLoadingCopyWithImpl<_QuizLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,step);

@override
String toString() {
  return 'QuizState.loading(isLoading: $isLoading, step: $step)';
}


}

/// @nodoc
abstract mixin class _$QuizLoadingCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizLoadingCopyWith(_QuizLoading value, $Res Function(_QuizLoading) _then) = __$QuizLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int step
});




}
/// @nodoc
class __$QuizLoadingCopyWithImpl<$Res>
    implements _$QuizLoadingCopyWith<$Res> {
  __$QuizLoadingCopyWithImpl(this._self, this._then);

  final _QuizLoading _self;
  final $Res Function(_QuizLoading) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? step = null,}) {
  return _then(_QuizLoading(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ChangeIndex implements QuizState {
  const _ChangeIndex({required this.isLoading, required this.step});
  

@override final  bool isLoading;
@override final  int step;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeIndexCopyWith<_ChangeIndex> get copyWith => __$ChangeIndexCopyWithImpl<_ChangeIndex>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeIndex&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,step);

@override
String toString() {
  return 'QuizState.changeIndex(isLoading: $isLoading, step: $step)';
}


}

/// @nodoc
abstract mixin class _$ChangeIndexCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$ChangeIndexCopyWith(_ChangeIndex value, $Res Function(_ChangeIndex) _then) = __$ChangeIndexCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int step
});




}
/// @nodoc
class __$ChangeIndexCopyWithImpl<$Res>
    implements _$ChangeIndexCopyWith<$Res> {
  __$ChangeIndexCopyWithImpl(this._self, this._then);

  final _ChangeIndex _self;
  final $Res Function(_ChangeIndex) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? step = null,}) {
  return _then(_ChangeIndex(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _QuizError implements QuizState {
  const _QuizError({required this.isLoading, required this.step, required this.message});
  

@override final  bool isLoading;
@override final  int step;
 final  String message;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizErrorCopyWith<_QuizError> get copyWith => __$QuizErrorCopyWithImpl<_QuizError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.step, step) || other.step == step)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,step,message);

@override
String toString() {
  return 'QuizState.error(isLoading: $isLoading, step: $step, message: $message)';
}


}

/// @nodoc
abstract mixin class _$QuizErrorCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizErrorCopyWith(_QuizError value, $Res Function(_QuizError) _then) = __$QuizErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int step, String message
});




}
/// @nodoc
class __$QuizErrorCopyWithImpl<$Res>
    implements _$QuizErrorCopyWith<$Res> {
  __$QuizErrorCopyWithImpl(this._self, this._then);

  final _QuizError _self;
  final $Res Function(_QuizError) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? step = null,Object? message = null,}) {
  return _then(_QuizError(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _QuizSuccess implements QuizState {
  const _QuizSuccess({required this.isLoading, required this.step, required this.data});
  

@override final  bool isLoading;
@override final  int step;
 final  QuizModel data;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSuccessCopyWith<_QuizSuccess> get copyWith => __$QuizSuccessCopyWithImpl<_QuizSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.step, step) || other.step == step)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,step,data);

@override
String toString() {
  return 'QuizState.success(isLoading: $isLoading, step: $step, data: $data)';
}


}

/// @nodoc
abstract mixin class _$QuizSuccessCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizSuccessCopyWith(_QuizSuccess value, $Res Function(_QuizSuccess) _then) = __$QuizSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int step, QuizModel data
});




}
/// @nodoc
class __$QuizSuccessCopyWithImpl<$Res>
    implements _$QuizSuccessCopyWith<$Res> {
  __$QuizSuccessCopyWithImpl(this._self, this._then);

  final _QuizSuccess _self;
  final $Res Function(_QuizSuccess) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? step = null,Object? data = null,}) {
  return _then(_QuizSuccess(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizModel,
  ));
}


}

// dart format on
