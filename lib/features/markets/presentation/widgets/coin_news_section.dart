import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/domain/entities/news_article_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_details_provider.dart';
import 'package:wallet/app/theme/semantic_colors.dart';
import 'package:wallet/core/presentation/widgets/bouncy_touch.dart';

class CoinNewsSection extends ConsumerWidget {
  final CoinEntity coin;

  const CoinNewsSection({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(coinNewsProvider(coin.symbol));
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related News',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        newsAsync.when(
          data: (articles) {
            if (articles.isEmpty) {
              return Center(
                child: Text(
                  'No recent news available.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              );
            }
            
            // Calculate sentiment stats for subtitle
            int bullish = articles.where((a) => a.sentiment.toLowerCase() == 'bullish').length;
            int bearish = articles.where((a) => a.sentiment.toLowerCase() == 'bearish').length;
            String overallSentiment = bullish >= bearish ? 'Bullish' : 'Bearish';
            Color sentimentColor = overallSentiment == 'Bullish' 
                ? (theme.extension<AppSemanticColors>()?.positive ?? AppSemanticColors.light.positive)
                : (theme.extension<AppSemanticColors>()?.negative ?? AppSemanticColors.light.negative);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${articles.length} Sources • ',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      overallSentiment,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: sentimentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: articles.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                  ),
                  itemBuilder: (context, index) {
                    return _NewsCard(article: articles[index]);
                  },
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Failed to load news.',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticleEntity article;

  const _NewsCard({required this.article});

  Future<void> _launchUrl() async {
    final uri = Uri.parse(article.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final semanticColors = Theme.of(context).extension<AppSemanticColors>();
    final isBullish = article.sentiment.toLowerCase() == 'bullish';
    final sentimentColor = isBullish 
        ? (semanticColors?.positive ?? AppSemanticColors.light.positive) 
        : (semanticColors?.negative ?? AppSemanticColors.light.negative);

    return BouncyTouch(
      onTap: _launchUrl,
      child: Container(
        color: Colors.transparent, // Ensures the whole row is clickable
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          article.source,
                          style: TextStyle(
                            color: onSurface,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getRelativeTime(article.publishedAt),
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: TextStyle(
                      color: onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isBullish
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: sentimentColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.sentiment,
                        style: TextStyle(
                          color: sentimentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: onSurface.withValues(alpha: 0.1),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_rounded,
                    color: onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
