import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_list_tile.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

/// A dedicated slide-up asset picker sheet with search.
/// Returns the selected coin ID when tapped, or null if dismissed.
class AssetPickerSheet extends HookConsumerWidget {
  final bool isSell;

  const AssetPickerSheet({super.key, this.isSell = false});

  /// Shows the picker as a new modal sheet layered on top of the current sheet.
  static Future<String?> show(BuildContext context, {bool isSell = false}) {
    return Navigator.of(context, rootNavigator: true).push<String>(
      StupidSimpleCupertinoSheetRoute<String>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        snappingConfig:
            SheetSnappingConfig([0.85], initialSnap: 0.85),
        child: _AssetPickerWrapper(isSell: isSell),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final searchController = useTextEditingController();
    final searchQuery = useState('');

    final marketsState = ref.watch(marketsProvider);
    var markets = marketsState.value ?? [];

    final walletState = ref.watch(walletStreamProvider);
    final wallet = walletState.value;

    if (isSell && wallet != null) {
      markets = List.from(markets)..sort((a, b) {
        final aIndex = wallet.assets.indexWhere((asset) => asset.coinId == a.id);
        final bIndex = wallet.assets.indexWhere((asset) => asset.coinId == b.id);
        
        final aAmount = aIndex >= 0 ? wallet.assets[aIndex].amount.toDouble() : 0.0;
        final bAmount = bIndex >= 0 ? wallet.assets[bIndex].amount.toDouble() : 0.0;
        
        if (aAmount > 0 && bAmount == 0) return -1;
        if (bAmount > 0 && aAmount == 0) return 1;
        
        if (aAmount > 0 && bAmount > 0) {
          final aValue = aAmount * a.currentPrice.toDouble();
          final bValue = bAmount * b.currentPrice.toDouble();
          return bValue.compareTo(aValue);
        }
        
        return 0;
      });
    }

    // Filter markets by search query and exclude tether
    final filteredMarkets = markets.where((coin) {
      if (coin.id == 'tether') return false;
      if (searchQuery.value.isEmpty) return true;
      final q = searchQuery.value.toLowerCase();
      return coin.name.toLowerCase().contains(q) ||
          coin.symbol.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Material(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header: Back button + Title
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Select Asset',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: searchController,
                onChanged: (v) => searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: 'Search coins...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: 12),

            // Coin list
            if (markets.isEmpty)
              const Expanded(
                  child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredMarkets.length,
                  itemBuilder: (context, index) {
                    final coin = filteredMarkets[index];
                    
                    final assetIndex = wallet?.assets.indexWhere((a) => a.coinId == coin.id) ?? -1;
                    final walletAmount = assetIndex >= 0 ? wallet!.assets[assetIndex].amount.toDouble() : 0.0;

                    return InkWell(
                      onTap: () => Navigator.of(context).pop(coin.id),
                      child: CoinListTile(
                        coin: coin,
                        walletAmount: isSell ? walletAmount : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper to provide SafeArea at the bottom for the picker content.
class _AssetPickerWrapper extends StatelessWidget {
  final bool isSell;

  const _AssetPickerWrapper({this.isSell = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AssetPickerSheet(isSell: isSell),
    );
  }
}
