// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnnouncementDetailEvent {

 String get instituteId; String get announcementId;
/// Create a copy of AnnouncementDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementDetailEventCopyWith<AnnouncementDetailEvent> get copyWith => _$AnnouncementDetailEventCopyWithImpl<AnnouncementDetailEvent>(this as AnnouncementDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementDetailEvent&&(identical(other.instituteId, instituteId) || other.instituteId == instituteId)&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId));
}


@override
int get hashCode => Object.hash(runtimeType,instituteId,announcementId);

@override
String toString() {
  return 'AnnouncementDetailEvent(instituteId: $instituteId, announcementId: $announcementId)';
}


}

/// @nodoc
abstract mixin class $AnnouncementDetailEventCopyWith<$Res>  {
  factory $AnnouncementDetailEventCopyWith(AnnouncementDetailEvent value, $Res Function(AnnouncementDetailEvent) _then) = _$AnnouncementDetailEventCopyWithImpl;
@useResult
$Res call({
 String instituteId, String announcementId
});




}
/// @nodoc
class _$AnnouncementDetailEventCopyWithImpl<$Res>
    implements $AnnouncementDetailEventCopyWith<$Res> {
  _$AnnouncementDetailEventCopyWithImpl(this._self, this._then);

  final AnnouncementDetailEvent _self;
  final $Res Function(AnnouncementDetailEvent) _then;

/// Create a copy of AnnouncementDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instituteId = null,Object? announcementId = null,}) {
  return _then(_self.copyWith(
instituteId: null == instituteId ? _self.instituteId : instituteId // ignore: cast_nullable_to_non_nullable
as String,announcementId: null == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementDetailEvent].
extension AnnouncementDetailEventPatterns on AnnouncementDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnLoad value)?  load,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnLoad value)  load,}){
final _that = this;
switch (_that) {
case _OnLoad():
return load(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnLoad value)?  load,}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String instituteId,  String announcementId)?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.instituteId,_that.announcementId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String instituteId,  String announcementId)  load,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load(_that.instituteId,_that.announcementId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String instituteId,  String announcementId)?  load,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.instituteId,_that.announcementId);case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements AnnouncementDetailEvent {
  const _OnLoad({required this.instituteId, required this.announcementId});
  

@override final  String instituteId;
@override final  String announcementId;

/// Create a copy of AnnouncementDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnLoadCopyWith<_OnLoad> get copyWith => __$OnLoadCopyWithImpl<_OnLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad&&(identical(other.instituteId, instituteId) || other.instituteId == instituteId)&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId));
}


@override
int get hashCode => Object.hash(runtimeType,instituteId,announcementId);

@override
String toString() {
  return 'AnnouncementDetailEvent.load(instituteId: $instituteId, announcementId: $announcementId)';
}


}

