// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topics_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TopicsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TopicsEvent()';
}


}

/// @nodoc
class $TopicsEventCopyWith<$Res>  {
$TopicsEventCopyWith(TopicsEvent _, $Res Function(TopicsEvent) __);
}


/// Adds pattern-matching-related methods to [TopicsEvent].
extension TopicsEventPatterns on TopicsEvent {
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


class _OnLoad implements TopicsEvent {
  const _OnLoad();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TopicsEvent.load()';
}


}




/// @nodoc
mixin _$TopicsState {

 bool get isLoading;
/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicsStateCopyWith<TopicsState> get copyWith => _$TopicsStateCopyWithImpl<TopicsState>(this as TopicsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'TopicsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $TopicsStateCopyWith<$Res>  {
  factory $TopicsStateCopyWith(TopicsState value, $Res Function(TopicsState) _then) = _$TopicsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$TopicsStateCopyWithImpl<$Res>
    implements $TopicsStateCopyWith<$Res> {
  _$TopicsStateCopyWithImpl(this._self, this._then);

  final TopicsState _self;
  final $Res Function(TopicsState) _then;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicsState].
extension TopicsStatePatterns on TopicsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TopicsLoading value)?  loading,TResult Function( _TopicsError value)?  error,TResult Function( _TopicsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicsLoading() when loading != null:
return loading(_that);case _TopicsError() when error != null:
return error(_that);case _TopicsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TopicsLoading value)  loading,required TResult Function( _TopicsError value)  error,required TResult Function( _TopicsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _TopicsLoading():
return loading(_that);case _TopicsError():
return error(_that);case _TopicsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TopicsLoading value)?  loading,TResult? Function( _TopicsError value)?  error,TResult? Function( _TopicsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _TopicsLoading() when loading != null:
return loading(_that);case _TopicsError() when error != null:
return error(_that);case _TopicsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<DiscoveryTopicModel> items)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicsLoading() when loading != null:
return loading(_that.isLoading);case _TopicsError() when error != null:
return error(_that.isLoading,_that.message);case _TopicsSuccess() when success != null:
return success(_that.isLoading,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<DiscoveryTopicModel> items)  success,}) {final _that = this;
switch (_that) {
case _TopicsLoading():
return loading(_that.isLoading);case _TopicsError():
return error(_that.isLoading,_that.message);case _TopicsSuccess():
return success(_that.isLoading,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<DiscoveryTopicModel> items)?  success,}) {final _that = this;
switch (_that) {
case _TopicsLoading() when loading != null:
return loading(_that.isLoading);case _TopicsError() when error != null:
return error(_that.isLoading,_that.message);case _TopicsSuccess() when success != null:
return success(_that.isLoading,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _TopicsLoading implements TopicsState {
  const _TopicsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicsLoadingCopyWith<_TopicsLoading> get copyWith => __$TopicsLoadingCopyWithImpl<_TopicsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'TopicsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$TopicsLoadingCopyWith<$Res> implements $TopicsStateCopyWith<$Res> {
  factory _$TopicsLoadingCopyWith(_TopicsLoading value, $Res Function(_TopicsLoading) _then) = __$TopicsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$TopicsLoadingCopyWithImpl<$Res>
    implements _$TopicsLoadingCopyWith<$Res> {
  __$TopicsLoadingCopyWithImpl(this._self, this._then);

  final _TopicsLoading _self;
  final $Res Function(_TopicsLoading) _then;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_TopicsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _TopicsError implements TopicsState {
  const _TopicsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicsErrorCopyWith<_TopicsError> get copyWith => __$TopicsErrorCopyWithImpl<_TopicsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'TopicsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$TopicsErrorCopyWith<$Res> implements $TopicsStateCopyWith<$Res> {
  factory _$TopicsErrorCopyWith(_TopicsError value, $Res Function(_TopicsError) _then) = __$TopicsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$TopicsErrorCopyWithImpl<$Res>
    implements _$TopicsErrorCopyWith<$Res> {
  __$TopicsErrorCopyWithImpl(this._self, this._then);

  final _TopicsError _self;
  final $Res Function(_TopicsError) _then;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_TopicsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _TopicsSuccess implements TopicsState {
  const _TopicsSuccess(this.isLoading, final  List<DiscoveryTopicModel> items): _items = items;
  

@override final  bool isLoading;
 final  List<DiscoveryTopicModel> _items;
 List<DiscoveryTopicModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicsSuccessCopyWith<_TopicsSuccess> get copyWith => __$TopicsSuccessCopyWithImpl<_TopicsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TopicsState.success(isLoading: $isLoading, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TopicsSuccessCopyWith<$Res> implements $TopicsStateCopyWith<$Res> {
  factory _$TopicsSuccessCopyWith(_TopicsSuccess value, $Res Function(_TopicsSuccess) _then) = __$TopicsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<DiscoveryTopicModel> items
});




}
/// @nodoc
class __$TopicsSuccessCopyWithImpl<$Res>
    implements _$TopicsSuccessCopyWith<$Res> {
  __$TopicsSuccessCopyWithImpl(this._self, this._then);

  final _TopicsSuccess _self;
  final $Res Function(_TopicsSuccess) _then;

/// Create a copy of TopicsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? items = null,}) {
  return _then(_TopicsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DiscoveryTopicModel>,
  ));
}


}

// dart format on
