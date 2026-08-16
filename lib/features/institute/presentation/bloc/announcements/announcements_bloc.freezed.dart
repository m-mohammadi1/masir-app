// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnnouncementsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnnouncementsEvent()';
}


}

/// @nodoc
class $AnnouncementsEventCopyWith<$Res>  {
$AnnouncementsEventCopyWith(AnnouncementsEvent _, $Res Function(AnnouncementsEvent) __);
}


/// Adds pattern-matching-related methods to [AnnouncementsEvent].
extension AnnouncementsEventPatterns on AnnouncementsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OnLoad value)?  load,TResult Function( _OnLoadMore value)?  loadMore,TResult Function( _OnMarkLocalRead value)?  markLocalRead,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnLoadMore() when loadMore != null:
return loadMore(_that);case _OnMarkLocalRead() when markLocalRead != null:
return markLocalRead(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OnLoad value)  load,required TResult Function( _OnLoadMore value)  loadMore,required TResult Function( _OnMarkLocalRead value)  markLocalRead,}){
final _that = this;
switch (_that) {
case _OnLoad():
return load(_that);case _OnLoadMore():
return loadMore(_that);case _OnMarkLocalRead():
return markLocalRead(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OnLoad value)?  load,TResult? Function( _OnLoadMore value)?  loadMore,TResult? Function( _OnMarkLocalRead value)?  markLocalRead,}){
final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that);case _OnLoadMore() when loadMore != null:
return loadMore(_that);case _OnMarkLocalRead() when markLocalRead != null:
return markLocalRead(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String instituteId,  int? perPage)?  load,TResult Function()?  loadMore,TResult Function( String announcementId)?  markLocalRead,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.instituteId,_that.perPage);case _OnLoadMore() when loadMore != null:
return loadMore();case _OnMarkLocalRead() when markLocalRead != null:
return markLocalRead(_that.announcementId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String instituteId,  int? perPage)  load,required TResult Function()  loadMore,required TResult Function( String announcementId)  markLocalRead,}) {final _that = this;
switch (_that) {
case _OnLoad():
return load(_that.instituteId,_that.perPage);case _OnLoadMore():
return loadMore();case _OnMarkLocalRead():
return markLocalRead(_that.announcementId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String instituteId,  int? perPage)?  load,TResult? Function()?  loadMore,TResult? Function( String announcementId)?  markLocalRead,}) {final _that = this;
switch (_that) {
case _OnLoad() when load != null:
return load(_that.instituteId,_that.perPage);case _OnLoadMore() when loadMore != null:
return loadMore();case _OnMarkLocalRead() when markLocalRead != null:
return markLocalRead(_that.announcementId);case _:
  return null;

}
}

}

/// @nodoc


class _OnLoad implements AnnouncementsEvent {
  const _OnLoad({required this.instituteId, this.perPage});
  

 final  String instituteId;
 final  int? perPage;

/// Create a copy of AnnouncementsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnLoadCopyWith<_OnLoad> get copyWith => __$OnLoadCopyWithImpl<_OnLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoad&&(identical(other.instituteId, instituteId) || other.instituteId == instituteId)&&(identical(other.perPage, perPage) || other.perPage == perPage));
}


@override
int get hashCode => Object.hash(runtimeType,instituteId,perPage);

@override
String toString() {
  return 'AnnouncementsEvent.load(instituteId: $instituteId, perPage: $perPage)';
}


}

