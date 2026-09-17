import 'package:flutter/material.dart';
import 'package:wallet/core/utils/formatters.dart';
import 'package:decimal/decimal.dart';

class AssetBalanceTile extends StatelessWidget {
  final String name;
  final String symbol;
  final Decimal cryptoAmount;
  final double fiatAmount;
  final double changePercentage;
  final String iconUrl;
  final VoidCallback? onTap;

  const AssetBalanceTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.changePercentage,
    required this.iconUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = changePercentage >= 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                clipBehavior: Clip.antiAlias,
                child: iconUrl.isNotEmpty 
                    ? Image.network(iconUrl, fit: BoxFit.cover)
                    : Center(
                        child: Text(
                          symbol.isNotEmpty ? symbol[0] : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              
              // Name & Crypto amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${cryptoAmount.toStringAsFixed(4)} $symbol',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Fiat & Change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatFiat(fiatAmount),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(2)}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
