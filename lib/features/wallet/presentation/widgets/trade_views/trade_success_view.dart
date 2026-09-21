import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_receipt_row.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class TradeSuccessView extends HookWidget {
  final TradeFlowType type;
  final String title;
  final String message;
  final String referenceNumber;
  final DateTime tradeTime;
  final VoidCallback onViewReceipt;

  const TradeSuccessView({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.referenceNumber,
    required this.tradeTime,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(milliseconds: 1500)),
    );

    useEffect(() {
      confettiController.play();

      final overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 40,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.1,
                minimumSize: const Size(5, 5),
                maximumSize: const Size(12, 12),
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          );
        },
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Overlay.of(context).insert(overlayEntry);
        }
      });

      return () {
        overlayEntry.remove();
        confettiController.dispose();
      };
    }, const []);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat('MMM d, y, h:mm a').format(tradeTime);

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
                  child: Lottie.asset(
                    'assets/lottie/Success.json',
                    width: 80,
                    height: 80,
                    repeat: false,
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
                const SizedBox(height: 4),
                Text(
                  message,
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
                      ReceiptRow(label: 'Reference', value: referenceNumber),
                      const SizedBox(height: 12),
                      ReceiptRow(label: 'Date', value: formattedDate),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // View Receipt
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
          ),
        ),
      ],
    );
  }
}
