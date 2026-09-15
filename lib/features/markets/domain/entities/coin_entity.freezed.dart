// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoinEntity {

 String get id; String get symbol; String get name; String get imageUrl; Decimal get currentPrice; Decimal get marketCap; int get marketCapRank; Decimal get totalVolume; Decimal get priceChangePercentage24h; List<double> get sparkline;
/// Create a copy of CoinEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinEntityCopyWith<CoinEntity> get copyWith => _$CoinEntityCopyWithImpl<CoinEntity>(this as CoinEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoinEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.currentPrice, _this.currentPrice) || other.currentPrice == _this.currentPrice)&&(identical(other.marketCap, _this.marketCap) || other.marketCap == _this.marketCap)&&(identical(other.marketCapRank, _this.marketCapRank) || other.marketCapRank == _this.marketCapRank)&&(identical(other.totalVolume, _this.totalVolume) || other.totalVolume == _this.totalVolume)&&(identical(other.priceChangePercentage24h, _this.priceChangePercentage24h) || other.priceChangePercentage24h == _this.priceChangePercentage24h)&&const DeepCollectionEquality().equals(other.sparkline, _this.sparkline));
}


@override
int get hashCode {
  final _this = this as CoinEntity;
  return Object.hash(runtimeType,_this.id,_this.symbol,_this.name,_this.imageUrl,_this.currentPrice,_this.marketCap,_this.marketCapRank,_this.totalVolume,_this.priceChangePercentage24h,const DeepCollectionEquality().hash(_this.sparkline));
}

@override
String toString() {
  final _this = this as CoinEntity;
  return 'CoinEntity(id: ${_this.id}, symbol: ${_this.symbol}, name: ${_this.name}, imageUrl: ${_this.imageUrl}, currentPrice: ${_this.currentPrice}, marketCap: ${_this.marketCap}, marketCapRank: ${_this.marketCapRank}, totalVolume: ${_this.totalVolume}, priceChangePercentage24h: ${_this.priceChangePercentage24h}, sparkline: ${_this.sparkline})';
}


}

/// @nodoc
abstract mixin class $CoinEntityCopyWith<$Res>  {
  factory $CoinEntityCopyWith(CoinEntity value, $Res Function(CoinEntity) _then) = _$CoinEntityCopyWithImpl;
@useResult
$Res call({
 String id, String symbol, String name, String imageUrl, Decimal currentPrice, Decimal marketCap, int marketCapRank, Decimal totalVolume, Decimal priceChangePercentage24h, List<double> sparkline
});




}
/// @nodoc
class _$CoinEntityCopyWithImpl<$Res>
    implements $CoinEntityCopyWith<$Res> {
  _$CoinEntityCopyWithImpl(this._self, this._then);

  final CoinEntity _self;
  final $Res Function(CoinEntity) _then;

/// Create a copy of CoinEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? symbol = null,Object? name = null,Object? imageUrl = null,Object? currentPrice = null,Object? marketCap = null,Object? marketCapRank = null,Object? totalVolume = null,Object? priceChangePercentage24h = null,Object? sparkline = null,}) {
  return _then(CoinEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as Decimal,marketCap: null == marketCap ? _self.marketCap : marketCap // ignore: cast_nullable_to_non_nullable
as Decimal,marketCapRank: null == marketCapRank ? _self.marketCapRank : marketCapRank // ignore: cast_nullable_to_non_nullable
as int,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as Decimal,priceChangePercentage24h: null == priceChangePercentage24h ? _self.priceChangePercentage24h : priceChangePercentage24h // ignore: cast_nullable_to_non_nullable
as Decimal,sparkline: null == sparkline ? _self.sparkline : sparkline // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoinEntity].
extension CoinEntityPatterns on CoinEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoinEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoinEntity() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoinEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoinEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoinEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoinEntity() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String symbol,  String name,  String imageUrl,  Decimal currentPrice,  Decimal marketCap,  int marketCapRank,  Decimal totalVolume,  Decimal priceChangePercentage24h,  List<double> sparkline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoinEntity() when $default != null:
return $default(_that.id,_that.symbol,_that.name,_that.imageUrl,_that.currentPrice,_that.marketCap,_that.marketCapRank,_that.totalVolume,_that.priceChangePercentage24h,_that.sparkline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String symbol,  String name,  String imageUrl,  Decimal currentPrice,  Decimal marketCap,  int marketCapRank,  Decimal totalVolume,  Decimal priceChangePercentage24h,  List<double> sparkline)  $default,) {final _that = this;
switch (_that) {
case _CoinEntity():
return $default(_that.id,_that.symbol,_that.name,_that.imageUrl,_that.currentPrice,_that.marketCap,_that.marketCapRank,_that.totalVolume,_that.priceChangePercentage24h,_that.sparkline);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String symbol,  String name,  String imageUrl,  Decimal currentPrice,  Decimal marketCap,  int marketCapRank,  Decimal totalVolume,  Decimal priceChangePercentage24h,  List<double> sparkline)?  $default,) {final _that = this;
switch (_that) {
case _CoinEntity() when $default != null:
return $default(_that.id,_that.symbol,_that.name,_that.imageUrl,_that.currentPrice,_that.marketCap,_that.marketCapRank,_that.totalVolume,_that.priceChangePercentage24h,_that.sparkline);case _:
  return null;

}
}

}

