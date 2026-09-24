import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/transactions/presentation/providers/transactions_provider.dart';

class TransactionFilterChips extends HookConsumerWidget {
  const TransactionFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: const [
          _FilterPill(label: 'All', filter: TransactionFilter.all),
          SizedBox(width: 8),
          _FilterPill(label: 'Buys', filter: TransactionFilter.buys),
          SizedBox(width: 8),
          _FilterPill(label: 'Sells', filter: TransactionFilter.sells),
          SizedBox(width: 8),
          _FilterPill(label: 'Deposits', filter: TransactionFilter.deposits),
          SizedBox(width: 8),
          _FilterPill(label: 'Withdrawals', filter: TransactionFilter.withdrawals),
          SizedBox(width: 8),
          _FilterPill(label: 'Transfers', filter: TransactionFilter.transfers),
        ],
      ),
    );
  }
}

class _FilterPill extends HookConsumerWidget {
  final String label;
  final TransactionFilter filter;

  const _FilterPill({required this.label, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeTransactionFilterProvider);
    final isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(activeTransactionFilterProvider.notifier).setFilter(filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
