// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainFeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MainFeedEvent()';
}


}

/// @nodoc
class $MainFeedEventCopyWith<$Res>  {
$MainFeedEventCopyWith(MainFeedEvent _, $Res Function(MainFeedEvent) __);
}


/// Adds pattern-matching-related methods to [MainFeedEvent].
extension MainFeedEventPatterns on MainFeedEvent {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load();case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements MainFeedEvent {
  const _OnLoad();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MainFeedEvent.load()';
}


}




/// @nodoc
mixin _$MainFeedState {

 bool get isLoading;
/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainFeedStateCopyWith<MainFeedState> get copyWith => _$MainFeedStateCopyWithImpl<MainFeedState>(this as MainFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainFeedState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MainFeedState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $MainFeedStateCopyWith<$Res>  {
  factory $MainFeedStateCopyWith(MainFeedState value, $Res Function(MainFeedState) _then) = _$MainFeedStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$MainFeedStateCopyWithImpl<$Res>
    implements $MainFeedStateCopyWith<$Res> {
  _$MainFeedStateCopyWithImpl(this._self, this._then);

  final MainFeedState _self;
  final $Res Function(MainFeedState) _then;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MainFeedState].
extension MainFeedStatePatterns on MainFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _MainFeedLoading value)?  loading,TResult Function( _MainFeedError value)?  error,TResult Function( _MainFeedSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainFeedLoading() when loading != null:
return loading(_that);case _MainFeedError() when error != null:
return error(_that);case _MainFeedSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _MainFeedLoading value)  loading,required TResult Function( _MainFeedError value)  error,required TResult Function( _MainFeedSuccess value)  success,}){
final _that = this;
switch (_that) {
case _MainFeedLoading():
return loading(_that);case _MainFeedError():
return error(_that);case _MainFeedSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _MainFeedLoading value)?  loading,TResult? Function( _MainFeedError value)?  error,TResult? Function( _MainFeedSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _MainFeedLoading() when loading != null:
return loading(_that);case _MainFeedError() when error != null:
return error(_that);case _MainFeedSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<MainFeedSectionEntity> sections)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainFeedLoading() when loading != null:
return loading(_that.isLoading);case _MainFeedError() when error != null:
return error(_that.isLoading,_that.message);case _MainFeedSuccess() when success != null:
return success(_that.isLoading,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<MainFeedSectionEntity> sections)  success,}) {final _that = this;
switch (_that) {
case _MainFeedLoading():
return loading(_that.isLoading);case _MainFeedError():
return error(_that.isLoading,_that.message);case _MainFeedSuccess():
return success(_that.isLoading,_that.sections);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<MainFeedSectionEntity> sections)?  success,}) {final _that = this;
switch (_that) {
case _MainFeedLoading() when loading != null:
return loading(_that.isLoading);case _MainFeedError() when error != null:
return error(_that.isLoading,_that.message);case _MainFeedSuccess() when success != null:
return success(_that.isLoading,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _MainFeedLoading implements MainFeedState {
  const _MainFeedLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainFeedLoadingCopyWith<_MainFeedLoading> get copyWith => __$MainFeedLoadingCopyWithImpl<_MainFeedLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainFeedLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'MainFeedState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$MainFeedLoadingCopyWith<$Res> implements $MainFeedStateCopyWith<$Res> {
  factory _$MainFeedLoadingCopyWith(_MainFeedLoading value, $Res Function(_MainFeedLoading) _then) = __$MainFeedLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$MainFeedLoadingCopyWithImpl<$Res>
    implements _$MainFeedLoadingCopyWith<$Res> {
  __$MainFeedLoadingCopyWithImpl(this._self, this._then);

  final _MainFeedLoading _self;
  final $Res Function(_MainFeedLoading) _then;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_MainFeedLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _MainFeedError implements MainFeedState {
  const _MainFeedError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainFeedErrorCopyWith<_MainFeedError> get copyWith => __$MainFeedErrorCopyWithImpl<_MainFeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainFeedError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'MainFeedState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MainFeedErrorCopyWith<$Res> implements $MainFeedStateCopyWith<$Res> {
  factory _$MainFeedErrorCopyWith(_MainFeedError value, $Res Function(_MainFeedError) _then) = __$MainFeedErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$MainFeedErrorCopyWithImpl<$Res>
    implements _$MainFeedErrorCopyWith<$Res> {
  __$MainFeedErrorCopyWithImpl(this._self, this._then);

  final _MainFeedError _self;
  final $Res Function(_MainFeedError) _then;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_MainFeedError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MainFeedSuccess implements MainFeedState {
  const _MainFeedSuccess(this.isLoading, final  List<MainFeedSectionEntity> sections): _sections = sections;
  

@override final  bool isLoading;
 final  List<MainFeedSectionEntity> _sections;
 List<MainFeedSectionEntity> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainFeedSuccessCopyWith<_MainFeedSuccess> get copyWith => __$MainFeedSuccessCopyWithImpl<_MainFeedSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainFeedSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'MainFeedState.success(isLoading: $isLoading, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$MainFeedSuccessCopyWith<$Res> implements $MainFeedStateCopyWith<$Res> {
  factory _$MainFeedSuccessCopyWith(_MainFeedSuccess value, $Res Function(_MainFeedSuccess) _then) = __$MainFeedSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<MainFeedSectionEntity> sections
});




}
/// @nodoc
class __$MainFeedSuccessCopyWithImpl<$Res>
    implements _$MainFeedSuccessCopyWith<$Res> {
  __$MainFeedSuccessCopyWithImpl(this._self, this._then);

  final _MainFeedSuccess _self;
  final $Res Function(_MainFeedSuccess) _then;

/// Create a copy of MainFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? sections = null,}) {
  return _then(_MainFeedSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<MainFeedSectionEntity>,
  ));
}


}

// dart format on
