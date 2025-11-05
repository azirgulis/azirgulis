import 'package:flutter/material.dart';

enum AvatarItemCategory {
  background,
  skin,
  hair,
  eyes,
  outfit,
  accessory,
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int coinPrice;
  final int? gemPrice;
  final AvatarItemCategory category;
  final IconData icon;
  final Color color;
  final bool isDefault;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.coinPrice,
    this.gemPrice,
    required this.category,
    required this.icon,
    required this.color,
    this.isDefault = false,
  });
}

class ShopItems {
  // Backgrounds
  static const List<ShopItem> backgrounds = [
    ShopItem(
      id: 'bg_default',
      name: 'Classic Blue',
      description: 'Default background',
      coinPrice: 0,
      category: AvatarItemCategory.background,
      icon: Icons.circle,
      color: Color(0xFF3498DB),
      isDefault: true,
    ),
    ShopItem(
      id: 'bg_red',
      name: 'Passionate Red',
      description: 'Bold and confident',
      coinPrice: 100,
      category: AvatarItemCategory.background,
      icon: Icons.circle,
      color: Color(0xFFE74C3C),
    ),
    ShopItem(
      id: 'bg_green',
      name: 'Fresh Green',
      description: 'Nature and growth',
      coinPrice: 100,
      category: AvatarItemCategory.background,
      icon: Icons.circle,
      color: Color(0xFF2ECC71),
    ),
    ShopItem(
      id: 'bg_purple',
      name: 'Royal Purple',
      description: 'Luxurious and creative',
      coinPrice: 150,
      category: AvatarItemCategory.background,
      icon: Icons.circle,
      color: Color(0xFF9B59B6),
    ),
    ShopItem(
      id: 'bg_gold',
      name: 'Golden Glow',
      description: 'Premium shine',
      coinPrice: 250,
      category: AvatarItemCategory.background,
      icon: Icons.circle,
      color: Color(0xFFF39C12),
    ),
    ShopItem(
      id: 'bg_gradient',
      name: 'Rainbow Gradient',
      description: 'Colorful and unique',
      coinPrice: 500,
      gemPrice: 5,
      category: AvatarItemCategory.background,
      icon: Icons.gradient,
      color: Color(0xFFE91E63),
    ),
  ];

