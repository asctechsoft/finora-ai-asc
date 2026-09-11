import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../values/app_colors.dart';

class HomeHeroCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String amount;
  final String budget;
  final VoidCallback onTap;

  const HomeHeroCard({
    super.key,
    required this.label,
    required this.icon,
    required this.amount,
    required this.budget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9))),
                      const SizedBox(width: 4),
                      Icon(Icons.info_outline_rounded,
                          size: 14, color: Colors.white.withValues(alpha: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(amount,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('of_this_month'.trArgs([budget]),
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.9)),
          ],
        ),
      ),
    );
  }
}
