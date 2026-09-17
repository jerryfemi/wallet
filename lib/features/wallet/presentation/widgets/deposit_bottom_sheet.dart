import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

enum DepositStage { input, processing, success }

class DepositBottomSheet extends HookConsumerWidget {
  const DepositBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = useState(DepositStage.input);
    final amountController = useTextEditingController();
    
    // Auto-focus on input stage
    final focusNode = useFocusNode();
    useEffect(() {
      if (stage.value == DepositStage.input) {
        focusNode.requestFocus();
      }
      return null;
    }, [stage.value]);

    final onDepositSubmit = useCallback((double amount) async {
      stage.value = DepositStage.processing;
      
      // Simulate delay for processing
      await Future.delayed(const Duration(seconds: 2));
      
      await ref.read(simulateDepositProvider(amount).future);
      
      stage.value = DepositStage.success;
    }, [ref]);

    return SafeArea(
      top: false,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildStage(context, stage, amountController, focusNode, onDepositSubmit),
      ),
    );
  }

  Widget _buildStage(
    BuildContext context, 
    ValueNotifier<DepositStage> stage,
    TextEditingController amountController,
    FocusNode focusNode,
    Future<void> Function(double) onDepositSubmit,
  ) {
    switch (stage.value) {
      case DepositStage.input:
        return _InputStage(
          amountController: amountController,
          focusNode: focusNode,
          onSubmit: onDepositSubmit,
        );
      case DepositStage.processing:
        return const _ProcessingStage();
      case DepositStage.success:
        return _SuccessStage(
          amount: double.tryParse(amountController.text) ?? 0.0,
        );
    }
  }
}

class _InputStage extends HookWidget {
  final TextEditingController amountController;
  final FocusNode focusNode;
  final Future<void> Function(double) onSubmit;

  const _InputStage({
    required this.amountController,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Deposit',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Fixed Asset Selector (Tether)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF26A17B), // Tether green
                  radius: 16,
                  child: const Text('T', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Text('Tether (USDT)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Amount Input
          TextField(
            controller: amountController,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900),
            decoration: InputDecoration(
              hintText: '0',
              prefixText: '\$',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          
          const SizedBox(height: 8),
          Text(
            'Simulated balance — added instantly',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          
          const SizedBox(height: 32),
          
          // Preset Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PresetChip(amount: 100, controller: amountController),
              _PresetChip(amount: 500, controller: amountController),
              _PresetChip(amount: 1000, controller: amountController),
              _PresetChip(amount: 5000, controller: amountController),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Submit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              final val = double.tryParse(amountController.text);
              if (val != null && val > 0) {
                onSubmit(val);
              }
            },
            child: const Text('Deposit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final int amount;
  final TextEditingController controller;

  const _PresetChip({required this.amount, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text('\$$amount'),
      onPressed: () {
        controller.text = amount.toString();
      },
    );
  }
}

class _ProcessingStage extends StatelessWidget {
  const _ProcessingStage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          Text(
            'Processing your deposit...',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This will just take a moment',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SuccessStage extends StatelessWidget {
  final double amount;
  
  const _SuccessStage({required this.amount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 32,
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Deposit Successful',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$$amount added to your Tether balance',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          
          // Receipt Mock
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reference', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    Text('#TX-81863', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    Text('Just now', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          TextButton(
            onPressed: () {
              final controller = StupidSimpleSheetController.maybeOf<void>(context);
              controller?.animateToRelative(0.9, snap: true);
            },
            child: const Text('View Receipt'),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