/// @nodoc


class _CoinEntity implements CoinEntity {
  const _CoinEntity({required this.id, required this.symbol, required this.name, required this.imageUrl, required this.currentPrice, required this.marketCap, required this.marketCapRank, required this.totalVolume, required this.priceChangePercentage24h, required  List<double> sparkline}): _sparkline = sparkline;
  

@override final  String id;
@override final  String symbol;
@override final  String name;
@override final  String imageUrl;
@override final  Decimal currentPrice;
@override final  Decimal marketCap;
@override final  int marketCapRank;
@override final  Decimal totalVolume;
@override final  Decimal priceChangePercentage24h;
 final  List<double> _sparkline;
@override List<double> get sparkline {
  if (_sparkline is EqualUnmodifiableListView) return _sparkline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sparkline);
}


/// Create a copy of CoinEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinEntityCopyWith<_CoinEntity> get copyWith => __$CoinEntityCopyWithImpl<_CoinEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.marketCap, marketCap) || other.marketCap == marketCap)&&(identical(other.marketCapRank, marketCapRank) || other.marketCapRank == marketCapRank)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.priceChangePercentage24h, priceChangePercentage24h) || other.priceChangePercentage24h == priceChangePercentage24h)&&const DeepCollectionEquality().equals(other.sparkline, _sparkline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,symbol,name,imageUrl,currentPrice,marketCap,marketCapRank,totalVolume,priceChangePercentage24h,const DeepCollectionEquality().hash(_sparkline));
}

@override
String toString() {
    return 'CoinEntity(id: $id, symbol: $symbol, name: $name, imageUrl: $imageUrl, currentPrice: $currentPrice, marketCap: $marketCap, marketCapRank: $marketCapRank, totalVolume: $totalVolume, priceChangePercentage24h: $priceChangePercentage24h, sparkline: $sparkline)';
}


}

/// @nodoc
abstract mixin class _$CoinEntityCopyWith<$Res> implements $CoinEntityCopyWith<$Res> {
  factory _$CoinEntityCopyWith(_CoinEntity value, $Res Function(_CoinEntity) _then) = __$CoinEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String symbol, String name, String imageUrl, Decimal currentPrice, Decimal marketCap, int marketCapRank, Decimal totalVolume, Decimal priceChangePercentage24h, List<double> sparkline
});




}
/// @nodoc
class __$CoinEntityCopyWithImpl<$Res>
    implements _$CoinEntityCopyWith<$Res> {
  __$CoinEntityCopyWithImpl(this._self, this._then);

  final _CoinEntity _self;
  final $Res Function(_CoinEntity) _then;

/// Create a copy of CoinEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? symbol = null,Object? name = null,Object? imageUrl = null,Object? currentPrice = null,Object? marketCap = null,Object? marketCapRank = null,Object? totalVolume = null,Object? priceChangePercentage24h = null,Object? sparkline = null,}) {
  return _then(_CoinEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as Decimal,marketCap: null == marketCap ? _self.marketCap : marketCap // ignore: cast_nullable_to_non_nullable
as Decimal,marketCapRank: null == marketCapRank ? _self.marketCapRank : marketCapRank // ignore: cast_nullable_to_non_nullable
as int,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as Decimal,priceChangePercentage24h: null == priceChangePercentage24h ? _self.priceChangePercentage24h : priceChangePercentage24h // ignore: cast_nullable_to_non_nullable
as Decimal,sparkline: null == sparkline ? _self._sparkline : sparkline // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
