import 'package:flutter/material.dart';
import '../../models/ui_models/category_catalog.dart';

/// Rounded tinted square holding a category icon (Figma transaction rows).
class CategoryBadge extends StatelessWidget {
  final String categoryKey;
  final double size;

  const CategoryBadge({super.key, required this.categoryKey, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final meta = CategoryCatalog.meta(categoryKey);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(meta.icon, color: meta.color, size: size * 0.5),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const IconBadge({super.key, required this.icon, required this.color, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
