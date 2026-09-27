import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/widgets/token_info_group.dart';

class AboutCoinContent extends StatelessWidget {
  final CoinEntity coin;
  final Map<String, dynamic> details;

  const AboutCoinContent({
    super.key,
    required this.coin,
    required this.details,
  });

  /// Skeleton variant for loading state
  factory AboutCoinContent.skeleton({required CoinEntity coin}) {
    return AboutCoinContent(
      coin: coin,
      details: const {
        'description': {'en': 'This is placeholder text for the skeleton loader that spans multiple lines to make it look like real content is loading.'},
        'links': {'homepage': ['https://example.com'], 'twitter_screen_name': 'example'},
        'market_data': {
          'market_cap': {'usd': 1000000000},
          'circulating_supply': 19000000,
          'total_supply': 21000000,
        },
        'genesis_date': '2009-01-03',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = details['description']?['en'] ?? 'No description available for ${coin.name}.';

    // Links
    final links = details['links'] ?? {};
    final homepage = (links['homepage'] as List<dynamic>?)
        ?.firstWhere((url) => url.toString().isNotEmpty, orElse: () => '') as String?;
    final twitterHandle = links['twitter_screen_name'] as String?;

    // Market Data
    final marketData = details['market_data'] ?? {};
    final mcap = marketData['market_cap']?['usd'] as num? ?? 0;
    final circSupply = marketData['circulating_supply'] as num? ?? 0;
    final totalSupply = marketData['total_supply'] as num? ?? 0;
    final genesisDateStr = details['genesis_date'] as String?;

    final currencyFormatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final compactFormatter = NumberFormat.compact();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          _cleanHtml(description),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 24),

        // Action Chips (Website, Twitter)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (homepage != null && homepage.isNotEmpty)
              _ActionChip(
                icon: Icons.language,
                label: 'Website',
                onTap: () => _launchUrl(homepage),
              ),
            if (twitterHandle != null && twitterHandle.isNotEmpty)
              _ActionChip(
                icon: Icons.alternate_email,
                label: 'Twitter',
                onTap: () => _launchUrl('https://twitter.com/$twitterHandle'),
              ),
          ],
        ),
        const SizedBox(height: 32),

        // Token Info Group — reuses the ProfileMenuGroup card style
        Text(
          'Token Info',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TokenInfoGroup(
          items: [
            TokenInfoItem(label: 'Market Cap', value: currencyFormatter.format(mcap)),
            TokenInfoItem(label: 'Circulating Supply', value: compactFormatter.format(circSupply)),
            TokenInfoItem(
              label: 'Total Supply',
              value: totalSupply > 0 ? compactFormatter.format(totalSupply) : '∞',
            ),
            if (genesisDateStr != null && genesisDateStr.isNotEmpty)
              TokenInfoItem(label: 'Created', value: genesisDateStr),
          ],
        ),
      ],
    );
  }

  String _cleanHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('\r\n', '\n')
        .trim();
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
