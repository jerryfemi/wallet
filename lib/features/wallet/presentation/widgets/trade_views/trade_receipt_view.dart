import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_receipt_row.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class TradeReceiptView extends StatelessWidget {
  final TradeFlowType type;
  final String title;
  final double cryptoAmount;
  final double fiatAmount;
  final String coinSymbol;
  final String coinName;
  final String referenceNumber;
  final DateTime tradeTime;
  final String method;
  final Widget? customIcon;

  const TradeReceiptView({
    super.key,
    required this.type,
    required this.title,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.coinSymbol,
    required this.coinName,
    required this.referenceNumber,
    required this.tradeTime,
    required this.method,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedFiatAmount = NumberFormat.currency(symbol: '\$').format(fiatAmount);
    final formattedDate = DateFormat('MMM d, y, h:mm a').format(tradeTime);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Receipt Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Text(
                    'Receipt',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance the icon space
              ],
            ),

            const SizedBox(height: 32),

            // Deposit/Buy icon
            Center(
              child: customIcon ?? CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 28,
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Status badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14, color: Colors.green.shade400),
                    const SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Dashed divider (simulated)
            Row(
              children: List.generate(
                30,
                (i) => Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Receipt Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ReceiptRow(label: 'Type', value: title),
                  const SizedBox(height: 12),
                  ReceiptRow(label: 'Asset', value: coinName),
                  if (type != TradeFlowType.deposit) ...[
                    const SizedBox(height: 12),
                    ReceiptRow(label: 'Crypto Amount', value: '${cryptoAmount.toStringAsFixed(6)} $coinSymbol'),
                  ],
                  const SizedBox(height: 12),
                  ReceiptRow(label: type == TradeFlowType.deposit ? 'Amount' : 'Fiat Value', value: formattedFiatAmount),
                  const SizedBox(height: 12),
                  ReceiptRow(label: 'Method', value: method),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Reference card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ReceiptRow(label: 'Reference', value: referenceNumber),
                  const SizedBox(height: 12),
                  ReceiptRow(label: 'Date & Time', value: formattedDate),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Share Receipt
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // TODO: Share receipt functionality
              },
              child: const Text(
                'Share Receipt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Spacer(),

            // Done
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
