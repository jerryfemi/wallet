import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BuyInputView extends HookConsumerWidget {
  const BuyInputView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final flowState = ref.watch(tradeFlowProvider);
    final marketsState = ref.watch(marketsProvider);
    final walletState = ref.watch(walletStreamProvider);
    
    final markets = marketsState.value ?? [];
    final wallet = walletState.value;

    if (wallet == null || markets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedCoin = markets.firstWhere(
      (c) => c.id == flowState.selectedCoinId,
      orElse: () => markets.first,
    );
    
    final usdtAsset = wallet.assets.firstWhere(
      (a) => a.coinId == 'tether',
      orElse: () => wallet.assets.first,
    );
    final usdtBalance = usdtAsset.amount.toDouble();

    final amountController = useTextEditingController();
    useListenable(amountController);

    final inputAmount = double.tryParse(amountController.text) ?? 0.0;
    final estimatedCrypto = inputAmount / selectedCoin.currentPrice.toDouble();

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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Text(
                    'Buy ${selectedCoin.symbol.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance
              ],
            ),
            const SizedBox(height: 16),

            // Asset To Buy
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    NumberFormat.currency(symbol: '\$').format(selectedCoin.currentPrice.toDouble()),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Amount Input
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IntrinsicWidth(
                  child: TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
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

            const SizedBox(height: 8),
            
            // Estimated Crypto
            Text(
              '≈ ${estimatedCrypto > 0 ? estimatedCrypto.toStringAsFixed(6) : "0.00"} ${selectedCoin.symbol.toUpperCase()}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Available USDT and Quick Select
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickSelect('25%', usdtBalance * 0.25, amountController, theme),
                      _buildQuickSelect('50%', usdtBalance * 0.50, amountController, theme),
                      _buildQuickSelect('Max', usdtBalance, amountController, theme),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Preview Buy Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: inputAmount > 0 && inputAmount <= usdtBalance
                  ? () {
                      ref.read(tradeFlowProvider.notifier).setInputAmount(inputAmount);
                      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.review);
                    }
                  : null,
              child: const Text(
                'Preview Buy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            if (inputAmount > usdtBalance)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Insufficient USDT balance',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelect(String label, double amount, TextEditingController controller, ThemeData theme) {
    return ActionChip(
      label: Text(label),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        controller.text = amount.toStringAsFixed(2);
      },
    );
  }
}
