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
  )
  onConfirm;

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

    final amountController = useTextEditingController(
      text: flowState.inputAmount != null && flowState.inputAmount! > 0
          ? flowState.inputAmount.toString()
          : '',
    );
    useListenable(amountController);

    final inputAmount = double.tryParse(amountController.text) ?? 0.0;

    // What the user types is the fiat value (cost of crypto)
    final fiatValue = inputAmount;
    final feeAmount = fiatValue * 0.01;
    final totalCost = fiatValue + feeAmount;
    final estimatedCrypto = executionPrice > 0
        ? (fiatValue / executionPrice)
        : 0.0;

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
                      NumberFormat.currency(symbol: '\$')
                          .format(executionPrice),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Large Amount Input
            Center(
              child: IntrinsicWidth(
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '\$0',
                    hintStyle: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    prefixText: amountController.text.isNotEmpty ? '\$' : '',
                    prefixStyle: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onChanged: (val) {
                    final valDouble = double.tryParse(val);
                    ref
                        .read(tradeFlowProvider.notifier)
                        .setInputAmount(valDouble);
                  },
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

            const SizedBox(height: 32),

            // Quick Select Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickSelect(
                  '25%',
                  usdtBalance * 0.25,
                  amountController,
                  ref,
                  theme,
                ),
                _buildQuickSelect(
                  '50%',
                  usdtBalance * 0.50,
                  amountController,
                  ref,
                  theme,
                ),
                _buildQuickSelect(
                  '75%',
                  usdtBalance * 0.75,
                  amountController,
                  ref,
                  theme,
                ),
                _buildQuickSelect(
                  'MAX',
                  usdtBalance,
                  amountController,
                  ref,
                  theme,
                ),
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

            // Expandable Review Section
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: isReviewing
                  ? Column(
                      children: [
                        const SizedBox(height: 24),
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
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 32),

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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelect(
    String label,
    double amount,
    TextEditingController controller,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        controller.text = amount.toStringAsFixed(2);
        ref.read(tradeFlowProvider.notifier).setInputAmount(amount);
      },
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
