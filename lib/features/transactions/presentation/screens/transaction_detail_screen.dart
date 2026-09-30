import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/core/providers/exchange_rates_provider.dart';
import 'package:wallet/core/utils/formatters.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;
  final TransactionEntity? transaction;

  const TransactionDetailScreen({
    super.key, 
    required this.transactionId,
    this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: transaction == null 
          ? const Center(child: CircularProgressIndicator())
          : _buildDetails(context, theme, ref),
    );
  }

  Widget _buildDetails(BuildContext context, ThemeData theme, WidgetRef ref) {
    final formatFiat = ref.watch(fiatFormatterProvider);
    final isPositive =
        transaction!.type == TransactionType.buy ||
        transaction!.type == TransactionType.deposit ||
        transaction!.type == TransactionType.transfer;

    final color = isPositive ? Colors.green.shade400 : theme.colorScheme.error;
    final sign = isPositive ? '+' : '-';
    final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(),
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '$sign${Formatters.formatCrypto(transaction!.amount)} ${transaction!.assetSymbol}',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '≈ ${formatFiat(transaction!.fiatValue.toDouble())}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 48),
          _buildInfoRow(theme, 'Status', 'Completed', isStatus: true),
          const Divider(height: 32),
          _buildInfoRow(theme, 'Date', dateFormat.format(transaction!.timestamp)),
          const Divider(height: 32),
          _buildInfoRow(theme, 'Type', transaction!.type.name.toUpperCase()),
          const Divider(height: 32),
          _buildInfoRow(theme, 'Transaction ID', transaction!.id, isId: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value, {bool isStatus = false, bool isId = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isStatus ? Colors.green : theme.colorScheme.onSurface,
              fontSize: isId ? 14 : null,
            ),
            maxLines: isId ? 1 : null,
            overflow: isId ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }

  IconData _getIconData() {
    switch (transaction!.type) {
      case TransactionType.buy:
        return Icons.arrow_downward_rounded;
      case TransactionType.sell:
        return Icons.arrow_upward_rounded;
      case TransactionType.deposit:
        return Icons.account_balance_wallet_rounded;
      case TransactionType.withdraw:
        return Icons.account_balance_rounded;
      case TransactionType.transfer:
        return Icons.swap_horiz_rounded;
    }
  }
}
