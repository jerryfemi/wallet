import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/utils/formatters.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';

class TransactionListTile extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;

  const TransactionListTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isPositive =
        transaction.type == TransactionType.buy ||
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.transfer; // Assuming transfers in are positive for now, could refine later

    final IconData iconData = _getIconData();
    final Color iconColor = _getIconColor(colorScheme);
    final Color iconBgColor = iconColor.withValues(alpha: 0.15);

    final String title = _getTitle();

    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final String formattedDate = dateFormat.format(transaction.timestamp);

    // Format crypto amount (e.g. "+0.05 BTC")
    final String sign = isPositive ? '+' : '-';
    final String cryptoText =
        '$sign${Formatters.formatCrypto(transaction.amount)} ${transaction.assetSymbol}';

    // Format fiat amount (e.g. "$3,200.00")
    final String fiatText = Formatters.formatFiat(
      transaction.fiatValue.toDouble(),
    );

    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Title & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Amounts
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cryptoText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPositive
                        ? Colors.green.shade400
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fiatText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (transaction.type) {
      case TransactionType.buy:
        return 'Bought ${transaction.assetSymbol}';
      case TransactionType.sell:
        return 'Sold ${transaction.assetSymbol}';
      case TransactionType.deposit:
        return 'Deposited ${transaction.assetSymbol}';
      case TransactionType.withdraw:
        return 'Withdrew ${transaction.assetSymbol}';
      case TransactionType.transfer:
        return 'Transferred ${transaction.assetSymbol}';
    }
  }

  IconData _getIconData() {
    switch (transaction.type) {
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

  Color _getIconColor(ColorScheme colorScheme) {
    switch (transaction.type) {
      case TransactionType.buy:
      case TransactionType.deposit:
        return Colors.green.shade400;
      case TransactionType.sell:
      case TransactionType.withdraw:
        return colorScheme.error;
      case TransactionType.transfer:
        return colorScheme.primary;
    }
  }
}
