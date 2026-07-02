// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_subscriptions_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MySubscriptionsEvent {

 RequestMySubscriptionsModel? get params;
/// Create a copy of MySubscriptionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MySubscriptionsEventCopyWith<MySubscriptionsEvent> get copyWith => _$MySubscriptionsEventCopyWithImpl<MySubscriptionsEvent>(this as MySubscriptionsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MySubscriptionsEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MySubscriptionsEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $MySubscriptionsEventCopyWith<$Res>  {
  factory $MySubscriptionsEventCopyWith(MySubscriptionsEvent value, $Res Function(MySubscriptionsEvent) _then) = _$MySubscriptionsEventCopyWithImpl;
@useResult
$Res call({
 RequestMySubscriptionsModel? params
});




}
/// @nodoc
class _$MySubscriptionsEventCopyWithImpl<$Res>
    implements $MySubscriptionsEventCopyWith<$Res> {
  _$MySubscriptionsEventCopyWithImpl(this._self, this._then);

  final MySubscriptionsEvent _self;
  final $Res Function(MySubscriptionsEvent) _then;

/// Create a copy of MySubscriptionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMySubscriptionsModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [MySubscriptionsEvent].
extension MySubscriptionsEventPatterns on MySubscriptionsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnMySubscriptions value)?  mySubscriptions,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnMySubscriptions() when mySubscriptions != null:
return mySubscriptions(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnMySubscriptions value)  mySubscriptions,}){
final _that = this;
switch (_that) {
case _OnMySubscriptions():
return mySubscriptions(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnMySubscriptions value)?  mySubscriptions,}){
final _that = this;
switch (_that) {
case _OnMySubscriptions() when mySubscriptions != null:
return mySubscriptions(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestMySubscriptionsModel? params)?  mySubscriptions,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnMySubscriptions() when mySubscriptions != null:
return mySubscriptions(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestMySubscriptionsModel? params)  mySubscriptions,}) {final _that = this;
switch (_that) {
case _OnMySubscriptions():
return mySubscriptions(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestMySubscriptionsModel? params)?  mySubscriptions,}) {final _that = this;
switch (_that) {
case _OnMySubscriptions() when mySubscriptions != null:
return mySubscriptions(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnMySubscriptions implements MySubscriptionsEvent {
  const _OnMySubscriptions({this.params});
  

@override final  RequestMySubscriptionsModel? params;

/// Create a copy of MySubscriptionsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnMySubscriptionsCopyWith<_OnMySubscriptions> get copyWith => __$OnMySubscriptionsCopyWithImpl<_OnMySubscriptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMySubscriptions&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MySubscriptionsEvent.mySubscriptions(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnMySubscriptionsCopyWith<$Res> implements $MySubscriptionsEventCopyWith<$Res> {
  factory _$OnMySubscriptionsCopyWith(_OnMySubscriptions value, $Res Function(_OnMySubscriptions) _then) = __$OnMySubscriptionsCopyWithImpl;
@override @useResult
$Res call({
 RequestMySubscriptionsModel? params
});




}
/// @nodoc
class __$OnMySubscriptionsCopyWithImpl<$Res>
    implements _$OnMySubscriptionsCopyWith<$Res> {
  __$OnMySubscriptionsCopyWithImpl(this._self, this._then);

  final _OnMySubscriptions _self;
  final $Res Function(_OnMySubscriptions) _then;

/// Create a copy of MySubscriptionsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnMySubscriptions(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMySubscriptionsModel?,
  ));
}


}

