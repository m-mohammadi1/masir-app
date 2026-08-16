// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletEvent {

 RequestWalletModel? get params;
/// Create a copy of WalletEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletEventCopyWith<WalletEvent> get copyWith => _$WalletEventCopyWithImpl<WalletEvent>(this as WalletEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'WalletEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $WalletEventCopyWith<$Res>  {
  factory $WalletEventCopyWith(WalletEvent value, $Res Function(WalletEvent) _then) = _$WalletEventCopyWithImpl;
@useResult
$Res call({
 RequestWalletModel? params
});




}
/// @nodoc
class _$WalletEventCopyWithImpl<$Res>
    implements $WalletEventCopyWith<$Res> {
  _$WalletEventCopyWithImpl(this._self, this._then);

  final WalletEvent _self;
  final $Res Function(WalletEvent) _then;

/// Create a copy of WalletEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestWalletModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletEvent].
extension WalletEventPatterns on WalletEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnWallet value)?  wallet,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnWallet() when wallet != null:
return wallet(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnWallet value)  wallet,}){
final _that = this;
switch (_that) {
case _OnWallet():
return wallet(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnWallet value)?  wallet,}){
final _that = this;
switch (_that) {
case _OnWallet() when wallet != null:
return wallet(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestWalletModel? params)?  wallet,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnWallet() when wallet != null:
return wallet(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestWalletModel? params)  wallet,}) {final _that = this;
switch (_that) {
case _OnWallet():
return wallet(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestWalletModel? params)?  wallet,}) {final _that = this;
switch (_that) {
case _OnWallet() when wallet != null:
return wallet(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnWallet implements WalletEvent {
  const _OnWallet({this.params});
  

@override final  RequestWalletModel? params;

/// Create a copy of WalletEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnWalletCopyWith<_OnWallet> get copyWith => __$OnWalletCopyWithImpl<_OnWallet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnWallet&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'WalletEvent.wallet(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnWalletCopyWith<$Res> implements $WalletEventCopyWith<$Res> {
  factory _$OnWalletCopyWith(_OnWallet value, $Res Function(_OnWallet) _then) = __$OnWalletCopyWithImpl;
@override @useResult
$Res call({
 RequestWalletModel? params
});




}
/// @nodoc
class __$OnWalletCopyWithImpl<$Res>
    implements _$OnWalletCopyWith<$Res> {
  __$OnWalletCopyWithImpl(this._self, this._then);

  final _OnWallet _self;
  final $Res Function(_OnWallet) _then;

/// Create a copy of WalletEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnWallet(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestWalletModel?,
  ));
}


}

/// @nodoc
mixin _$WalletState {

 bool get isLoading;
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletStateCopyWith<WalletState> get copyWith => _$WalletStateCopyWithImpl<WalletState>(this as WalletState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'WalletState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $WalletStateCopyWith<$Res>  {
  factory $WalletStateCopyWith(WalletState value, $Res Function(WalletState) _then) = _$WalletStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$WalletStateCopyWithImpl<$Res>
    implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._self, this._then);

  final WalletState _self;
  final $Res Function(WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _WalletLoading value)?  loading,TResult Function( _WalletError value)?  error,TResult Function( _WalletSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletLoading() when loading != null:
return loading(_that);case _WalletError() when error != null:
return error(_that);case _WalletSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _WalletLoading value)  loading,required TResult Function( _WalletError value)  error,required TResult Function( _WalletSuccess value)  success,}){
final _that = this;
switch (_that) {
case _WalletLoading():
return loading(_that);case _WalletError():
return error(_that);case _WalletSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _WalletLoading value)?  loading,TResult? Function( _WalletError value)?  error,TResult? Function( _WalletSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _WalletLoading() when loading != null:
return loading(_that);case _WalletError() when error != null:
return error(_that);case _WalletSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<WalletCardModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletLoading() when loading != null:
return loading(_that.isLoading);case _WalletError() when error != null:
return error(_that.isLoading,_that.message);case _WalletSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<WalletCardModel> data)  success,}) {final _that = this;
switch (_that) {
case _WalletLoading():
return loading(_that.isLoading);case _WalletError():
return error(_that.isLoading,_that.message);case _WalletSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<WalletCardModel> data)?  success,}) {final _that = this;
switch (_that) {
case _WalletLoading() when loading != null:
return loading(_that.isLoading);case _WalletError() when error != null:
return error(_that.isLoading,_that.message);case _WalletSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _WalletLoading implements WalletState {
  const _WalletLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletLoadingCopyWith<_WalletLoading> get copyWith => __$WalletLoadingCopyWithImpl<_WalletLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'WalletState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$WalletLoadingCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletLoadingCopyWith(_WalletLoading value, $Res Function(_WalletLoading) _then) = __$WalletLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$WalletLoadingCopyWithImpl<$Res>
    implements _$WalletLoadingCopyWith<$Res> {
  __$WalletLoadingCopyWithImpl(this._self, this._then);

  final _WalletLoading _self;
  final $Res Function(_WalletLoading) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_WalletLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _WalletError implements WalletState {
  const _WalletError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletErrorCopyWith<_WalletError> get copyWith => __$WalletErrorCopyWithImpl<_WalletError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'WalletState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$WalletErrorCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletErrorCopyWith(_WalletError value, $Res Function(_WalletError) _then) = __$WalletErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$WalletErrorCopyWithImpl<$Res>
    implements _$WalletErrorCopyWith<$Res> {
  __$WalletErrorCopyWithImpl(this._self, this._then);

  final _WalletError _self;
  final $Res Function(_WalletError) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_WalletError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletSuccess implements WalletState {
  const _WalletSuccess(this.isLoading, final  List<WalletCardModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<WalletCardModel> _data;
 List<WalletCardModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletSuccessCopyWith<_WalletSuccess> get copyWith => __$WalletSuccessCopyWithImpl<_WalletSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'WalletState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletSuccessCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletSuccessCopyWith(_WalletSuccess value, $Res Function(_WalletSuccess) _then) = __$WalletSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<WalletCardModel> data
});




}
/// @nodoc
class __$WalletSuccessCopyWithImpl<$Res>
    implements _$WalletSuccessCopyWith<$Res> {
  __$WalletSuccessCopyWithImpl(this._self, this._then);

  final _WalletSuccess _self;
  final $Res Function(_WalletSuccess) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_WalletSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<WalletCardModel>,
  ));
}


}

// dart format on
