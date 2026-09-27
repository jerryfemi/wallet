// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coinCandles)
final coinCandlesProvider = CoinCandlesFamily._();

final class CoinCandlesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Candle>>,
          List<Candle>,
          FutureOr<List<Candle>>
        >
    with $FutureModifier<List<Candle>>, $FutureProvider<List<Candle>> {
  CoinCandlesProvider._({
    required CoinCandlesFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'coinCandlesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coinCandlesHash();

  @override
  String toString() {
    return r'coinCandlesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Candle>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Candle>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return coinCandles(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CoinCandlesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coinCandlesHash() => r'618504d34b85df61875c46b7d1d2dd4c7fe9ace1';

final class CoinCandlesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Candle>>, (String, String)> {
  CoinCandlesFamily._()
    : super(
        retry: null,
        name: r'coinCandlesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoinCandlesProvider call(String symbol, String granularity) =>
      CoinCandlesProvider._(argument: (symbol, granularity), from: this);

  @override
  String toString() => r'coinCandlesProvider';
}

@ProviderFor(coinNews)
final coinNewsProvider = CoinNewsFamily._();

final class CoinNewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NewsArticleEntity>>,
          List<NewsArticleEntity>,
          FutureOr<List<NewsArticleEntity>>
        >
    with
        $FutureModifier<List<NewsArticleEntity>>,
        $FutureProvider<List<NewsArticleEntity>> {
  CoinNewsProvider._({
    required CoinNewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coinNewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coinNewsHash();

  @override
  String toString() {
    return r'coinNewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<NewsArticleEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NewsArticleEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return coinNews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoinNewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coinNewsHash() => r'18c2b01e8b4ff44abd06e958e495ac25d1efd313';

final class CoinNewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<NewsArticleEntity>>, String> {
  CoinNewsFamily._()
    : super(
        retry: null,
        name: r'coinNewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoinNewsProvider call(String symbol) =>
      CoinNewsProvider._(argument: symbol, from: this);

  @override
  String toString() => r'coinNewsProvider';
}
