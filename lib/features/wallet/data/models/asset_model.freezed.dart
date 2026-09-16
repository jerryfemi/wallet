// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetModel {

 String get coinId; String get symbol;@DecimalConverter() Decimal get amount;
/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetModelCopyWith<AssetModel> get copyWith => _$AssetModelCopyWithImpl<AssetModel>(this as AssetModel, _$identity);

  /// Serializes this AssetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssetModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetModel&&(identical(other.coinId, _this.coinId) || other.coinId == _this.coinId)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssetModel;
  return Object.hash(runtimeType,_this.coinId,_this.symbol,_this.amount);
}

@override
String toString() {
  final _this = this as AssetModel;
  return 'AssetModel(coinId: ${_this.coinId}, symbol: ${_this.symbol}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $AssetModelCopyWith<$Res>  {
  factory $AssetModelCopyWith(AssetModel value, $Res Function(AssetModel) _then) = _$AssetModelCopyWithImpl;
@useResult
$Res call({
 String coinId, String symbol,@DecimalConverter() Decimal amount
});




}
/// @nodoc
class _$AssetModelCopyWithImpl<$Res>
    implements $AssetModelCopyWith<$Res> {
  _$AssetModelCopyWithImpl(this._self, this._then);

  final AssetModel _self;
  final $Res Function(AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coinId = null,Object? symbol = null,Object? amount = null,}) {
  return _then(AssetModel(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetModel].
extension AssetModelPatterns on AssetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetModel value)  $default,){
final _that = this;
switch (_that) {
case _AssetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coinId,  String symbol, @DecimalConverter()  Decimal amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
return $default(_that.coinId,_that.symbol,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coinId,  String symbol, @DecimalConverter()  Decimal amount)  $default,) {final _that = this;
switch (_that) {
case _AssetModel():
return $default(_that.coinId,_that.symbol,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coinId,  String symbol, @DecimalConverter()  Decimal amount)?  $default,) {final _that = this;
switch (_that) {
case _AssetModel() when $default != null:
return $default(_that.coinId,_that.symbol,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetModel extends AssetModel {
  const _AssetModel({required this.coinId, required this.symbol, @DecimalConverter() required this.amount}): super._();
  factory _AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);

@override final  String coinId;
@override final  String symbol;
@override@DecimalConverter() final  Decimal amount;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetModelCopyWith<_AssetModel> get copyWith => __$AssetModelCopyWithImpl<_AssetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetModel&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,coinId,symbol,amount);
}

@override
String toString() {
    return 'AssetModel(coinId: $coinId, symbol: $symbol, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$AssetModelCopyWith<$Res> implements $AssetModelCopyWith<$Res> {
  factory _$AssetModelCopyWith(_AssetModel value, $Res Function(_AssetModel) _then) = __$AssetModelCopyWithImpl;
@override @useResult
$Res call({
 String coinId, String symbol,@DecimalConverter() Decimal amount
});




}
/// @nodoc
class __$AssetModelCopyWithImpl<$Res>
    implements _$AssetModelCopyWith<$Res> {
  __$AssetModelCopyWithImpl(this._self, this._then);

  final _AssetModel _self;
  final $Res Function(_AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coinId = null,Object? symbol = null,Object? amount = null,}) {
  return _then(_AssetModel(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
