// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institutes_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstitutesEvent {

 RequestInstitutesModel? get params;
/// Create a copy of InstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitutesEventCopyWith<InstitutesEvent> get copyWith => _$InstitutesEventCopyWithImpl<InstitutesEvent>(this as InstitutesEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitutesEvent&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'InstitutesEvent(params: $params)';
}


}

/// @nodoc
abstract mixin class $InstitutesEventCopyWith<$Res>  {
  factory $InstitutesEventCopyWith(InstitutesEvent value, $Res Function(InstitutesEvent) _then) = _$InstitutesEventCopyWithImpl;
@useResult
$Res call({
 RequestInstitutesModel? params
});




}
/// @nodoc
class _$InstitutesEventCopyWithImpl<$Res>
    implements $InstitutesEventCopyWith<$Res> {
  _$InstitutesEventCopyWithImpl(this._self, this._then);

  final InstitutesEvent _self;
  final $Res Function(InstitutesEvent) _then;

/// Create a copy of InstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? params = freezed,}) {
  return _then(_self.copyWith(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstitutesModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitutesEvent].
extension InstitutesEventPatterns on InstitutesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnInstitutes value)?  institutes,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnInstitutes() when institutes != null:
return institutes(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnInstitutes value)  institutes,}){
final _that = this;
switch (_that) {
case _OnInstitutes():
return institutes(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnInstitutes value)?  institutes,}){
final _that = this;
switch (_that) {
case _OnInstitutes() when institutes != null:
return institutes(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequestInstitutesModel? params)?  institutes,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnInstitutes() when institutes != null:
return institutes(_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequestInstitutesModel? params)  institutes,}) {final _that = this;
switch (_that) {
case _OnInstitutes():
return institutes(_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequestInstitutesModel? params)?  institutes,}) {final _that = this;
switch (_that) {
case _OnInstitutes() when institutes != null:
return institutes(_that.params);case _:
  return null;

}
}

}

/// @nodoc


class _OnInstitutes implements InstitutesEvent {
  const _OnInstitutes({this.params});
  

@override final  RequestInstitutesModel? params;

/// Create a copy of InstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnInstitutesCopyWith<_OnInstitutes> get copyWith => __$OnInstitutesCopyWithImpl<_OnInstitutes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnInstitutes&&(identical(other.params, params) || other.params == params));
}


@override
int get hashCode => Object.hash(runtimeType,params);

@override
String toString() {
  return 'InstitutesEvent.institutes(params: $params)';
}


}

/// @nodoc
abstract mixin class _$OnInstitutesCopyWith<$Res> implements $InstitutesEventCopyWith<$Res> {
  factory _$OnInstitutesCopyWith(_OnInstitutes value, $Res Function(_OnInstitutes) _then) = __$OnInstitutesCopyWithImpl;
@override @useResult
$Res call({
 RequestInstitutesModel? params
});




}
/// @nodoc
class __$OnInstitutesCopyWithImpl<$Res>
    implements _$OnInstitutesCopyWith<$Res> {
  __$OnInstitutesCopyWithImpl(this._self, this._then);

  final _OnInstitutes _self;
  final $Res Function(_OnInstitutes) _then;

/// Create a copy of InstitutesEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? params = freezed,}) {
  return _then(_OnInstitutes(
params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as RequestInstitutesModel?,
  ));
}


}

