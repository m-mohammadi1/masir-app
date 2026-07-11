// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'units_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnitsEvent {

 RequestUnitsModel? get params;
/// Create a copy of UnitsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitsEventCopyWith<UnitsEvent> get copyWith => _$UnitsEventCopyWithImpl<UnitsEvent>(this as UnitsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'UnitsEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $UnitsEventCopyWith<$Res>  {
  factory $UnitsEventCopyWith(UnitsEvent value, $Res Function(UnitsEvent) _then) = _$UnitsEventCopyWithImpl;
@useResult
$Res call({
 RequestUnitsModel? params
});




}
/// @nodoc
class _$UnitsEventCopyWithImpl<$Res>
    implements $UnitsEventCopyWith<$Res> {
  _$UnitsEventCopyWithImpl(this._self, this._then);

  final UnitsEvent _self;
  final $Res Function(UnitsEvent) _then;

/// Create a copy of UnitsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestUnitsModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitsEvent].
extension UnitsEventPatterns on UnitsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnUnits value)?  units,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnUnits() when units != null:
return units(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnUnits value)  units,}){
final _that = this;
switch (_that) {
case _OnUnits():
return units(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnUnits value)?  units,}){
final _that = this;
switch (_that) {
case _OnUnits() when units != null:
return units(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestUnitsModel? params)?  units,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnUnits() when units != null:
return units(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestUnitsModel? params)  units,}) {final _that = this;
switch (_that) {
case _OnUnits():
return units(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestUnitsModel? params)?  units,}) {final _that = this;
switch (_that) {
case _OnUnits() when units != null:
return units(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnUnits implements UnitsEvent {
  const _OnUnits({this.params});
  

@override final  RequestUnitsModel? params;

/// Create a copy of UnitsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnUnitsCopyWith<_OnUnits> get copyWith => __$OnUnitsCopyWithImpl<_OnUnits>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnUnits&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'UnitsEvent.units(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnUnitsCopyWith<$Res> implements $UnitsEventCopyWith<$Res> {
  factory _$OnUnitsCopyWith(_OnUnits value, $Res Function(_OnUnits) _then) = __$OnUnitsCopyWithImpl;
@override @useResult
$Res call({
 RequestUnitsModel? params
});




}
/// @nodoc
class __$OnUnitsCopyWithImpl<$Res>
    implements _$OnUnitsCopyWith<$Res> {
  __$OnUnitsCopyWithImpl(this._self, this._then);

  final _OnUnits _self;
  final $Res Function(_OnUnits) _then;

/// Create a copy of UnitsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnUnits(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestUnitsModel?,
  ));
}


}

/// @nodoc
mixin _$UnitsState {

 bool get isLoading;
/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitsStateCopyWith<UnitsState> get copyWith => _$UnitsStateCopyWithImpl<UnitsState>(this as UnitsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'UnitsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $UnitsStateCopyWith<$Res>  {
  factory $UnitsStateCopyWith(UnitsState value, $Res Function(UnitsState) _then) = _$UnitsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$UnitsStateCopyWithImpl<$Res>
    implements $UnitsStateCopyWith<$Res> {
  _$UnitsStateCopyWithImpl(this._self, this._then);

  final UnitsState _self;
  final $Res Function(UnitsState) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitsState].
extension UnitsStatePatterns on UnitsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _UnitsLoading value)?  loading,TResult Function( _UnitsError value)?  error,TResult Function( _UnitsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitsLoading() when loading != null:
return loading(_that);case _UnitsError() when error != null:
return error(_that);case _UnitsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _UnitsLoading value)  loading,required TResult Function( _UnitsError value)  error,required TResult Function( _UnitsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _UnitsLoading():
return loading(_that);case _UnitsError():
return error(_that);case _UnitsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _UnitsLoading value)?  loading,TResult? Function( _UnitsError value)?  error,TResult? Function( _UnitsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _UnitsLoading() when loading != null:
return loading(_that);case _UnitsError() when error != null:
return error(_that);case _UnitsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  UnitsModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitsLoading() when loading != null:
return loading(_that.isLoading);case _UnitsError() when error != null:
return error(_that.isLoading,_that.message);case _UnitsSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  UnitsModel data)  success,}) {final _that = this;
switch (_that) {
case _UnitsLoading():
return loading(_that.isLoading);case _UnitsError():
return error(_that.isLoading,_that.message);case _UnitsSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  UnitsModel data)?  success,}) {final _that = this;
switch (_that) {
case _UnitsLoading() when loading != null:
return loading(_that.isLoading);case _UnitsError() when error != null:
return error(_that.isLoading,_that.message);case _UnitsSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _UnitsLoading implements UnitsState {
  const _UnitsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitsLoadingCopyWith<_UnitsLoading> get copyWith => __$UnitsLoadingCopyWithImpl<_UnitsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'UnitsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$UnitsLoadingCopyWith<$Res> implements $UnitsStateCopyWith<$Res> {
  factory _$UnitsLoadingCopyWith(_UnitsLoading value, $Res Function(_UnitsLoading) _then) = __$UnitsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$UnitsLoadingCopyWithImpl<$Res>
    implements _$UnitsLoadingCopyWith<$Res> {
  __$UnitsLoadingCopyWithImpl(this._self, this._then);

  final _UnitsLoading _self;
  final $Res Function(_UnitsLoading) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_UnitsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _UnitsError implements UnitsState {
  const _UnitsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitsErrorCopyWith<_UnitsError> get copyWith => __$UnitsErrorCopyWithImpl<_UnitsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'UnitsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnitsErrorCopyWith<$Res> implements $UnitsStateCopyWith<$Res> {
  factory _$UnitsErrorCopyWith(_UnitsError value, $Res Function(_UnitsError) _then) = __$UnitsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$UnitsErrorCopyWithImpl<$Res>
    implements _$UnitsErrorCopyWith<$Res> {
  __$UnitsErrorCopyWithImpl(this._self, this._then);

  final _UnitsError _self;
  final $Res Function(_UnitsError) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_UnitsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UnitsSuccess implements UnitsState {
  const _UnitsSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  UnitsModel data;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitsSuccessCopyWith<_UnitsSuccess> get copyWith => __$UnitsSuccessCopyWithImpl<_UnitsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'UnitsState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UnitsSuccessCopyWith<$Res> implements $UnitsStateCopyWith<$Res> {
  factory _$UnitsSuccessCopyWith(_UnitsSuccess value, $Res Function(_UnitsSuccess) _then) = __$UnitsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, UnitsModel data
});




}
/// @nodoc
class __$UnitsSuccessCopyWithImpl<$Res>
    implements _$UnitsSuccessCopyWith<$Res> {
  __$UnitsSuccessCopyWithImpl(this._self, this._then);

  final _UnitsSuccess _self;
  final $Res Function(_UnitsSuccess) _then;

/// Create a copy of UnitsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_UnitsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UnitsModel,
  ));
}


}

// dart format on
