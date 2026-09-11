import 'package:flutter/material.dart';
import '../../values/app_colors.dart';

class PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  const PlaceholderTab({super.key, required this.title, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primaryTintSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 42, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.heading)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}
