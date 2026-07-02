// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_institutes_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyInstitutesEvent {

 RequestMyInstitutesModel? get params;
/// Create a copy of MyInstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyInstitutesEventCopyWith<MyInstitutesEvent> get copyWith => _$MyInstitutesEventCopyWithImpl<MyInstitutesEvent>(this as MyInstitutesEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyInstitutesEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MyInstitutesEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $MyInstitutesEventCopyWith<$Res>  {
  factory $MyInstitutesEventCopyWith(MyInstitutesEvent value, $Res Function(MyInstitutesEvent) _then) = _$MyInstitutesEventCopyWithImpl;
@useResult
$Res call({
 RequestMyInstitutesModel? params
});




}
/// @nodoc
class _$MyInstitutesEventCopyWithImpl<$Res>
    implements $MyInstitutesEventCopyWith<$Res> {
  _$MyInstitutesEventCopyWithImpl(this._self, this._then);

  final MyInstitutesEvent _self;
  final $Res Function(MyInstitutesEvent) _then;

/// Create a copy of MyInstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMyInstitutesModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyInstitutesEvent].
extension MyInstitutesEventPatterns on MyInstitutesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnMyInstitutes value)?  myInstitutes,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnMyInstitutes() when myInstitutes != null:
return myInstitutes(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnMyInstitutes value)  myInstitutes,}){
final _that = this;
switch (_that) {
case _OnMyInstitutes():
return myInstitutes(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnMyInstitutes value)?  myInstitutes,}){
final _that = this;
switch (_that) {
case _OnMyInstitutes() when myInstitutes != null:
return myInstitutes(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestMyInstitutesModel? params)?  myInstitutes,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnMyInstitutes() when myInstitutes != null:
return myInstitutes(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestMyInstitutesModel? params)  myInstitutes,}) {final _that = this;
switch (_that) {
case _OnMyInstitutes():
return myInstitutes(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestMyInstitutesModel? params)?  myInstitutes,}) {final _that = this;
switch (_that) {
case _OnMyInstitutes() when myInstitutes != null:
return myInstitutes(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnMyInstitutes implements MyInstitutesEvent {
  const _OnMyInstitutes({this.params});
  

@override final  RequestMyInstitutesModel? params;

/// Create a copy of MyInstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnMyInstitutesCopyWith<_OnMyInstitutes> get copyWith => __$OnMyInstitutesCopyWithImpl<_OnMyInstitutes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMyInstitutes&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'MyInstitutesEvent.myInstitutes(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnMyInstitutesCopyWith<$Res> implements $MyInstitutesEventCopyWith<$Res> {
  factory _$OnMyInstitutesCopyWith(_OnMyInstitutes value, $Res Function(_OnMyInstitutes) _then) = __$OnMyInstitutesCopyWithImpl;
@override @useResult
$Res call({
 RequestMyInstitutesModel? params
});




}
/// @nodoc
class __$OnMyInstitutesCopyWithImpl<$Res>
    implements _$OnMyInstitutesCopyWith<$Res> {
  __$OnMyInstitutesCopyWithImpl(this._self, this._then);

  final _OnMyInstitutes _self;
  final $Res Function(_OnMyInstitutes) _then;

/// Create a copy of MyInstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnMyInstitutes(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestMyInstitutesModel?,
  ));
}


}

