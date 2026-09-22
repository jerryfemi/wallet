import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_views/asset_picker_sheet.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';
import 'package:wallet/shared/widgets/numeric_keypad.dart';

class SellTradeView extends HookConsumerWidget {
  final Future<void> Function(
    String coinId,
    String symbol,
    double cryptoAmount,
    double executionPrice,
  )
  onConfirm;

  const SellTradeView({super.key, required this.onConfirm});

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
          ? flowState.inputAmount!
                .toStringAsFixed(6)
                .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")
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
    final tickerKey = selectedCoin.symbol.toUpperCase();
    final executionPrice =
        (livePrices[tickerKey]?.price ?? selectedCoin.currentPrice).toDouble();

    final cryptoAsset = wallet.assets.firstWhere(
      (a) => a.coinId == selectedCoin.id,
      orElse: () => wallet.assets.firstWhere(
        (a) => a.coinId == 'tether',
        orElse: () => wallet.assets.first,
      ), // Fallback if 0 balance
    );
    // If the found asset doesn't match the selected coin, it means balance is 0
    final cryptoBalance = cryptoAsset.coinId == selectedCoin.id
        ? cryptoAsset.amount.toDouble()
        : 0.0;

    final inputAmount = double.tryParse(amountString.value) ?? 0.0;

    // What the user types is the crypto amount to sell
    final fiatValue = inputAmount * executionPrice;
    final feeAmount = fiatValue * 0.01; // 1% fee
    final totalReturn = fiatValue - feeAmount;

    final isBelowMin = inputAmount > 0 && fiatValue < 1.0;
    final isAboveMax = inputAmount > cryptoBalance;

    // Format the display amount
    final displayAmount = amountString.value.isEmpty
        ? '0 ${selectedCoin.symbol.toUpperCase()}'
        : '${amountString.value} ${selectedCoin.symbol.toUpperCase()}';

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
          // Limit decimal places to 6 for crypto
          if (current.contains('.')) {
            final decimalPart = current.split('.').last;
            if (decimalPart.length >= 6) return;
          }
          current = '$current$key';
        }
      }
      amountString.value = current;
      final parsed = double.tryParse(current);
      ref.read(tradeFlowProvider.notifier).setInputAmount(parsed);
    }

    void setQuickAmount(double amount) {
      String formatted = amount
          .toStringAsFixed(6)
          .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (formatted.isEmpty) formatted = "0";

      amountString.value = formatted;
      ref.read(tradeFlowProvider.notifier).setInputAmount(amount);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Sell [Coin] and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sell ${selectedCoin.name}',
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
              onTap: () async {
                final selectedId = await AssetPickerSheet.show(
                  context,
                  isSell: true,
                );
                if (selectedId != null) {
                  ref
                      .read(tradeFlowProvider.notifier)
                      .setSelectedCoinId(selectedId);

                  // Reset input when asset changes
                  amountString.value = '';
                  ref.read(tradeFlowProvider.notifier).setInputAmount(0.0);
                }
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
                      NumberFormat.currency(symbol: '\$')
                          .format(executionPrice),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 22,
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
                        color: (isBelowMin || isAboveMax)
                            ? colorScheme.error
                            : colorScheme.onSurface,
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

            // Fiat equivalent estimate
            Center(
              child: Text(
                '≈ ${NumberFormat.currency(symbol: '\$').format(fiatValue)} USDT',
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
                _buildQuickSelect(
                  '25%',
                  cryptoBalance * 0.25,
                  setQuickAmount,
                  theme,
                ),
                _buildQuickSelect(
                  '50%',
                  cryptoBalance * 0.50,
                  setQuickAmount,
                  theme,
                ),
                _buildQuickSelect(
                  '75%',
                  cryptoBalance * 0.75,
                  setQuickAmount,
                  theme,
                ),
                _buildQuickSelect('MAX', cryptoBalance, setQuickAmount, theme),
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
                    '${cryptoBalance.toStringAsFixed(6).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")} ${selectedCoin.symbol.toUpperCase()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Main Content Area: Keypad OR Review Details
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isReviewing
                  ? _buildReviewDetails(
                      fiatValue: fiatValue,
                      feeAmount: feeAmount,
                      totalReturn: totalReturn,
                      executionPrice: executionPrice,
                      theme: theme,
                    )
                  : NumericKeypad(
                      key: const ValueKey('keypad_section'),
                      onKeyTap: onKeyTap,
                    ),
            ),

            const SizedBox(height: 24),

            // Main Action Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: colorScheme.onSurface.withValues(
                  alpha: 0.12,
                ),
              ),
              onPressed: (inputAmount <= 0 || isBelowMin || isAboveMax)
                  ? null
                  : () async {
                      if (!isReviewing) {
                        ref
                            .read(tradeFlowProvider.notifier)
                            .setStage(TradeFlowStage.review);
                      } else {
                        ref
                            .read(tradeFlowProvider.notifier)
                            .setStage(TradeFlowStage.processing);

                        await onConfirm(
                          selectedCoin.id,
                          selectedCoin.symbol.toUpperCase(),
                          inputAmount,
                          executionPrice,
                        );
                      }
                    },
              child: Text(
                isBelowMin
                    ? 'Minimum \$1.00'
                    : isAboveMax
                    ? 'Insufficient ${selectedCoin.symbol.toUpperCase()} Balance'
                    : isReviewing
                    ? 'Confirm Sell — ${NumberFormat.currency(symbol: '\$').format(totalReturn)}'
                    : 'Continue',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Simulated transaction disclaimer
            if (isReviewing) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Simulated transaction · no real assets are exchanged',
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
          ),
        ),
      ),
    );
  }

  Widget _buildReviewDetails({
    required double fiatValue,
    required double feeAmount,
    required double totalReturn,
    required double executionPrice,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildReviewRow(
            'Execution Price',
            NumberFormat.currency(symbol: '\$').format(executionPrice),
            theme,
          ),
          const Divider(height: 32),
          _buildReviewRow(
            'Gross Fiat Value',
            NumberFormat.currency(symbol: '\$').format(fiatValue),
            theme,
          ),
          const SizedBox(height: 16),
          _buildReviewRow(
            'Fee (1%)',
            '-${NumberFormat.currency(symbol: '\$').format(feeAmount)}',
            theme,
            valueColor: theme.colorScheme.error,
          ),
          const Divider(height: 32),
          _buildReviewRow(
            'Total Return',
            NumberFormat.currency(symbol: '\$').format(totalReturn),
            theme,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(
    String label,
    String value,
    ThemeData theme, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isTotal ? null : theme.colorScheme.onSurfaceVariant,
            fontWeight: isTotal ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? (isTotal ? theme.colorScheme.primary : null),
          ),
        ),
      ],
    );
  }
}
