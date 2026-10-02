import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

class SendScreen extends HookConsumerWidget {
  final CoinEntity coin;

  const SendScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final walletState = ref.watch(walletStreamProvider);
    final myAddress = walletState.value?.address ?? '';

    final addressController = useTextEditingController();
    
    // Amount state for custom keypad
    final amountText = useState('');
    
    final isLoading = useState(false);
    final isSuccess = useState(false);
    
    // Animation controller for the success checkmark
    final successAnimController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );
    final successScale = CurvedAnimation(
      parent: successAnimController,
      curve: Curves.elasticOut,
    );

    void handleKeyPress(String key) {
      HapticFeedback.lightImpact();
      if (key == '<') {
        if (amountText.value.isNotEmpty) {
          amountText.value = amountText.value.substring(0, amountText.value.length - 1);
        }
      } else if (key == '.') {
        if (!amountText.value.contains('.')) {
          amountText.value += amountText.value.isEmpty ? '0.' : '.';
        }
      } else {
        if (amountText.value == '0') {
          amountText.value = key;
        } else {
          // Limit length to avoid huge numbers breaking layout
          if (amountText.value.length < 12) {
             amountText.value += key;
          }
        }
      }
    }

    void handleSend() async {
      if (addressController.text.isEmpty || amountText.value.isEmpty) return;
      
      final amount = double.tryParse(amountText.value);
      if (amount == null || amount <= 0) return;

      isLoading.value = true;

      try {
        final mempool = ref.read(mempoolServiceProvider);
        
        final success = await mempool.broadcastTransfer(
          senderAddress: myAddress,
          receiverAddress: addressController.text.trim(),
          asset: coin.symbol.toUpperCase(),
          amount: amount,
          idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        if (success) {
          isSuccess.value = true;
          successAnimController.forward();
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            context.pop();
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to send transfer')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Send',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: coin.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error, size: 14),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              coin.symbol.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isSuccess.value 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: successScale,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: CurvedAnimation(parent: successAnimController, curve: Curves.easeIn),
                    child: Text(
                      'Sent Successfully',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sleek "To" Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'To:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Search or enter address',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        color: colorScheme.primary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              
              // Hero Amount
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            amountText.value.isEmpty ? '0' : amountText.value,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: amountText.value.isEmpty 
                                  ? colorScheme.onSurface.withValues(alpha: 0.3)
                                  : colorScheme.onSurface,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                        Text(
                          amountText.value.isEmpty 
                              ? 'Enter amount in ${coin.symbol.toUpperCase()}'
                              : '≈ \$0.00 USD', // Placeholder for fiat equivalent
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Custom Keypad
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _KeypadRow(keys: const ['1', '2', '3'], onPressed: handleKeyPress),
                      _KeypadRow(keys: const ['4', '5', '6'], onPressed: handleKeyPress),
                      _KeypadRow(keys: const ['7', '8', '9'], onPressed: handleKeyPress),
                      _KeypadRow(keys: const ['.', '0', '<'], onPressed: handleKeyPress),
                    ],
                  ),
                ),
              ),
              
              // Slide to Send Action
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _SlideToSendButton(
                  isLoading: isLoading.value,
                  onSlided: handleSend,
                  isEnabled: amountText.value.isNotEmpty && addressController.text.isNotEmpty && !isLoading.value,
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class _KeypadRow extends StatelessWidget {
  final List<String> keys;
  final Function(String) onPressed;

  const _KeypadRow({required this.keys, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) {
        return _KeypadButton(
          keyLabel: k,
          onPressed: () => onPressed(k),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String keyLabel;
  final VoidCallback onPressed;

  const _KeypadButton({required this.keyLabel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isBackspace = keyLabel == '<';
    
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        splashFactory: InkRipple.splashFactory,
        child: Container(
          height: 72,
          alignment: Alignment.center,
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  size: 28,
                  color: Theme.of(context).colorScheme.onSurface,
                )
              : Text(
                  keyLabel,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SlideToSendButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onSlided;
  final bool isEnabled;

  const _SlideToSendButton({
    required this.isLoading,
    required this.onSlided,
    required this.isEnabled,
  });

  @override
  State<_SlideToSendButton> createState() => _SlideToSendButtonState();
}

class _SlideToSendButtonState extends State<_SlideToSendButton> {
  double _dragPosition = 0.0;
  bool _isSlided = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final buttonWidth = maxWidth - 16; // 8px padding on each side
        final knobSize = 56.0;
        final maxDrag = buttonWidth - knobSize;
        
        return Container(
          height: 72,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isEnabled 
                ? colorScheme.primary.withValues(alpha: 0.15)
                : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background Text
              Center(
                child: widget.isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        'Slide to send',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.isEnabled
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              // Slidable Knob
              if (!widget.isLoading && !_isSlided)
                Positioned(
                  left: _dragPosition,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (!widget.isEnabled) return;
                      
                      setState(() {
                        _dragPosition += details.delta.dx;
                        _dragPosition = _dragPosition.clamp(0.0, maxDrag);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (!widget.isEnabled) return;
                      
                      if (_dragPosition >= maxDrag * 0.8) {
                        // Success threshold reached
                        setState(() {
                          _dragPosition = maxDrag;
                          _isSlided = true;
                        });
                        HapticFeedback.heavyImpact();
                        widget.onSlided();
                        
                        // Reset after a delay (if needed)
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            setState(() {
                              _dragPosition = 0;
                              _isSlided = false;
                            });
                          }
                        });
                      } else {
                        // Snap back
                        setState(() {
                          _dragPosition = 0.0;
                        });
                        HapticFeedback.lightImpact();
                      }
                    },
                    child: Container(
                      width: knobSize,
                      height: knobSize,
                      decoration: BoxDecoration(
                        color: widget.isEnabled
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: widget.isEnabled
                            ? [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: widget.isEnabled
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
