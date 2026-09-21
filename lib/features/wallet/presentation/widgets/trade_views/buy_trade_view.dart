import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class BuyTradeView extends HookConsumerWidget {
  final Future<void> Function(
    String coinId,
    String symbol,
    double cryptoAmount,
    double executionPrice,
  ) onConfirm;

  const BuyTradeView({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final flowState = ref.watch(tradeFlowProvider);
    final isReviewing = flowState.stage == TradeFlowStage.review;

    final marketsState = ref.watch(marketsProvider);
    final walletState = ref.watch(walletStreamProvider);
    final livePrices = ref.watch(livePricesProvider);

    final markets = marketsState.value ?? [];
    final wallet = walletState.value;

    // Local state for the amount string managed by the custom keypad
    final amountString = useState(
      flowState.inputAmount != null && flowState.inputAmount! > 0
          ? flowState.inputAmount!.toStringAsFixed(
              flowState.inputAmount! == flowState.inputAmount!.roundToDouble() ? 0 : 2,
            )
          : '',
    );

    if (wallet == null || markets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Default to Bitcoin if no coin is selected
    final selectedCoinId = flowState.selectedCoinId;
    final selectedCoin = markets.firstWhere(
      (c) => c.id == selectedCoinId,
      orElse: () => markets.firstWhere(
        (c) => c.symbol == 'BTC',
        orElse: () => markets.first,
      ),
    );

    // Get real-time execution price
    final tickerKey = '${selectedCoin.symbol.toUpperCase()}-USD';
    final executionPrice =
        (livePrices[tickerKey]?.price ?? selectedCoin.currentPrice).toDouble();

    final usdtAsset = wallet.assets.firstWhere(
      (a) => a.coinId == 'tether',
      orElse: () => wallet.assets.first,
    );
    final usdtBalance = usdtAsset.amount.toDouble();

    final inputAmount = double.tryParse(amountString.value) ?? 0.0;

    // What the user types is the fiat value (cost of crypto)
    final fiatValue = inputAmount;
    final feeAmount = fiatValue * 0.01;
    final totalCost = fiatValue + feeAmount;
    final estimatedCrypto =
        executionPrice > 0 ? (fiatValue / executionPrice) : 0.0;

    // Format the display amount
    final displayAmount = amountString.value.isEmpty ? '\$0' : '\$${amountString.value}';

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
      final parsed = double.tryParse(current);
      ref.read(tradeFlowProvider.notifier).setInputAmount(parsed);
    }

    void setQuickAmount(double amount) {
      amountString.value = amount.toStringAsFixed(2);
      ref.read(tradeFlowProvider.notifier).setInputAmount(amount);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Buy [Coin] and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buy ${selectedCoin.name}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Asset Selector Pill
            InkWell(
              onTap: () {
                ref
                    .read(tradeFlowProvider.notifier)
                    .setStage(TradeFlowStage.assetSelection);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(selectedCoin.imageUrl),
                      radius: 16,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedCoin.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.currency(symbol: '\$').format(executionPrice),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Large Amount Display (tappable in review mode to go back)
            GestureDetector(
              onTap: isReviewing
                  ? () {
                      ref
                          .read(tradeFlowProvider.notifier)
                          .setStage(TradeFlowStage.input);
                    }
                  : null,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayAmount,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (isReviewing) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Crypto equivalent estimate
            Center(
              child: Text(
                '≈ ${estimatedCrypto.toStringAsFixed(6)} ${selectedCoin.symbol.toUpperCase()}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Select Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickSelect('25%', usdtBalance * 0.25, setQuickAmount, theme),
                _buildQuickSelect('50%', usdtBalance * 0.50, setQuickAmount, theme),
                _buildQuickSelect('75%', usdtBalance * 0.75, setQuickAmount, theme),
                _buildQuickSelect('MAX', usdtBalance, setQuickAmount, theme),
              ],
            ),

            const SizedBox(height: 16),

            // Available Balance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${NumberFormat.currency(symbol: '\$').format(usdtBalance)} USDT',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Swappable area: Keypad (input) vs Review details
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: isReviewing
                  ? Column(
                      key: const ValueKey('review_section'),
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildFeeRow(
                                'Price',
                                NumberFormat.currency(symbol: '\$')
                                    .format(executionPrice),
                                theme,
                              ),
                              const SizedBox(height: 12),
                              _buildFeeRow(
                                'Network Fee',
                                NumberFormat.currency(symbol: '\$')
                                    .format(feeAmount),
                                theme,
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 12),
                              _buildFeeRow(
                                'Total',
                                NumberFormat.currency(symbol: '\$')
                                    .format(totalCost),
                                theme,
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFF26A17B),
                                radius: 12,
                                child: Text(
                                  '₮',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Pay with USDT balance',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : _NumericKeypad(
                      key: const ValueKey('keypad_section'),
                      onKeyTap: onKeyTap,
                    ),
            ),

            const SizedBox(height: 24),

            // Action Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: inputAmount > 0 && totalCost <= usdtBalance
                  ? () {
                      if (!isReviewing) {
                        ref
                            .read(tradeFlowProvider.notifier)
                            .setStage(TradeFlowStage.review);
                      } else {
                        ref
                            .read(tradeFlowProvider.notifier)
                            .setStage(TradeFlowStage.processing);
                        onConfirm(
                          selectedCoin.id,
                          selectedCoin.symbol,
                          estimatedCrypto,
                          executionPrice,
                        );
                      }
                    }
                  : null,
              child: Text(
                isReviewing
                    ? 'Confirm Buy — ${NumberFormat.currency(symbol: '\$').format(totalCost)}'
                    : 'Continue',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Simulated purchase disclaimer
            if (isReviewing) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Simulated purchase · no real assets are exchanged',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelect(
    String label,
    double amount,
    void Function(double) onTap,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => onTap(amount),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: label == 'MAX' ? theme.colorScheme.primary : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFeeRow(
    String label,
    String value,
    ThemeData theme, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isTotal
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Compact custom numeric keypad that avoids the native keyboard entirely.
class _NumericKeypad extends StatelessWidget {
  final void Function(String key) onKeyTap;

  const _NumericKeypad({super.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onKeyTap(key),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: key == '⌫'
                            ? Icon(
                                Icons.backspace_outlined,
                                color: colorScheme.onSurface,
                                size: 22,
                              )
                            : Text(
                                key,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