  // Hair Styles
  static const List<ShopItem> hairStyles = [
    ShopItem(
      id: 'hair_default',
      name: 'Classic',
      description: 'Simple and clean',
      coinPrice: 0,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFF34495E),
      isDefault: true,
    ),
    ShopItem(
      id: 'hair_short',
      name: 'Short Cut',
      description: 'Professional look',
      coinPrice: 150,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFF8B4513),
    ),
    ShopItem(
      id: 'hair_long',
      name: 'Long Waves',
      description: 'Flowing and elegant',
      coinPrice: 200,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFFFFD700),
    ),
    ShopItem(
      id: 'hair_spiky',
      name: 'Spiky',
      description: 'Bold and edgy',
      coinPrice: 250,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFFFF4500),
    ),
    ShopItem(
      id: 'hair_curly',
      name: 'Curly',
      description: 'Fun and bouncy',
      coinPrice: 300,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFF8B4513),
    ),
    ShopItem(
      id: 'hair_rainbow',
      name: 'Rainbow Hair',
      description: 'Stand out from the crowd',
      coinPrice: 800,
      gemPrice: 10,
      category: AvatarItemCategory.hair,
      icon: Icons.face,
      color: Color(0xFFFF1493),
    ),
  ];

  // Outfits
  static const List<ShopItem> outfits = [
    ShopItem(
      id: 'outfit_casual',
      name: 'Casual Wear',
      description: 'Comfortable everyday style',
      coinPrice: 0,
      category: AvatarItemCategory.outfit,
      icon: Icons.checkroom,
      color: Color(0xFF95A5A6),
      isDefault: true,
    ),
    ShopItem(
      id: 'outfit_business',
      name: 'Business Suit',
      description: 'Professional attire',
      coinPrice: 300,
      category: AvatarItemCategory.outfit,
      icon: Icons.business_center,
      color: Color(0xFF34495E),
    ),
    ShopItem(
      id: 'outfit_sporty',
      name: 'Athletic Gear',
      description: 'Ready for action',
      coinPrice: 250,
      category: AvatarItemCategory.outfit,
      icon: Icons.sports,
      color: Color(0xFF3498DB),
    ),
    ShopItem(
      id: 'outfit_formal',
      name: 'Formal Evening',
      description: 'Elegant and sophisticated',
      coinPrice: 500,
      category: AvatarItemCategory.outfit,
      icon: Icons.stars,
      color: Color(0xFF2C3E50),
    ),
    ShopItem(
      id: 'outfit_tech',
      name: 'Tech Startup',
      description: 'Silicon Valley style',
      coinPrice: 400,
      category: AvatarItemCategory.outfit,
      icon: Icons.computer,
      color: Color(0xFF16A085),
    ),
    ShopItem(
      id: 'outfit_ceo',
      name: 'CEO Executive',
      description: 'Top-level leadership',
      coinPrice: 1000,
      gemPrice: 15,
      category: AvatarItemCategory.outfit,
      icon: Icons.workspace_premium,
      color: Color(0xFFD4AF37),
    ),
  ];

  // Accessories
  static const List<ShopItem> accessories = [
    ShopItem(
      id: 'acc_none',
      name: 'No Accessory',
      description: 'Keep it simple',
      coinPrice: 0,
      category: AvatarItemCategory.accessory,
      icon: Icons.circle_outlined,
      color: Color(0xFF95A5A6),
      isDefault: true,
    ),
    ShopItem(
      id: 'acc_glasses',
      name: 'Glasses',
      description: 'Smart and stylish',
      coinPrice: 150,
      category: AvatarItemCategory.accessory,
      icon: Icons.visibility,
      color: Color(0xFF34495E),
    ),
    ShopItem(
      id: 'acc_sunglasses',
      name: 'Sunglasses',
      description: 'Cool and confident',
      coinPrice: 200,
      category: AvatarItemCategory.accessory,
      icon: Icons.wb_sunny,
      color: Color(0xFF2C3E50),
    ),
    ShopItem(
      id: 'acc_hat',
      name: 'Baseball Cap',
      description: 'Casual cool',
      coinPrice: 175,
      category: AvatarItemCategory.accessory,
      icon: Icons.sports_baseball,
      color: Color(0xFFE74C3C),
    ),
    ShopItem(
      id: 'acc_headphones',
      name: 'Headphones',
      description: 'Music lover',
      coinPrice: 250,
      category: AvatarItemCategory.accessory,
      icon: Icons.headphones,
      color: Color(0xFF3498DB),
    ),
    ShopItem(
      id: 'acc_crown',
      name: 'Crown',
      description: 'Royalty status',
      coinPrice: 500,
      category: AvatarItemCategory.accessory,
      icon: Icons.diamond,
      color: Color(0xFFFFD700),
    ),
    ShopItem(
      id: 'acc_trophy',
      name: 'Winner Trophy',
      description: 'Champion badge',
      coinPrice: 1500,
      gemPrice: 20,
      category: AvatarItemCategory.accessory,
      icon: Icons.emoji_events,
      color: Color(0xFFD4AF37),
    ),
  ];

  static List<ShopItem> getAllItems() {
    return [
      ...backgrounds,
      ...hairStyles,
      ...outfits,
      ...accessories,
    ];
  }

  static List<ShopItem> getByCategory(AvatarItemCategory category) {
    return getAllItems().where((item) => item.category == category).toList();
  }

  static ShopItem? getById(String id) {
    try {
      return getAllItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  static String getCategoryLabel(AvatarItemCategory category) {
    switch (category) {
      case AvatarItemCategory.background:
        return 'Backgrounds';
      case AvatarItemCategory.skin:
        return 'Skin Tones';
      case AvatarItemCategory.hair:
        return 'Hair Styles';
      case AvatarItemCategory.eyes:
        return 'Eyes';
      case AvatarItemCategory.outfit:
        return 'Outfits';
      case AvatarItemCategory.accessory:
        return 'Accessories';
    }
  }

  static IconData getCategoryIcon(AvatarItemCategory category) {
    switch (category) {
      case AvatarItemCategory.background:
        return Icons.wallpaper;
      case AvatarItemCategory.skin:
        return Icons.palette;
      case AvatarItemCategory.hair:
        return Icons.face;
      case AvatarItemCategory.eyes:
        return Icons.remove_red_eye;
      case AvatarItemCategory.outfit:
        return Icons.checkroom;
      case AvatarItemCategory.accessory:
        return Icons.star;
    }
  }
}
