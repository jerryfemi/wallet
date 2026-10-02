import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_chart_section.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_sliver_header_delegate.dart';
import 'package:wallet/features/markets/presentation/widgets/market_stats_section.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_news_section.dart';

import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';
import 'package:wallet/features/markets/presentation/widgets/trade_bottom_bar.dart';
import 'package:wallet/shared/widgets/action_pill.dart';

class CoinDetailsScreen extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinDetailsScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: CoinSliverHeaderDelegate(
                  coin: coin,
                  expandedHeight: 240.0,
                  collapsedHeight:
                      kToolbarHeight + MediaQuery.paddingOf(context).top,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Charts
                      CoinChartSection(coin: coin),
                      const SizedBox(height: 24),

                      // Actions: Send & Receive
                      Row(
                        children: [
                          Expanded(
                            child: ActionPill(
                              label: 'Send',
                              icon: Icons.arrow_upward_rounded,
                              onTap: () {
                                context.push('${Routes.send}/${coin.id}', extra: coin);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ActionPill(
                              label: 'Receive',
                              icon: Icons.arrow_downward_rounded,
                              onTap: () {
                                context.push('${Routes.receive}/${coin.id}', extra: coin);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      MarketStatsSection(coin: coin),
                      const SizedBox(height: 32),

                      CoinNewsSection(coin: coin),
                      // Extra padding at the bottom to account for the sticky bottom bar
                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TradeBottomBar(coin: coin),
          ),
        ],
      ),
    );
  }
}


