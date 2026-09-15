import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:decimal/decimal.dart';

import '../../domain/entities/coin_entity.dart';

class TopMoverChip extends StatelessWidget {
  final CoinEntity coin;
  final VoidCallback onTap;

  const TopMoverChip({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= Decimal.zero;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mini Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: kIsWeb
                  ? Image.network(
                      coin.imageUrl,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(width: 28, height: 28, child: Icon(Icons.error, size: 14)),
                    )
                  : CachedNetworkImage(
                      imageUrl: coin.imageUrl,
                      width: 28,
                      height: 28,
                      placeholder: (context, url) => const SizedBox(width: 28, height: 28),
                      errorWidget: (context, url, error) =>
                          const SizedBox(width: 28, height: 28, child: Icon(Icons.error, size: 14)),
                    ),
            ),
            const SizedBox(width: 8),
            // Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  coin.symbol,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
