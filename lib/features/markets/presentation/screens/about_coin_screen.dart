import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_details_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/about_coin_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AboutCoinScreen extends HookConsumerWidget {
  final CoinEntity coin;

  const AboutCoinScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDetailsAsync = ref.watch(coinDetailsProvider(coin.id));
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              'About ${coin.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: coinDetailsAsync.when(
                data: (details) => AboutCoinContent(coin: coin, details: details),
                loading: () => Skeletonizer(
                  enabled: true,
                  child: AboutCoinContent.skeleton(coin: coin),
                ),
                error: (e, st) => Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      'Failed to load coin details.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
