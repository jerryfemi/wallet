import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:wallet/shared/widgets/numeric_keypad.dart';

class DepositInputView extends HookWidget {
  final Future<void> Function(double) onSubmit;

  const DepositInputView({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Local state for the amount string managed by the custom keypad
    final amountString = useState('');

    final inputAmount = double.tryParse(amountString.value) ?? 0.0;
    final displayAmount =
        amountString.value.isEmpty ? '\$0' : '\$${amountString.value}';

    void onKeyTap(String key) {
      String current = amountString.value;
      if (key == '⌫') {
        if (current.isNotEmpty) {
          current = current.substring(0, current.length - 1);
        }
      } else if (key == '.') {
        if (!current.contains('.') && current.isNotEmpty) {
          current = '$current.';
        } else if (current.isEmpty) {
          current = '0.';
        }
      } else {
        // Prevent leading zeros (except "0.")
        if (current == '0' && key != '.') {
          current = key;
        } else {
          // Limit decimal places to 2
          if (current.contains('.')) {
            final decimalPart = current.split('.').last;
            if (decimalPart.length >= 2) return;
          }
          current = '$current$key';
        }
      }
      amountString.value = current;
    }

    void setQuickAmount(double amount) {
      amountString.value = amount.toStringAsFixed(0);
    }

    return SingleChildScrollView(
      child: Padding(
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Amount Display
            Center(
              child: Text(
                displayAmount,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 4),
            Text(
              'Simulated balance — added instantly',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Preset Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [100, 500, 1000, 5000].map((amount) {
                return ActionChip(
                  label:
                      Text('\$${NumberFormat.compact().format(amount)}'),
                  onPressed: () => setQuickAmount(amount.toDouble()),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Custom Numeric Keypad
            NumericKeypad(onKeyTap: onKeyTap),

            const SizedBox(height: 16),

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
              onPressed: inputAmount > 0 ? () => onSubmit(inputAmount) : null,
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
      ),
    );
  }
}