/// @nodoc
mixin _$MyInstitutesState {

 bool get isLoading;
/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyInstitutesStateCopyWith<MyInstitutesState> get copyWith => _$MyInstitutesStateCopyWithImpl<MyInstitutesState>(this as MyInstitutesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyInstitutesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MyInstitutesState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $MyInstitutesStateCopyWith<$Res>  {
  factory $MyInstitutesStateCopyWith(MyInstitutesState value, $Res Function(MyInstitutesState) _then) = _$MyInstitutesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$MyInstitutesStateCopyWithImpl<$Res>
    implements $MyInstitutesStateCopyWith<$Res> {
  _$MyInstitutesStateCopyWithImpl(this._self, this._then);

  final MyInstitutesState _self;
  final $Res Function(MyInstitutesState) _then;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MyInstitutesState].
extension MyInstitutesStatePatterns on MyInstitutesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _MyInstitutesLoading value)?  loading,TResult Function( _MyInstitutesError value)?  error,TResult Function( _MyInstitutesSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyInstitutesLoading() when loading != null:
return loading(_that);case _MyInstitutesError() when error != null:
return error(_that);case _MyInstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _MyInstitutesLoading value)  loading,required TResult Function( _MyInstitutesError value)  error,required TResult Function( _MyInstitutesSuccess value)  success,}){
final _that = this;
switch (_that) {
case _MyInstitutesLoading():
return loading(_that);case _MyInstitutesError():
return error(_that);case _MyInstitutesSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _MyInstitutesLoading value)?  loading,TResult? Function( _MyInstitutesError value)?  error,TResult? Function( _MyInstitutesSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _MyInstitutesLoading() when loading != null:
return loading(_that);case _MyInstitutesError() when error != null:
return error(_that);case _MyInstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<MyInstitutesModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyInstitutesLoading() when loading != null:
return loading(_that.isLoading);case _MyInstitutesError() when error != null:
return error(_that.isLoading,_that.message);case _MyInstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<MyInstitutesModel> data)  success,}) {final _that = this;
switch (_that) {
case _MyInstitutesLoading():
return loading(_that.isLoading);case _MyInstitutesError():
return error(_that.isLoading,_that.message);case _MyInstitutesSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<MyInstitutesModel> data)?  success,}) {final _that = this;
switch (_that) {
case _MyInstitutesLoading() when loading != null:
return loading(_that.isLoading);case _MyInstitutesError() when error != null:
return error(_that.isLoading,_that.message);case _MyInstitutesSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _MyInstitutesLoading implements MyInstitutesState {
  const _MyInstitutesLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyInstitutesLoadingCopyWith<_MyInstitutesLoading> get copyWith => __$MyInstitutesLoadingCopyWithImpl<_MyInstitutesLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyInstitutesLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MyInstitutesState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$MyInstitutesLoadingCopyWith<$Res> implements $MyInstitutesStateCopyWith<$Res> {
  factory _$MyInstitutesLoadingCopyWith(_MyInstitutesLoading value, $Res Function(_MyInstitutesLoading) _then) = __$MyInstitutesLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$MyInstitutesLoadingCopyWithImpl<$Res>
    implements _$MyInstitutesLoadingCopyWith<$Res> {
  __$MyInstitutesLoadingCopyWithImpl(this._self, this._then);

  final _MyInstitutesLoading _self;
  final $Res Function(_MyInstitutesLoading) _then;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_MyInstitutesLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _MyInstitutesError implements MyInstitutesState {
  const _MyInstitutesError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyInstitutesErrorCopyWith<_MyInstitutesError> get copyWith => __$MyInstitutesErrorCopyWithImpl<_MyInstitutesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyInstitutesError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'MyInstitutesState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MyInstitutesErrorCopyWith<$Res> implements $MyInstitutesStateCopyWith<$Res> {
  factory _$MyInstitutesErrorCopyWith(_MyInstitutesError value, $Res Function(_MyInstitutesError) _then) = __$MyInstitutesErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$MyInstitutesErrorCopyWithImpl<$Res>
    implements _$MyInstitutesErrorCopyWith<$Res> {
  __$MyInstitutesErrorCopyWithImpl(this._self, this._then);

  final _MyInstitutesError _self;
  final $Res Function(_MyInstitutesError) _then;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_MyInstitutesError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MyInstitutesSuccess implements MyInstitutesState {
  const _MyInstitutesSuccess(this.isLoading, final  List<MyInstitutesModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<MyInstitutesModel> _data;
 List<MyInstitutesModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyInstitutesSuccessCopyWith<_MyInstitutesSuccess> get copyWith => __$MyInstitutesSuccessCopyWithImpl<_MyInstitutesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyInstitutesSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'MyInstitutesState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MyInstitutesSuccessCopyWith<$Res> implements $MyInstitutesStateCopyWith<$Res> {
  factory _$MyInstitutesSuccessCopyWith(_MyInstitutesSuccess value, $Res Function(_MyInstitutesSuccess) _then) = __$MyInstitutesSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<MyInstitutesModel> data
});




}
/// @nodoc
class __$MyInstitutesSuccessCopyWithImpl<$Res>
    implements _$MyInstitutesSuccessCopyWith<$Res> {
  __$MyInstitutesSuccessCopyWithImpl(this._self, this._then);

  final _MyInstitutesSuccess _self;
  final $Res Function(_MyInstitutesSuccess) _then;

/// Create a copy of MyInstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_MyInstitutesSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MyInstitutesModel>,
  ));
}


}

// dart format on
