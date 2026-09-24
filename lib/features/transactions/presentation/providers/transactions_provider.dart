import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

enum TransactionFilter { all, buys, sells, deposits, withdrawals, transfers }

@riverpod
class ActiveTransactionFilter extends _$ActiveTransactionFilter {
  @override
  TransactionFilter build() => TransactionFilter.all;

  void setFilter(TransactionFilter filter) => state = filter;
}
