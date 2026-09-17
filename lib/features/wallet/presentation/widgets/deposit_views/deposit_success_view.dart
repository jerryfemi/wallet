import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'deposit_receipt_row.dart';

class DepositSuccessView extends StatelessWidget {
  final double amount;
  final String referenceNumber;
  final DateTime depositTime;
  final VoidCallback onViewReceipt;

  const DepositSuccessView({
    super.key,
    required this.amount,
    required this.referenceNumber,
    required this.depositTime,
    required this.onViewReceipt,
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
          // Success Icon
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.green.shade600,
              radius: 28,
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Deposit Successful',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$formattedAmount added to your Tether balance',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 24),

          // Mini receipt summary
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
                ReceiptRow(label: 'Date', value: formattedDate),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // View Receipt — expands the sheet
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onViewReceipt,
            child: const Text(
              'View Receipt',
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
