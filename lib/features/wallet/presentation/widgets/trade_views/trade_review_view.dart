import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class TradeReviewView extends HookConsumerWidget {
  final Future<void> Function(String coinId, String symbol, double cryptoAmount, double executionPrice) onConfirm;

  const TradeReviewView({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final flowState = ref.watch(tradeFlowProvider);
    final marketsState = ref.watch(marketsProvider);
    final markets = marketsState.value ?? [];
    
    if (markets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedCoin = markets.firstWhere(
      (c) => c.id == flowState.selectedCoinId,
      orElse: () => markets.first,
    );
    
    final inputAmount = flowState.inputAmount ?? 0.0;
    
    // Calculate the actual output after a 1% simulated fee
    final feeAmount = inputAmount * 0.01;
    final totalCost = inputAmount;
    final netAmount = inputAmount - feeAmount;
    final estimatedCrypto = netAmount / selectedCoin.currentPrice.toDouble();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // If buy, go back to input. 
                    ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.input);
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Text(
                    'Review Order',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance
              ],
            ),
            
            const SizedBox(height: 32),

            // Order Summary
            Center(
              child: Text(
                'You are buying',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${estimatedCrypto.toStringAsFixed(6)} ${selectedCoin.symbol.toUpperCase()}',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            // Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildRow('Payment Method', 'USDT Balance', theme),
                  const SizedBox(height: 12),
                  _buildRow('Price', '1 ${selectedCoin.symbol.toUpperCase()} = ${NumberFormat.currency(symbol: '\$').format(selectedCoin.currentPrice.toDouble())}', theme),
                  const SizedBox(height: 12),
                  _buildRow('Purchase Amount', NumberFormat.currency(symbol: '\$').format(netAmount), theme),
                  const SizedBox(height: 12),
                  _buildRow('Network Fee (1%)', NumberFormat.currency(symbol: '\$').format(feeAmount), theme),
                  const Divider(height: 24),
                  _buildRow('Total Cost', NumberFormat.currency(symbol: '\$').format(totalCost), theme, isBold: true),
                ],
              ),
            ),

            const Spacer(),

            // Confirm Button
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
                ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.processing);
                onConfirm(selectedCoin.id, selectedCoin.symbol, estimatedCrypto, selectedCoin.currentPrice.toDouble());
              },
              child: const Text(
                'Confirm Buy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, ThemeData theme, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isBold ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
