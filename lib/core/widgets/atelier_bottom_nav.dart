import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_ecommerce/core/constants/app_colors.dart';
import 'package:mine_ecommerce/features/cart/controller/cart_controller.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

enum AtelierNavTab { home, search, cart, profile }

class AtelierBottomNav extends StatelessWidget {
  const AtelierBottomNav({
    super.key,
    required this.current,
    this.useHomeHighlightStyle = true,
  });

  final AtelierNavTab current;
  final bool useHomeHighlightStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Item(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                selected: current == AtelierNavTab.home,
                highlighted:
                    useHomeHighlightStyle && current == AtelierNavTab.home,
                onTap: () => Get.offNamed(AppRoutes.home),
              ),
              _Item(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: 'Search',
                selected: current == AtelierNavTab.search,
                highlighted:
                    useHomeHighlightStyle && current == AtelierNavTab.search,
                onTap: () => Get.offNamed(AppRoutes.search),
              ),
              GetBuilder<CartController>(
                builder: (c) => _Item(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: 'Cart',
                  selected: current == AtelierNavTab.cart,
                  highlighted:
                      useHomeHighlightStyle && current == AtelierNavTab.cart,
                  badge: c.itemCount > 0 ? c.itemCount : null,
                  onTap: () => Get.offNamed(AppRoutes.cart),
                ),
              ),
              _Item(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                selected: current == AtelierNavTab.profile,
                highlighted:
                    useHomeHighlightStyle && current == AtelierNavTab.profile,
                onTap: () => Get.offNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.highlighted,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool highlighted;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final active = selected;
    final color = active ? AppColors.navy : AppColors.textMuted;

    Widget iconWidget = Icon(
      active ? activeIcon : icon,
      color: highlighted ? Colors.white : color,
      size: 24,
    );

    if (highlighted) {
      iconWidget = Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          shape: BoxShape.circle,
        ),
        child: Icon(active ? activeIcon : icon, color: Colors.white, size: 22),
      );
    }

    if (badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -2,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.navy : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