/// @nodoc
mixin _$MySubscriptionsState {

 bool get isLoading;
/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MySubscriptionsStateCopyWith<MySubscriptionsState> get copyWith => _$MySubscriptionsStateCopyWithImpl<MySubscriptionsState>(this as MySubscriptionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MySubscriptionsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MySubscriptionsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $MySubscriptionsStateCopyWith<$Res>  {
  factory $MySubscriptionsStateCopyWith(MySubscriptionsState value, $Res Function(MySubscriptionsState) _then) = _$MySubscriptionsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$MySubscriptionsStateCopyWithImpl<$Res>
    implements $MySubscriptionsStateCopyWith<$Res> {
  _$MySubscriptionsStateCopyWithImpl(this._self, this._then);

  final MySubscriptionsState _self;
  final $Res Function(MySubscriptionsState) _then;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MySubscriptionsState].
extension MySubscriptionsStatePatterns on MySubscriptionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _MySubscriptionsLoading value)?  loading,TResult Function( _MySubscriptionsError value)?  error,TResult Function( _MySubscriptionsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MySubscriptionsLoading() when loading != null:
return loading(_that);case _MySubscriptionsError() when error != null:
return error(_that);case _MySubscriptionsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _MySubscriptionsLoading value)  loading,required TResult Function( _MySubscriptionsError value)  error,required TResult Function( _MySubscriptionsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _MySubscriptionsLoading():
return loading(_that);case _MySubscriptionsError():
return error(_that);case _MySubscriptionsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _MySubscriptionsLoading value)?  loading,TResult? Function( _MySubscriptionsError value)?  error,TResult? Function( _MySubscriptionsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _MySubscriptionsLoading() when loading != null:
return loading(_that);case _MySubscriptionsError() when error != null:
return error(_that);case _MySubscriptionsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<MySubscriptionsModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MySubscriptionsLoading() when loading != null:
return loading(_that.isLoading);case _MySubscriptionsError() when error != null:
return error(_that.isLoading,_that.message);case _MySubscriptionsSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<MySubscriptionsModel> data)  success,}) {final _that = this;
switch (_that) {
case _MySubscriptionsLoading():
return loading(_that.isLoading);case _MySubscriptionsError():
return error(_that.isLoading,_that.message);case _MySubscriptionsSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<MySubscriptionsModel> data)?  success,}) {final _that = this;
switch (_that) {
case _MySubscriptionsLoading() when loading != null:
return loading(_that.isLoading);case _MySubscriptionsError() when error != null:
return error(_that.isLoading,_that.message);case _MySubscriptionsSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _MySubscriptionsLoading implements MySubscriptionsState {
  const _MySubscriptionsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MySubscriptionsLoadingCopyWith<_MySubscriptionsLoading> get copyWith => __$MySubscriptionsLoadingCopyWithImpl<_MySubscriptionsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MySubscriptionsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MySubscriptionsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$MySubscriptionsLoadingCopyWith<$Res> implements $MySubscriptionsStateCopyWith<$Res> {
  factory _$MySubscriptionsLoadingCopyWith(_MySubscriptionsLoading value, $Res Function(_MySubscriptionsLoading) _then) = __$MySubscriptionsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$MySubscriptionsLoadingCopyWithImpl<$Res>
    implements _$MySubscriptionsLoadingCopyWith<$Res> {
  __$MySubscriptionsLoadingCopyWithImpl(this._self, this._then);

  final _MySubscriptionsLoading _self;
  final $Res Function(_MySubscriptionsLoading) _then;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_MySubscriptionsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _MySubscriptionsError implements MySubscriptionsState {
  const _MySubscriptionsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MySubscriptionsErrorCopyWith<_MySubscriptionsError> get copyWith => __$MySubscriptionsErrorCopyWithImpl<_MySubscriptionsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MySubscriptionsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'MySubscriptionsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MySubscriptionsErrorCopyWith<$Res> implements $MySubscriptionsStateCopyWith<$Res> {
  factory _$MySubscriptionsErrorCopyWith(_MySubscriptionsError value, $Res Function(_MySubscriptionsError) _then) = __$MySubscriptionsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$MySubscriptionsErrorCopyWithImpl<$Res>
    implements _$MySubscriptionsErrorCopyWith<$Res> {
  __$MySubscriptionsErrorCopyWithImpl(this._self, this._then);

  final _MySubscriptionsError _self;
  final $Res Function(_MySubscriptionsError) _then;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_MySubscriptionsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MySubscriptionsSuccess implements MySubscriptionsState {
  const _MySubscriptionsSuccess(this.isLoading, final  List<MySubscriptionsModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<MySubscriptionsModel> _data;
 List<MySubscriptionsModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MySubscriptionsSuccessCopyWith<_MySubscriptionsSuccess> get copyWith => __$MySubscriptionsSuccessCopyWithImpl<_MySubscriptionsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MySubscriptionsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'MySubscriptionsState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MySubscriptionsSuccessCopyWith<$Res> implements $MySubscriptionsStateCopyWith<$Res> {
  factory _$MySubscriptionsSuccessCopyWith(_MySubscriptionsSuccess value, $Res Function(_MySubscriptionsSuccess) _then) = __$MySubscriptionsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<MySubscriptionsModel> data
});




}
/// @nodoc
class __$MySubscriptionsSuccessCopyWithImpl<$Res>
    implements _$MySubscriptionsSuccessCopyWith<$Res> {
  __$MySubscriptionsSuccessCopyWithImpl(this._self, this._then);

  final _MySubscriptionsSuccess _self;
  final $Res Function(_MySubscriptionsSuccess) _then;

/// Create a copy of MySubscriptionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_MySubscriptionsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MySubscriptionsModel>,
  ));
}


}

// dart format on
