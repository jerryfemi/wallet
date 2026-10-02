import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_price_header.dart';
import 'package:wallet/features/markets/presentation/widgets/compact_coin_price_header.dart';

class CoinSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final CoinEntity coin;
  final double expandedHeight;
  final double collapsedHeight;

  CoinSliverHeaderDelegate({
    required this.coin,
    required this.expandedHeight,
    required this.collapsedHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate progress from 0.0 (fully expanded) to 1.0 (fully collapsed)
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    // Large header fades out early (from 0.0 to 0.7 progress)
    final largeOpacity = (1.0 - (progress / 0.7)).clamp(0.0, 1.0);
    
    // Compact header fades in late (from 0.7 to 1.0 progress)
    final compactOpacity = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);

    // As we scroll, increase the background opacity to create a frosted glass effect
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final blurAmount = progress * 15.0; // Increased blur for better frost

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          // Lowered peak alpha to 0.65 so more of the scrolling content is visible underneath
          color: backgroundColor.withValues(alpha: progress * 0.65),
          child: SafeArea(
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded Large Header (Fades out as header shrinks)
                // ClipRect on the parent clips it as it slides behind the toolbar
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: IgnorePointer(
                    ignoring: largeOpacity == 0.0,
                    child: Opacity(
                      opacity: largeOpacity,
                      child: CoinPriceHeader(coin: coin),
                    ),
                  ),
                ),

                // Pinned Top Elements (Back button + Logo)
                Positioned(
                  top: 0,
                  left: 0,
                  height: collapsedHeight - MediaQuery.paddingOf(context).top,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: CachedNetworkImageProvider(
                          coin.imageUrl,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),

                // Compact Title (Centered)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: collapsedHeight - MediaQuery.paddingOf(context).top,
                  child: IgnorePointer(
                    child: Center(
                      child: Opacity(
                        opacity: compactOpacity,
                        child: CompactCoinPriceHeader(coin: coin),
                      ),
                    ),
                  ),
                ),

                // Top Right Action (Receive)
                Positioned(
                  top: 0,
                  right: 8,
                  height: collapsedHeight - MediaQuery.paddingOf(context).top,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.qr_code_2_rounded),
                      onPressed: () {
                        context.push(
                          '${Routes.receive}/${coin.id}',
                          extra: coin,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant CoinSliverHeaderDelegate oldDelegate) {
    return coin != oldDelegate.coin ||
        expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight;
  }
}