/// @nodoc
abstract mixin class _$OnLoadCopyWith<$Res> implements $AnnouncementsEventCopyWith<$Res> {
  factory _$OnLoadCopyWith(_OnLoad value, $Res Function(_OnLoad) _then) = __$OnLoadCopyWithImpl;
@useResult
$Res call({
 String instituteId, int? perPage
});




}
/// @nodoc
class __$OnLoadCopyWithImpl<$Res>
    implements _$OnLoadCopyWith<$Res> {
  __$OnLoadCopyWithImpl(this._self, this._then);

  final _OnLoad _self;
  final $Res Function(_OnLoad) _then;

/// Create a copy of AnnouncementsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? instituteId = null,Object? perPage = freezed,}) {
  return _then(_OnLoad(
instituteId: null == instituteId ? _self.instituteId : instituteId // ignore: cast_nullable_to_non_nullable
as String,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _OnLoadMore implements AnnouncementsEvent {
  const _OnLoadMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnLoadMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnnouncementsEvent.loadMore()';
}


}




/// @nodoc


class _OnMarkLocalRead implements AnnouncementsEvent {
  const _OnMarkLocalRead(this.announcementId);
  

 final  String announcementId;

/// Create a copy of AnnouncementsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnMarkLocalReadCopyWith<_OnMarkLocalRead> get copyWith => __$OnMarkLocalReadCopyWithImpl<_OnMarkLocalRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnMarkLocalRead&&(identical(other.announcementId, announcementId) || other.announcementId == announcementId));
}


@override
int get hashCode => Object.hash(runtimeType,announcementId);

@override
String toString() {
  return 'AnnouncementsEvent.markLocalRead(announcementId: $announcementId)';
}


}

/// @nodoc
abstract mixin class _$OnMarkLocalReadCopyWith<$Res> implements $AnnouncementsEventCopyWith<$Res> {
  factory _$OnMarkLocalReadCopyWith(_OnMarkLocalRead value, $Res Function(_OnMarkLocalRead) _then) = __$OnMarkLocalReadCopyWithImpl;
@useResult
$Res call({
 String announcementId
});




}
/// @nodoc
class __$OnMarkLocalReadCopyWithImpl<$Res>
    implements _$OnMarkLocalReadCopyWith<$Res> {
  __$OnMarkLocalReadCopyWithImpl(this._self, this._then);

  final _OnMarkLocalRead _self;
  final $Res Function(_OnMarkLocalRead) _then;

/// Create a copy of AnnouncementsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? announcementId = null,}) {
  return _then(_OnMarkLocalRead(
null == announcementId ? _self.announcementId : announcementId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AnnouncementsState {

 bool get isLoading;
/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementsStateCopyWith<AnnouncementsState> get copyWith => _$AnnouncementsStateCopyWithImpl<AnnouncementsState>(this as AnnouncementsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AnnouncementsState(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AnnouncementsStateCopyWith<$Res>  {
  factory $AnnouncementsStateCopyWith(AnnouncementsState value, $Res Function(AnnouncementsState) _then) = _$AnnouncementsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$AnnouncementsStateCopyWithImpl<$Res>
    implements $AnnouncementsStateCopyWith<$Res> {
  _$AnnouncementsStateCopyWithImpl(this._self, this._then);

  final AnnouncementsState _self;
  final $Res Function(AnnouncementsState) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementsState].
extension AnnouncementsStatePatterns on AnnouncementsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AnnouncementsLoading value)?  loading,TResult Function( _AnnouncementsError value)?  error,TResult Function( _AnnouncementsSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementsLoading() when loading != null:
return loading(_that);case _AnnouncementsError() when error != null:
return error(_that);case _AnnouncementsSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AnnouncementsLoading value)  loading,required TResult Function( _AnnouncementsError value)  error,required TResult Function( _AnnouncementsSuccess value)  success,}){
final _that = this;
switch (_that) {
case _AnnouncementsLoading():
return loading(_that);case _AnnouncementsError():
return error(_that);case _AnnouncementsSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AnnouncementsLoading value)?  loading,TResult? Function( _AnnouncementsError value)?  error,TResult? Function( _AnnouncementsSuccess value)?  success,}){
final _that = this;
switch (_that) {
case _AnnouncementsLoading() when loading != null:
return loading(_that);case _AnnouncementsError() when error != null:
return error(_that);case _AnnouncementsSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading)?  loading,TResult Function( bool isLoading,  String message)?  error,TResult Function( bool isLoading,  List<AnnouncementModel> items,  bool hasMore,  bool loadingMore)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementsLoading() when loading != null:
return loading(_that.isLoading);case _AnnouncementsError() when error != null:
return error(_that.isLoading,_that.message);case _AnnouncementsSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading)  loading,required TResult Function( bool isLoading,  String message)  error,required TResult Function( bool isLoading,  List<AnnouncementModel> items,  bool hasMore,  bool loadingMore)  success,}) {final _that = this;
switch (_that) {
case _AnnouncementsLoading():
return loading(_that.isLoading);case _AnnouncementsError():
return error(_that.isLoading,_that.message);case _AnnouncementsSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading)?  loading,TResult? Function( bool isLoading,  String message)?  error,TResult? Function( bool isLoading,  List<AnnouncementModel> items,  bool hasMore,  bool loadingMore)?  success,}) {final _that = this;
switch (_that) {
case _AnnouncementsLoading() when loading != null:
return loading(_that.isLoading);case _AnnouncementsError() when error != null:
return error(_that.isLoading,_that.message);case _AnnouncementsSuccess() when success != null:
return success(_that.isLoading,_that.items,_that.hasMore,_that.loadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _AnnouncementsLoading implements AnnouncementsState {
  const _AnnouncementsLoading(this.isLoading);
  

@override final  bool isLoading;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementsLoadingCopyWith<_AnnouncementsLoading> get copyWith => __$AnnouncementsLoadingCopyWithImpl<_AnnouncementsLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementsLoading&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'AnnouncementsState.loading(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementsLoadingCopyWith<$Res> implements $AnnouncementsStateCopyWith<$Res> {
  factory _$AnnouncementsLoadingCopyWith(_AnnouncementsLoading value, $Res Function(_AnnouncementsLoading) _then) = __$AnnouncementsLoadingCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$AnnouncementsLoadingCopyWithImpl<$Res>
    implements _$AnnouncementsLoadingCopyWith<$Res> {
  __$AnnouncementsLoadingCopyWithImpl(this._self, this._then);

  final _AnnouncementsLoading _self;
  final $Res Function(_AnnouncementsLoading) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_AnnouncementsLoading(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AnnouncementsError implements AnnouncementsState {
  const _AnnouncementsError(this.isLoading, this.message);
  

@override final  bool isLoading;
 final  String message;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementsErrorCopyWith<_AnnouncementsError> get copyWith => __$AnnouncementsErrorCopyWithImpl<_AnnouncementsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementsError&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,message);

@override
String toString() {
  return 'AnnouncementsState.error(isLoading: $isLoading, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementsErrorCopyWith<$Res> implements $AnnouncementsStateCopyWith<$Res> {
  factory _$AnnouncementsErrorCopyWith(_AnnouncementsError value, $Res Function(_AnnouncementsError) _then) = __$AnnouncementsErrorCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String message
});




}
/// @nodoc
class __$AnnouncementsErrorCopyWithImpl<$Res>
    implements _$AnnouncementsErrorCopyWith<$Res> {
  __$AnnouncementsErrorCopyWithImpl(this._self, this._then);

  final _AnnouncementsError _self;
  final $Res Function(_AnnouncementsError) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? message = null,}) {
  return _then(_AnnouncementsError(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AnnouncementsSuccess implements AnnouncementsState {
  const _AnnouncementsSuccess(this.isLoading, final  List<AnnouncementModel> items, this.hasMore, this.loadingMore): _items = items;
  

@override final  bool isLoading;
 final  List<AnnouncementModel> _items;
 List<AnnouncementModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasMore;
 final  bool loadingMore;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementsSuccessCopyWith<_AnnouncementsSuccess> get copyWith => __$AnnouncementsSuccessCopyWithImpl<_AnnouncementsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementsSuccess&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_items),hasMore,loadingMore);

@override
String toString() {
  return 'AnnouncementsState.success(isLoading: $isLoading, items: $items, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementsSuccessCopyWith<$Res> implements $AnnouncementsStateCopyWith<$Res> {
  factory _$AnnouncementsSuccessCopyWith(_AnnouncementsSuccess value, $Res Function(_AnnouncementsSuccess) _then) = __$AnnouncementsSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<AnnouncementModel> items, bool hasMore, bool loadingMore
});




}
/// @nodoc
class __$AnnouncementsSuccessCopyWithImpl<$Res>
    implements _$AnnouncementsSuccessCopyWith<$Res> {
  __$AnnouncementsSuccessCopyWithImpl(this._self, this._then);

  final _AnnouncementsSuccess _self;
  final $Res Function(_AnnouncementsSuccess) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? items = null,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(_AnnouncementsSuccess(
null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AnnouncementModel>,null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
