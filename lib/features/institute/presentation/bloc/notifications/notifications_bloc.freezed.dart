// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent()';
}


}

/// @nodoc
class $NotificationsEventCopyWith<$Res>  {
$NotificationsEventCopyWith(NotificationsEvent _, $Res Function(NotificationsEvent) __);
}


/// Adds pattern-matching-related methods to [NotificationsEvent].
extension NotificationsEventPatterns on NotificationsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnLoad value)?  load,TResult Function( _OnLoadMore value)?  loadMore,TResult Function( _OnMarkRead value)?  markRead,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnLoadMore() when loadMore != null:
return loadMore(_that);case _OnMarkRead() when markRead != null:
return markRead(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnLoad value)  load,required TResult Function( _OnLoadMore value)  loadMore,required TResult Function( _OnMarkRead value)  markRead,}){
final _that = this;
switch (_that) {
case _OnLoad():
return load(_that);case _OnLoadMore():
return loadMore(_that);case _OnMarkRead():
return markRead(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnLoad value)?  load,TResult? Function( _OnLoadMore value)?  loadMore,TResult? Function( _OnMarkRead value)?  markRead,}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnLoadMore() when loadMore != null:
return loadMore(_that);case _OnMarkRead() when markRead != null:
return markRead(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  loadMore,TResult Function( String id)?  markRead,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load();case _OnLoadMore() when loadMore != null:
return loadMore();case _OnMarkRead() when markRead != null:
return markRead(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  loadMore,required TResult Function( String id)  markRead,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load();case _OnLoadMore():
return loadMore();case _OnMarkRead():
return markRead(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  loadMore,TResult? Function( String id)?  markRead,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load();case _OnLoadMore() when loadMore != null:
return loadMore();case _OnMarkRead() when markRead != null:
return markRead(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements NotificationsEvent {
  const _OnLoad();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent.load()';
}


}




/// @nodoc


class _OnLoadMore implements NotificationsEvent {
  const _OnLoadMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoadMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent.loadMore()';
}


}




/// @nodoc


class _OnMarkRead implements NotificationsEvent {
  const _OnMarkRead(this.id);
  

 final  String id;

/// Create a copy of NotificationsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnMarkReadCopyWith<_OnMarkRead> get copyWith => __$OnMarkReadCopyWithImpl<_OnMarkRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMarkRead&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'NotificationsEvent.markRead(id: $id)';
}


}

/// @nodoc
abstract mixin class _$OnMarkReadCopyWith<$Res> implements $NotificationsEventCopyWith<$Res> {
  factory _$OnMarkReadCopyWith(_OnMarkRead value, $Res Function(_OnMarkRead) _then) = __$OnMarkReadCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$OnMarkReadCopyWithImpl<$Res>
    implements _$OnMarkReadCopyWith<$Res> {
  __$OnMarkReadCopyWithImpl(this._self, this._then);

  final _OnMarkRead _self;
  final $Res Function(_OnMarkRead) _then;

/// Create a copy of NotificationsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_OnMarkRead(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$NotificationsState {

 bool get isLoading;
/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsStateCopyWith<NotificationsState> get copyWith => _$NotificationsStateCopyWithImpl<NotificationsState>(this as NotificationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'NotificationsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $NotificationsStateCopyWith<$Res>  {
  factory $NotificationsStateCopyWith(NotificationsState value, $Res Function(NotificationsState) _then) = _$NotificationsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._self, this._then);

  final NotificationsState _self;
  final $Res Function(NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NotificationsLoading value)?  loading,TResult Function( _NotificationsError value)?  error,TResult Function( _NotificationsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsLoading() when loading != null:
return loading(_that);case _NotificationsError() when error != null:
return error(_that);case _NotificationsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NotificationsLoading value)  loading,required TResult Function( _NotificationsError value)  error,required TResult Function( _NotificationsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _NotificationsLoading():
return loading(_that);case _NotificationsError():
return error(_that);case _NotificationsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NotificationsLoading value)?  loading,TResult? Function( _NotificationsError value)?  error,TResult? Function( _NotificationsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _NotificationsLoading() when loading != null:
return loading(_that);case _NotificationsError() when error != null:
return error(_that);case _NotificationsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<AppNotificationModel> items,  bool hasMore,  bool loadingMore)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsLoading() when loading != null:
return loading(_that.isLoading);case _NotificationsError() when error != null:
return error(_that.isLoading,_that.message);case _NotificationsSuccess() when success != null:
return success(_that.isLoading,_that.items,_that.hasMore,_that.loadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<AppNotificationModel> items,  bool hasMore,  bool loadingMore)  success,}) {final _that = this;
switch (_that) {
case _NotificationsLoading():
return loading(_that.isLoading);case _NotificationsError():
return error(_that.isLoading,_that.message);case _NotificationsSuccess():
return success(_that.isLoading,_that.items,_that.hasMore,_that.loadingMore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<AppNotificationModel> items,  bool hasMore,  bool loadingMore)?  success,}) {final _that = this;
switch (_that) {
case _NotificationsLoading() when loading != null:
return loading(_that.isLoading);case _NotificationsError() when error != null:
return error(_that.isLoading,_that.message);case _NotificationsSuccess() when success != null:
return success(_that.isLoading,_that.items,_that.hasMore,_that.loadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsLoading implements NotificationsState {
  const _NotificationsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsLoadingCopyWith<_NotificationsLoading> get copyWith => __$NotificationsLoadingCopyWithImpl<_NotificationsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'NotificationsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$NotificationsLoadingCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsLoadingCopyWith(_NotificationsLoading value, $Res Function(_NotificationsLoading) _then) = __$NotificationsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$NotificationsLoadingCopyWithImpl<$Res>
    implements _$NotificationsLoadingCopyWith<$Res> {
  __$NotificationsLoadingCopyWithImpl(this._self, this._then);

  final _NotificationsLoading _self;
  final $Res Function(_NotificationsLoading) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_NotificationsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _NotificationsError implements NotificationsState {
  const _NotificationsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsErrorCopyWith<_NotificationsError> get copyWith => __$NotificationsErrorCopyWithImpl<_NotificationsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'NotificationsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotificationsErrorCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsErrorCopyWith(_NotificationsError value, $Res Function(_NotificationsError) _then) = __$NotificationsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$NotificationsErrorCopyWithImpl<$Res>
    implements _$NotificationsErrorCopyWith<$Res> {
  __$NotificationsErrorCopyWithImpl(this._self, this._then);

  final _NotificationsError _self;
  final $Res Function(_NotificationsError) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_NotificationsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NotificationsSuccess implements NotificationsState {
  const _NotificationsSuccess(this.isLoading, final  List<AppNotificationModel> items, this.hasMore, this.loadingMore): _items = items;
  

@override final  bool isLoading;
 final  List<AppNotificationModel> _items;
 List<AppNotificationModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasMore;
 final  bool loadingMore;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsSuccessCopyWith<_NotificationsSuccess> get copyWith => __$NotificationsSuccessCopyWithImpl<_NotificationsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_items),hasMore,loadingMore);

@override
String toString() {
  return 'NotificationsState.success(isLoading: $isLoading, items: $items, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class _$NotificationsSuccessCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsSuccessCopyWith(_NotificationsSuccess value, $Res Function(_NotificationsSuccess) _then) = __$NotificationsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<AppNotificationModel> items, bool hasMore, bool loadingMore
});




}
/// @nodoc
class __$NotificationsSuccessCopyWithImpl<$Res>
    implements _$NotificationsSuccessCopyWith<$Res> {
  __$NotificationsSuccessCopyWithImpl(this._self, this._then);

  final _NotificationsSuccess _self;
  final $Res Function(_NotificationsSuccess) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? items = null,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(_NotificationsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AppNotificationModel>,null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
