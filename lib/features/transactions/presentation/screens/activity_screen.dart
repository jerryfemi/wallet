import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/transactions/presentation/providers/transactions_provider.dart';
import 'package:wallet/features/transactions/presentation/widgets/transaction_filter_chips.dart';
import 'package:wallet/features/transactions/presentation/widgets/transaction_list_tile.dart';

class ActivityScreen extends HookConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeTransactionFilterProvider);
    final transactionsStream = ref.watch(transactionsStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverAppBar.medium(
            pinned: true,
            title: Text('Activity'),
          ),

          // Filter Chips
          SliverPersistentHeader(
            pinned: true,
            delegate: _TransactionFilterDelegate(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: TransactionFilterChips(),
              ),
            ),
          ),

          // Main Feed
          transactionsStream.when(
            data: (transactions) {
              final filteredTransactions = _filterTransactions(
                transactions,
                activeFilter,
              );

              if (filteredTransactions.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context, activeFilter),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final itemIndex = index ~/ 2;
                      if (index.isEven) {
                        return TransactionListTile(
                          transaction: filteredTransactions[itemIndex],
                          onTap: () {
                            // TODO: Open transaction details screen
                          },
                        );
                      }
                      return const Divider(height: 1, indent: 65, endIndent: 20);
                    },
                    childCount: filteredTransactions.length * 2 - 1,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.only(bottom: 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Skeletonizer(
                      enabled: true,
                      child: TransactionListTile(
                        transaction: _getDummyData()[index % _getDummyData().length],
                      ),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load transactions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TransactionEntity> _filterTransactions(
    List<TransactionEntity> transactions,
    TransactionFilter filter,
  ) {
    switch (filter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.buys:
        return transactions
            .where((t) => t.type == TransactionType.buy)
            .toList();
      case TransactionFilter.sells:
        return transactions
            .where((t) => t.type == TransactionType.sell)
            .toList();
      case TransactionFilter.deposits:
        return transactions
            .where((t) => t.type == TransactionType.deposit)
            .toList();
      case TransactionFilter.withdrawals:
        return transactions
            .where((t) => t.type == TransactionType.withdraw)
            .toList();
      case TransactionFilter.transfers:
        return transactions
            .where((t) => t.type == TransactionType.transfer)
            .toList();
    }
  }

  Widget _buildEmptyState(BuildContext context, TransactionFilter filter) {
    String message = 'No transactions yet.';
    if (filter != TransactionFilter.all) {
      message = 'No ${filter.name} yet.';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<TransactionEntity> _getDummyData() {
    return [
      TransactionEntity(
        id: '1',
        type: TransactionType.buy,
        assetSymbol: 'BTC',
        amount: Decimal.parse('0.05'),
        fiatValue: Decimal.parse('3200'),
        timestamp: DateTime.now(),
      ),
      TransactionEntity(
        id: '2',
        type: TransactionType.sell,
        assetSymbol: 'ETH',
        amount: Decimal.parse('1.5'),
        fiatValue: Decimal.parse('4500'),
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionEntity(
        id: '3',
        type: TransactionType.deposit,
        assetSymbol: 'USDT',
        amount: Decimal.parse('1000'),
        fiatValue: Decimal.parse('1000'),
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

class _TransactionFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TransactionFilterDelegate({required this.child});

  @override
  double get minExtent => 56.0;

  @override
  double get maxExtent => 56.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _TransactionFilterDelegate oldDelegate) =>
      oldDelegate.child != child;
}
