import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/shop/shop_items.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../core/theme/app_colors.dart';

class AvatarShopScreen extends ConsumerStatefulWidget {
  const AvatarShopScreen({super.key});

  @override
  ConsumerState<AvatarShopScreen> createState() => _AvatarShopScreenState();
}

class _AvatarShopScreenState extends ConsumerState<AvatarShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Set<String> _ownedItems = {'bg_default', 'hair_default', 'outfit_casual', 'acc_none'};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // TODO: Load owned items from user profile
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _purchaseItem(ShopItem item, bool useGems) async {
    final progressAsync = ref.read(userProgressProvider);
    if (!progressAsync.hasValue || progressAsync.value == null) return;

    final progress = progressAsync.value!;

    // Check if can afford
    if (useGems && item.gemPrice != null) {
      if (progress.gems < item.gemPrice!) {
        _showInsufficientFundsDialog('gems', item.gemPrice!);
        return;
      }
    } else {
      if (progress.coins < item.coinPrice) {
        _showInsufficientFundsDialog('coins', item.coinPrice);
        return;
      }
    }

    // Confirm purchase
    final confirmed = await _showPurchaseConfirmDialog(item, useGems);
    if (confirmed != true) return;

    // Deduct currency
    if (useGems && item.gemPrice != null) {
      await ref.read(userProgressProvider.notifier).spendGems(item.gemPrice!);
    } else {
      await ref.read(userProgressProvider.notifier).spendCoins(item.coinPrice);
    }

    // Add to owned items
    setState(() {
      _ownedItems.add(item.id);
    });

    // TODO: Save to user profile in Firestore

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} purchased!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  Future<bool?> _showPurchaseConfirmDialog(ShopItem item, bool useGems) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${item.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  useGems ? Icons.diamond : Icons.monetization_on,
                  color: useGems ? AppColors.gemsColor : AppColors.coinsColor,
                ),
                const SizedBox(width: 8),
                Text(
                  useGems && item.gemPrice != null
                      ? '${item.gemPrice} gems'
                      : '${item.coinPrice} coins',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  useGems ? AppColors.gemsColor : AppColors.coinsColor,
            ),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _showInsufficientFundsDialog(String currency, int amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insufficient Funds'),
        content: Text(
          'You need $amount $currency to purchase this item. Keep learning to earn more!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Shop'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              icon: Icon(ShopItems.getCategoryIcon(AvatarItemCategory.background)),
              text: 'Backgrounds',
            ),
            Tab(
              icon: Icon(ShopItems.getCategoryIcon(AvatarItemCategory.hair)),
              text: 'Hair',
            ),
            Tab(
              icon: Icon(ShopItems.getCategoryIcon(AvatarItemCategory.outfit)),
              text: 'Outfits',
            ),
            Tab(
              icon: Icon(ShopItems.getCategoryIcon(AvatarItemCategory.accessory)),
              text: 'Accessories',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Currency display
          progressAsync.when(
            data: (progress) {
              if (progress == null) return const SizedBox();
              return Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCurrencyChip(
                      Icons.monetization_on,
                      progress.coins.toString(),
                      AppColors.coinsColor,
                    ),
                    const SizedBox(width: 24),
                    _buildCurrencyChip(
                      Icons.diamond,
                      progress.gems.toString(),
                      AppColors.gemsColor,
                    ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          // Shop items
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemGrid(ShopItems.backgrounds),
                _buildItemGrid(ShopItems.hairStyles),
                _buildItemGrid(ShopItems.outfits),
                _buildItemGrid(ShopItems.accessories),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyChip(IconData icon, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid(List<ShopItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isOwned = _ownedItems.contains(item.id);
        return _buildItemCard(item, isOwned);
      },
    );
  }

  Widget _buildItemCard(ShopItem item, bool isOwned) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: isOwned
            ? null
            : () {
                // Show purchase options
                if (item.gemPrice != null) {
                  _showPurchaseOptionsDialog(item);
                } else {
                  _purchaseItem(item, false);
                }
              },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item icon
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.color.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          size: 48,
                          color: item.color,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Item name
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Item description
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Price
                  if (!isOwned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.coinsColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 16,
                            color: AppColors.coinsColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.coinPrice.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.coinsColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Owned badge
            if (isOwned)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

            // Premium badge
            if (item.gemPrice != null && !isOwned)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gemsColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseOptionsDialog(ShopItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.description),
            const SizedBox(height: 16),
            Text(
              'Choose payment method:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _purchaseItem(item, false);
            },
            icon: Icon(Icons.monetization_on, color: AppColors.coinsColor),
            label: Text('${item.coinPrice} Coins'),
          ),
          if (item.gemPrice != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _purchaseItem(item, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gemsColor,
              ),
              icon: const Icon(Icons.diamond),
              label: Text('${item.gemPrice} Gems'),
            ),
        ],
      ),
    );
  }
}
