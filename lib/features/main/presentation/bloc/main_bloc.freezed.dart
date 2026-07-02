// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainEvent {

 RequestMainModel? get params;
/// Create a copy of MainEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainEventCopyWith<MainEvent> get copyWith => _$MainEventCopyWithImpl<MainEvent>(this as MainEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MainEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $MainEventCopyWith<$Res>  {
  factory $MainEventCopyWith(MainEvent value, $Res Function(MainEvent) _then) = _$MainEventCopyWithImpl;
@useResult
$Res call({
 RequestMainModel? params
});




}
/// @nodoc
class _$MainEventCopyWithImpl<$Res>
    implements $MainEventCopyWith<$Res> {
  _$MainEventCopyWithImpl(this._self, this._then);

  final MainEvent _self;
  final $Res Function(MainEvent) _then;

/// Create a copy of MainEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMainModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [MainEvent].
extension MainEventPatterns on MainEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnMain value)?  main,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnMain() when main != null:
return main(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnMain value)  main,}){
final _that = this;
switch (_that) {
case _OnMain():
return main(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnMain value)?  main,}){
final _that = this;
switch (_that) {
case _OnMain() when main != null:
return main(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestMainModel? params)?  main,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnMain() when main != null:
return main(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestMainModel? params)  main,}) {final _that = this;
switch (_that) {
case _OnMain():
return main(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestMainModel? params)?  main,}) {final _that = this;
switch (_that) {
case _OnMain() when main != null:
return main(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnMain implements MainEvent {
  const _OnMain({this.params});
  

@override final  RequestMainModel? params;

/// Create a copy of MainEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnMainCopyWith<_OnMain> get copyWith => __$OnMainCopyWithImpl<_OnMain>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMain&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MainEvent.main(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnMainCopyWith<$Res> implements $MainEventCopyWith<$Res> {
  factory _$OnMainCopyWith(_OnMain value, $Res Function(_OnMain) _then) = __$OnMainCopyWithImpl;
@override @useResult
$Res call({
 RequestMainModel? params
});




}
/// @nodoc
class __$OnMainCopyWithImpl<$Res>
    implements _$OnMainCopyWith<$Res> {
  __$OnMainCopyWithImpl(this._self, this._then);

  final _OnMain _self;
  final $Res Function(_OnMain) _then;

/// Create a copy of MainEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnMain(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMainModel?,
  ));
}


}

/// @nodoc
mixin _$MainState {

 bool get isLoading;
/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainStateCopyWith<MainState> get copyWith => _$MainStateCopyWithImpl<MainState>(this as MainState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MainState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $MainStateCopyWith<$Res>  {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) _then) = _$MainStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$MainStateCopyWithImpl<$Res>
    implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._self, this._then);

  final MainState _self;
  final $Res Function(MainState) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MainState].
extension MainStatePatterns on MainState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _MainLoading value)?  loading,TResult Function( _MainError value)?  error,TResult Function( _MainSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainLoading() when loading != null:
return loading(_that);case _MainError() when error != null:
return error(_that);case _MainSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _MainLoading value)  loading,required TResult Function( _MainError value)  error,required TResult Function( _MainSuccess value)  success,}){
final _that = this;
switch (_that) {
case _MainLoading():
return loading(_that);case _MainError():
return error(_that);case _MainSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _MainLoading value)?  loading,TResult? Function( _MainError value)?  error,TResult? Function( _MainSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _MainLoading() when loading != null:
return loading(_that);case _MainError() when error != null:
return error(_that);case _MainSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  MainModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainLoading() when loading != null:
return loading(_that.isLoading);case _MainError() when error != null:
return error(_that.isLoading,_that.message);case _MainSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  MainModel data)  success,}) {final _that = this;
switch (_that) {
case _MainLoading():
return loading(_that.isLoading);case _MainError():
return error(_that.isLoading,_that.message);case _MainSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  MainModel data)?  success,}) {final _that = this;
switch (_that) {
case _MainLoading() when loading != null:
return loading(_that.isLoading);case _MainError() when error != null:
return error(_that.isLoading,_that.message);case _MainSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _MainLoading implements MainState {
  const _MainLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainLoadingCopyWith<_MainLoading> get copyWith => __$MainLoadingCopyWithImpl<_MainLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MainState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$MainLoadingCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainLoadingCopyWith(_MainLoading value, $Res Function(_MainLoading) _then) = __$MainLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$MainLoadingCopyWithImpl<$Res>
    implements _$MainLoadingCopyWith<$Res> {
  __$MainLoadingCopyWithImpl(this._self, this._then);

  final _MainLoading _self;
  final $Res Function(_MainLoading) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_MainLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _MainError implements MainState {
  const _MainError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainErrorCopyWith<_MainError> get copyWith => __$MainErrorCopyWithImpl<_MainError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'MainState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MainErrorCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainErrorCopyWith(_MainError value, $Res Function(_MainError) _then) = __$MainErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$MainErrorCopyWithImpl<$Res>
    implements _$MainErrorCopyWith<$Res> {
  __$MainErrorCopyWithImpl(this._self, this._then);

  final _MainError _self;
  final $Res Function(_MainError) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_MainError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MainSuccess implements MainState {
  const _MainSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  MainModel data;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainSuccessCopyWith<_MainSuccess> get copyWith => __$MainSuccessCopyWithImpl<_MainSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'MainState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MainSuccessCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainSuccessCopyWith(_MainSuccess value, $Res Function(_MainSuccess) _then) = __$MainSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, MainModel data
});




}
/// @nodoc
class __$MainSuccessCopyWithImpl<$Res>
    implements _$MainSuccessCopyWith<$Res> {
  __$MainSuccessCopyWithImpl(this._self, this._then);

  final _MainSuccess _self;
  final $Res Function(_MainSuccess) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_MainSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MainModel,
  ));
}


}

// dart format on
