import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

import 'package:wallet/features/markets/presentation/widgets/asset_selection_header_delegate.dart';
import 'package:wallet/features/markets/presentation/widgets/asset_selection_sliver_list.dart';

class AssetSelectionSheet extends HookConsumerWidget {
  final CoinEntity? currentCoin;
  final void Function(CoinEntity)? onSelect;

  const AssetSelectionSheet({super.key, this.currentCoin, this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);

    return CustomScrollView(
      slivers: [
        // Pinned Header
        SliverPersistentHeader(
          pinned: true,
          delegate: AssetSelectionHeaderDelegate(),
        ),

        // Scrollable List
        marketsAsync.when(
          data: (coins) => AssetSelectionSliverList(
            coins: coins,
            selectedId: currentCoin?.id,
            onTap: (coin) {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              if (onSelect != null) {
                onSelect!(coin);
              } else {
                context.pushReplacement(Routes.coinDetails, extra: coin);
              }
            },
          ),
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