/// @nodoc
mixin _$InstitutesState {

 bool get isLoading;
/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstitutesStateCopyWith<InstitutesState> get copyWith => _$InstitutesStateCopyWithImpl<InstitutesState>(this as InstitutesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstitutesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstitutesState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $InstitutesStateCopyWith<$Res>  {
  factory $InstitutesStateCopyWith(InstitutesState value, $Res Function(InstitutesState) _then) = _$InstitutesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$InstitutesStateCopyWithImpl<$Res>
    implements $InstitutesStateCopyWith<$Res> {
  _$InstitutesStateCopyWithImpl(this._self, this._then);

  final InstitutesState _self;
  final $Res Function(InstitutesState) _then;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InstitutesState].
extension InstitutesStatePatterns on InstitutesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InstitutesLoading value)?  loading,TResult Function( _InstitutesError value)?  error,TResult Function( _InstitutesSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstitutesLoading() when loading != null:
return loading(_that);case _InstitutesError() when error != null:
return error(_that);case _InstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InstitutesLoading value)  loading,required TResult Function( _InstitutesError value)  error,required TResult Function( _InstitutesSuccess value)  success,}){
final _that = this;
switch (_that) {
case _InstitutesLoading():
return loading(_that);case _InstitutesError():
return error(_that);case _InstitutesSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InstitutesLoading value)?  loading,TResult? Function( _InstitutesError value)?  error,TResult? Function( _InstitutesSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _InstitutesLoading() when loading != null:
return loading(_that);case _InstitutesError() when error != null:
return error(_that);case _InstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<InstitutesModel> data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstitutesLoading() when loading != null:
return loading(_that.isLoading);case _InstitutesError() when error != null:
return error(_that.isLoading,_that.message);case _InstitutesSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<InstitutesModel> data)  success,}) {final _that = this;
switch (_that) {
case _InstitutesLoading():
return loading(_that.isLoading);case _InstitutesError():
return error(_that.isLoading,_that.message);case _InstitutesSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<InstitutesModel> data)?  success,}) {final _that = this;
switch (_that) {
case _InstitutesLoading() when loading != null:
return loading(_that.isLoading);case _InstitutesError() when error != null:
return error(_that.isLoading,_that.message);case _InstitutesSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _InstitutesLoading implements InstitutesState {
  const _InstitutesLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitutesLoadingCopyWith<_InstitutesLoading> get copyWith => __$InstitutesLoadingCopyWithImpl<_InstitutesLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitutesLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'InstitutesState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$InstitutesLoadingCopyWith<$Res> implements $InstitutesStateCopyWith<$Res> {
  factory _$InstitutesLoadingCopyWith(_InstitutesLoading value, $Res Function(_InstitutesLoading) _then) = __$InstitutesLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$InstitutesLoadingCopyWithImpl<$Res>
    implements _$InstitutesLoadingCopyWith<$Res> {
  __$InstitutesLoadingCopyWithImpl(this._self, this._then);

  final _InstitutesLoading _self;
  final $Res Function(_InstitutesLoading) _then;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_InstitutesLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _InstitutesError implements InstitutesState {
  const _InstitutesError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitutesErrorCopyWith<_InstitutesError> get copyWith => __$InstitutesErrorCopyWithImpl<_InstitutesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitutesError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'InstitutesState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$InstitutesErrorCopyWith<$Res> implements $InstitutesStateCopyWith<$Res> {
  factory _$InstitutesErrorCopyWith(_InstitutesError value, $Res Function(_InstitutesError) _then) = __$InstitutesErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$InstitutesErrorCopyWithImpl<$Res>
    implements _$InstitutesErrorCopyWith<$Res> {
  __$InstitutesErrorCopyWithImpl(this._self, this._then);

  final _InstitutesError _self;
  final $Res Function(_InstitutesError) _then;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_InstitutesError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InstitutesSuccess implements InstitutesState {
  const _InstitutesSuccess(this.isLoading, final  List<InstitutesModel> data): _data = data;
  

@override final  bool isLoading;
 final  List<InstitutesModel> _data;
 List<InstitutesModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstitutesSuccessCopyWith<_InstitutesSuccess> get copyWith => __$InstitutesSuccessCopyWithImpl<_InstitutesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstitutesSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'InstitutesState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$InstitutesSuccessCopyWith<$Res> implements $InstitutesStateCopyWith<$Res> {
  factory _$InstitutesSuccessCopyWith(_InstitutesSuccess value, $Res Function(_InstitutesSuccess) _then) = __$InstitutesSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<InstitutesModel> data
});




}
/// @nodoc
class __$InstitutesSuccessCopyWithImpl<$Res>
    implements _$InstitutesSuccessCopyWith<$Res> {
  __$InstitutesSuccessCopyWithImpl(this._self, this._then);

  final _InstitutesSuccess _self;
  final $Res Function(_InstitutesSuccess) _then;

/// Create a copy of InstitutesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_InstitutesSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<InstitutesModel>,
  ));
}


}

// dart format on
