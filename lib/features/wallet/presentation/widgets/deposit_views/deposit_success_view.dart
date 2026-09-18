import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_receipt_row.dart';

class DepositSuccessView extends StatefulWidget {
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
  State<DepositSuccessView> createState() => _DepositSuccessViewState();
}

class _DepositSuccessViewState extends State<DepositSuccessView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedAmount = NumberFormat.currency(symbol: '\$').format(widget.amount);
    final formattedDate = DateFormat('MMM d, y, h:mm a').format(widget.depositTime);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Padding(
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedAmount added to your Tether balance',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // Mini receipt summary
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ReceiptRow(label: 'Reference', value: widget.referenceNumber),
                      const SizedBox(height: 12),
                      ReceiptRow(label: 'Date', value: formattedDate),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // View Receipt â€” expands the sheet
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: widget.onViewReceipt,
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
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          gravity: 0.1,
        ),
      ],
    );
  }
}
