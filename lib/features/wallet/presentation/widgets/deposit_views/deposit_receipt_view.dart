import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'deposit_receipt_row.dart';

class DepositReceiptView extends StatelessWidget {
  final double amount;
  final String referenceNumber;
  final DateTime depositTime;

  const DepositReceiptView({
    super.key,
    required this.amount,
    required this.referenceNumber,
    required this.depositTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedAmount = NumberFormat.currency(symbol: '\$').format(amount);
    final formattedDate = DateFormat('MMM d, y, h:mm a').format(depositTime);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Receipt Header
          Row(
            children: [
              Text(
                'Receipt',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Deposit icon
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.green.shade600,
              radius: 28,
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Deposit',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Status badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

          // Transaction details card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ReceiptRow(label: 'Type', value: 'Deposit'),
                const SizedBox(height: 12),
                ReceiptRow(label: 'Asset', value: 'Tether'),
                const SizedBox(height: 12),
                ReceiptRow(label: 'Amount', value: formattedAmount),
                const SizedBox(height: 12),
                ReceiptRow(label: 'Method', value: 'Simulated Funding'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reference card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
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

          const SizedBox(height: 24),

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

          const SizedBox(height: 12),

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
    );
  }
}
