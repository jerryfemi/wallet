import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

enum DepositStage { input, processing, success, receipt }

class DepositBottomSheet extends HookConsumerWidget {
  const DepositBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = useState(DepositStage.input);
    final amountController = useTextEditingController();
    final depositedAmount = useState(0.0);
    final referenceNumber = useState('');
    final depositTime = useState(DateTime.now());

    // Generate a random reference number on deposit
    String generateRef() {
      final rand = Random();
      return '#TX-${rand.nextInt(90000) + 10000}';
    }

    // Animate sheet height when stage changes
    useEffect(() {
      // Use post-frame callback to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = StupidSimpleSheetController.maybeOf<void>(context);
        if (controller == null) return;

        double target = 0.55;
        switch (stage.value) {
          case DepositStage.input:
            target = 0.55;
            break;
          case DepositStage.processing:
            target = 0.35;
            break;
          case DepositStage.success:
            target = 0.55;
            break;
          case DepositStage.receipt:
            target = 0.9;
            break;
        }
        
        controller.overrideSnappingConfig(
          SheetSnappingConfig([target], initialSnap: target),
          animateToComply: true,
        );
      });
      return null;
    }, [stage.value]);

    Future<void> onDepositSubmit(double amount) async {
      stage.value = DepositStage.processing;

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Execute the actual deposit
      await ref.read(simulateDepositProvider(amount).future);

      depositedAmount.value = amount;
      referenceNumber.value = generateRef();
      depositTime.value = DateTime.now();

      stage.value = DepositStage.success;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildCurrentStage(
        context,
        stage: stage,
        amountController: amountController,
        depositedAmount: depositedAmount.value,
        referenceNumber: referenceNumber.value,
        depositTime: depositTime.value,
        onSubmit: onDepositSubmit,
      ),
    );
  }

  Widget _buildCurrentStage(
    BuildContext context, {
    required ValueNotifier<DepositStage> stage,
    required TextEditingController amountController,
    required double depositedAmount,
    required String referenceNumber,
    required DateTime depositTime,
    required Future<void> Function(double) onSubmit,
  }) {
    switch (stage.value) {
      case DepositStage.input:
        return _InputView(
          key: const ValueKey('input'),
          amountController: amountController,
          onSubmit: onSubmit,
        );
      case DepositStage.processing:
        return const _ProcessingView(key: ValueKey('processing'));
      case DepositStage.success:
        return _SuccessView(
          key: const ValueKey('success'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
          onViewReceipt: () => stage.value = DepositStage.receipt,
        );
      case DepositStage.receipt:
        return _ReceiptView(
          key: const ValueKey('receipt'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _InputView extends StatelessWidget {
  final TextEditingController amountController;
  final Future<void> Function(double) onSubmit;

  const _InputView({
    super.key,
    required this.amountController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with close button
          Row(
            children: [
              Text(
                'Deposit',
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
          const SizedBox(height: 16),

          // Fixed Asset (Tether)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF26A17B),
                  radius: 16,
                  child: Text(
                    '₮',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tether',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Amount Input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$',
                style: theme.textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
              ),
              IntrinsicWidth(
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                  decoration: const InputDecoration(
                    hintText: '0',
                    filled: false,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            'Simulated balance — added instantly',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 24),

          // Preset Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [100, 500, 1000, 5000].map((amount) {
              return ActionChip(
                label: Text(
                  '\$${NumberFormat.compact().format(amount)}',
                ),
                onPressed: () {
                  amountController.text = amount.toString();
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Deposit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              final val = double.tryParse(amountController.text);
              if (val != null && val > 0) {
                onSubmit(val);
              }
            },
            child: const Text(
              'Deposit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'No real payment method required — this is a simulator',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROCESSING VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Processing your deposit...',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This will just take a moment',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUCCESS VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final double amount;
  final String referenceNumber;
  final DateTime depositTime;
  final VoidCallback onViewReceipt;

  const _SuccessView({
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
                _ReceiptRow(label: 'Reference', value: referenceNumber),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Date', value: formattedDate),
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

// ─────────────────────────────────────────────────────────────────────────────
// RECEIPT VIEW (full expanded)
// ─────────────────────────────────────────────────────────────────────────────

class _ReceiptView extends StatelessWidget {
  final double amount;
  final String referenceNumber;
  final DateTime depositTime;

  const _ReceiptView({
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
                _ReceiptRow(label: 'Type', value: 'Deposit'),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Asset', value: 'Tether'),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Amount', value: formattedAmount),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Method', value: 'Simulated Funding'),
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
                _ReceiptRow(label: 'Reference', value: referenceNumber),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Date & Time', value: formattedDate),
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

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
