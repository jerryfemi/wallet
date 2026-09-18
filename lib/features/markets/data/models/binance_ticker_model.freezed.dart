// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'binance_ticker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BinanceTickerModel {

@JsonKey(name: 's') String get symbol;@DecimalConverter()@JsonKey(name: 'c') Decimal get price;@DecimalConverter()@JsonKey(name: 'P') Decimal get priceChangePercent;
/// Create a copy of BinanceTickerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BinanceTickerModelCopyWith<BinanceTickerModel> get copyWith => _$BinanceTickerModelCopyWithImpl<BinanceTickerModel>(this as BinanceTickerModel, _$identity);

  /// Serializes this BinanceTickerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BinanceTickerModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BinanceTickerModel&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.priceChangePercent, _this.priceChangePercent) || other.priceChangePercent == _this.priceChangePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BinanceTickerModel;
  return Object.hash(runtimeType,_this.symbol,_this.price,_this.priceChangePercent);
}

@override
String toString() {
  final _this = this as BinanceTickerModel;
  return 'BinanceTickerModel(symbol: ${_this.symbol}, price: ${_this.price}, priceChangePercent: ${_this.priceChangePercent})';
}


}

/// @nodoc
abstract mixin class $BinanceTickerModelCopyWith<$Res>  {
  factory $BinanceTickerModelCopyWith(BinanceTickerModel value, $Res Function(BinanceTickerModel) _then) = _$BinanceTickerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 's') String symbol,@DecimalConverter()@JsonKey(name: 'c') Decimal price,@DecimalConverter()@JsonKey(name: 'P') Decimal priceChangePercent
});




}
/// @nodoc
class _$BinanceTickerModelCopyWithImpl<$Res>
    implements $BinanceTickerModelCopyWith<$Res> {
  _$BinanceTickerModelCopyWithImpl(this._self, this._then);

  final BinanceTickerModel _self;
  final $Res Function(BinanceTickerModel) _then;

/// Create a copy of BinanceTickerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? price = null,Object? priceChangePercent = null,}) {
  return _then(BinanceTickerModel(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Decimal,priceChangePercent: null == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [BinanceTickerModel].
extension BinanceTickerModelPatterns on BinanceTickerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BinanceTickerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BinanceTickerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BinanceTickerModel value)  $default,){
final _that = this;
switch (_that) {
case _BinanceTickerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BinanceTickerModel value)?  $default,){
final _that = this;
switch (_that) {
case _BinanceTickerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 's')  String symbol, @DecimalConverter()@JsonKey(name: 'c')  Decimal price, @DecimalConverter()@JsonKey(name: 'P')  Decimal priceChangePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BinanceTickerModel() when $default != null:
return $default(_that.symbol,_that.price,_that.priceChangePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 's')  String symbol, @DecimalConverter()@JsonKey(name: 'c')  Decimal price, @DecimalConverter()@JsonKey(name: 'P')  Decimal priceChangePercent)  $default,) {final _that = this;
switch (_that) {
case _BinanceTickerModel():
return $default(_that.symbol,_that.price,_that.priceChangePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 's')  String symbol, @DecimalConverter()@JsonKey(name: 'c')  Decimal price, @DecimalConverter()@JsonKey(name: 'P')  Decimal priceChangePercent)?  $default,) {final _that = this;
switch (_that) {
case _BinanceTickerModel() when $default != null:
return $default(_that.symbol,_that.price,_that.priceChangePercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BinanceTickerModel extends BinanceTickerModel {
  const _BinanceTickerModel({@JsonKey(name: 's') required this.symbol, @DecimalConverter()@JsonKey(name: 'c') required this.price, @DecimalConverter()@JsonKey(name: 'P') required this.priceChangePercent}): super._();
  factory _BinanceTickerModel.fromJson(Map<String, dynamic> json) => _$BinanceTickerModelFromJson(json);

@override@JsonKey(name: 's') final  String symbol;
@override@DecimalConverter()@JsonKey(name: 'c') final  Decimal price;
@override@DecimalConverter()@JsonKey(name: 'P') final  Decimal priceChangePercent;

/// Create a copy of BinanceTickerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BinanceTickerModelCopyWith<_BinanceTickerModel> get copyWith => __$BinanceTickerModelCopyWithImpl<_BinanceTickerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BinanceTickerModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BinanceTickerModel&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceChangePercent, priceChangePercent) || other.priceChangePercent == priceChangePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,symbol,price,priceChangePercent);
}

@override
String toString() {
    return 'BinanceTickerModel(symbol: $symbol, price: $price, priceChangePercent: $priceChangePercent)';
}


}

/// @nodoc
abstract mixin class _$BinanceTickerModelCopyWith<$Res> implements $BinanceTickerModelCopyWith<$Res> {
  factory _$BinanceTickerModelCopyWith(_BinanceTickerModel value, $Res Function(_BinanceTickerModel) _then) = __$BinanceTickerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 's') String symbol,@DecimalConverter()@JsonKey(name: 'c') Decimal price,@DecimalConverter()@JsonKey(name: 'P') Decimal priceChangePercent
});




}
/// @nodoc
class __$BinanceTickerModelCopyWithImpl<$Res>
    implements _$BinanceTickerModelCopyWith<$Res> {
  __$BinanceTickerModelCopyWithImpl(this._self, this._then);

  final _BinanceTickerModel _self;
  final $Res Function(_BinanceTickerModel) _then;

/// Create a copy of BinanceTickerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? price = null,Object? priceChangePercent = null,}) {
  return _then(_BinanceTickerModel(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Decimal,priceChangePercent: null == priceChangePercent ? _self.priceChangePercent : priceChangePercent // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