/// @nodoc
abstract mixin class _$OnLoadCopyWith<$Res> implements $AnnouncementDetailEventCopyWith<$Res> {
  factory _$OnLoadCopyWith(_OnLoad value, $Res Function(_OnLoad) _then) = __$OnLoadCopyWithImpl;
@override @useResult
$Res call({
 String instituteId, String announcementId
});




}
/// @nodoc
class __$OnLoadCopyWithImpl<$Res>
    implements _$OnLoadCopyWith<$Res> {
  __$OnLoadCopyWithImpl(this._self, this._then);

  final _OnLoad _self;
  final $Res Function(_OnLoad) _then;

/// Create a copy of AnnouncementDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instituteId = null,Object? announcementId = null,}) {
  return _then(_OnLoad(
instituteId: null == instituteId ? _self.instituteId : instituteId // ignore: cast_nullable_to_non_nullable
as String,announcementId: null == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AnnouncementDetailState {

 bool get isLoading;
/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementDetailStateCopyWith<AnnouncementDetailState> get copyWith => _$AnnouncementDetailStateCopyWithImpl<AnnouncementDetailState>(this as AnnouncementDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AnnouncementDetailState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AnnouncementDetailStateCopyWith<$Res>  {
  factory $AnnouncementDetailStateCopyWith(AnnouncementDetailState value, $Res Function(AnnouncementDetailState) _then) = _$AnnouncementDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$AnnouncementDetailStateCopyWithImpl<$Res>
    implements $AnnouncementDetailStateCopyWith<$Res> {
  _$AnnouncementDetailStateCopyWithImpl(this._self, this._then);

  final AnnouncementDetailState _self;
  final $Res Function(AnnouncementDetailState) _then;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementDetailState].
extension AnnouncementDetailStatePatterns on AnnouncementDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AnnouncementDetailLoading value)?  loading,TResult Function( _AnnouncementDetailError value)?  error,TResult Function( _AnnouncementDetailSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementDetailLoading() when loading != null:
return loading(_that);case _AnnouncementDetailError() when error != null:
return error(_that);case _AnnouncementDetailSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AnnouncementDetailLoading value)  loading,required TResult Function( _AnnouncementDetailError value)  error,required TResult Function( _AnnouncementDetailSuccess value)  success,}){
final _that = this;
switch (_that) {
case _AnnouncementDetailLoading():
return loading(_that);case _AnnouncementDetailError():
return error(_that);case _AnnouncementDetailSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AnnouncementDetailLoading value)?  loading,TResult? Function( _AnnouncementDetailError value)?  error,TResult? Function( _AnnouncementDetailSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _AnnouncementDetailLoading() when loading != null:
return loading(_that);case _AnnouncementDetailError() when error != null:
return error(_that);case _AnnouncementDetailSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  AnnouncementModel data)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementDetailLoading() when loading != null:
return loading(_that.isLoading);case _AnnouncementDetailError() when error != null:
return error(_that.isLoading,_that.message);case _AnnouncementDetailSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  AnnouncementModel data)  success,}) {final _that = this;
switch (_that) {
case _AnnouncementDetailLoading():
return loading(_that.isLoading);case _AnnouncementDetailError():
return error(_that.isLoading,_that.message);case _AnnouncementDetailSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  AnnouncementModel data)?  success,}) {final _that = this;
switch (_that) {
case _AnnouncementDetailLoading() when loading != null:
return loading(_that.isLoading);case _AnnouncementDetailError() when error != null:
return error(_that.isLoading,_that.message);case _AnnouncementDetailSuccess() when success != null:
return success(_that.isLoading,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _AnnouncementDetailLoading implements AnnouncementDetailState {
  const _AnnouncementDetailLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementDetailLoadingCopyWith<_AnnouncementDetailLoading> get copyWith => __$AnnouncementDetailLoadingCopyWithImpl<_AnnouncementDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementDetailLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AnnouncementDetailState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementDetailLoadingCopyWith<$Res> implements $AnnouncementDetailStateCopyWith<$Res> {
  factory _$AnnouncementDetailLoadingCopyWith(_AnnouncementDetailLoading value, $Res Function(_AnnouncementDetailLoading) _then) = __$AnnouncementDetailLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$AnnouncementDetailLoadingCopyWithImpl<$Res>
    implements _$AnnouncementDetailLoadingCopyWith<$Res> {
  __$AnnouncementDetailLoadingCopyWithImpl(this._self, this._then);

  final _AnnouncementDetailLoading _self;
  final $Res Function(_AnnouncementDetailLoading) _then;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_AnnouncementDetailLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AnnouncementDetailError implements AnnouncementDetailState {
  const _AnnouncementDetailError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementDetailErrorCopyWith<_AnnouncementDetailError> get copyWith => __$AnnouncementDetailErrorCopyWithImpl<_AnnouncementDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementDetailError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'AnnouncementDetailState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementDetailErrorCopyWith<$Res> implements $AnnouncementDetailStateCopyWith<$Res> {
  factory _$AnnouncementDetailErrorCopyWith(_AnnouncementDetailError value, $Res Function(_AnnouncementDetailError) _then) = __$AnnouncementDetailErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$AnnouncementDetailErrorCopyWithImpl<$Res>
    implements _$AnnouncementDetailErrorCopyWith<$Res> {
  __$AnnouncementDetailErrorCopyWithImpl(this._self, this._then);

  final _AnnouncementDetailError _self;
  final $Res Function(_AnnouncementDetailError) _then;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_AnnouncementDetailError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AnnouncementDetailSuccess implements AnnouncementDetailState {
  const _AnnouncementDetailSuccess(this.isLoading, this.data);
  

@override final  bool isLoading;
 final  AnnouncementModel data;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementDetailSuccessCopyWith<_AnnouncementDetailSuccess> get copyWith => __$AnnouncementDetailSuccessCopyWithImpl<_AnnouncementDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementDetailSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data);

@override
String toString() {
  return 'AnnouncementDetailState.success(isLoading: $isLoading, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementDetailSuccessCopyWith<$Res> implements $AnnouncementDetailStateCopyWith<$Res> {
  factory _$AnnouncementDetailSuccessCopyWith(_AnnouncementDetailSuccess value, $Res Function(_AnnouncementDetailSuccess) _then) = __$AnnouncementDetailSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, AnnouncementModel data
});




}
/// @nodoc
class __$AnnouncementDetailSuccessCopyWithImpl<$Res>
    implements _$AnnouncementDetailSuccessCopyWith<$Res> {
  __$AnnouncementDetailSuccessCopyWithImpl(this._self, this._then);

  final _AnnouncementDetailSuccess _self;
  final $Res Function(_AnnouncementDetailSuccess) _then;

/// Create a copy of AnnouncementDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,}) {
  return _then(_AnnouncementDetailSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AnnouncementModel,
  ));
}


}

// dart format on
