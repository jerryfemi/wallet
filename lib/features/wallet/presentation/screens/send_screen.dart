import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/shared/widgets/numeric_keypad.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_failed_dialog.dart';

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
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => TradeFailedDialog(
                title: 'Transfer Failed',
                message: 'Failed to broadcast transfer to the network. Please try again.',
                onDismiss: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => TradeFailedDialog(
              title: 'Transfer Error',
              message: e.toString(),
              onDismiss: () {
                Navigator.of(context).pop();
              },
            ),
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
                        Builder(
                          builder: (context) {
                            if (amountText.value.isEmpty) {
                              return Text(
                                'Enter amount in ${coin.symbol.toUpperCase()}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            
                            final amountDouble = double.tryParse(amountText.value) ?? 0.0;
                            // Ensure coin.currentPrice is parsed correctly, it might be Decimal or double depending on your entity.
                            // Assuming coin.currentPrice is Decimal based on top_mover_chip.dart, we need to convert to double.
                            final priceDouble = coin.currentPrice.toDouble();
                            final fiatValue = amountDouble * priceDouble;
                            
                            return Text(
                              '≈ \$${fiatValue.toStringAsFixed(2)} USD',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
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
                  child: NumericKeypad(onKeyTap: handleKeyPress),
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
                    : Opacity(
                        opacity: (1.0 - (_dragPosition / (maxDrag * 0.4))).clamp(0.0, 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Slide to send',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: widget.isEnabled
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.isEnabled) ...[
                              const SizedBox(width: 8),
                              const _AnimatedChevrons(),
                            ],
                          ],
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

class _AnimatedChevrons extends StatefulWidget {
  const _AnimatedChevrons();

  @override
  State<_AnimatedChevrons> createState() => _AnimatedChevronsState();
}

class _AnimatedChevronsState extends State<_AnimatedChevrons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Stagger the fading
            final animationValue = (_controller.value - (index * 0.2)) % 1.0;
            final opacity = animationValue < 0.0 ? 0.0 : (1.0 - animationValue).clamp(0.0, 1.0);
            
            return Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Opacity(
                opacity: opacity,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
