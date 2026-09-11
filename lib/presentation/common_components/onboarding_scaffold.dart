import 'package:flutter/material.dart';
import '../../values/app_colors.dart';

/// Shared onboarding chrome: back button + step progress bar + step counter.
class OnboardingScaffold extends StatelessWidget {
  final int step;
  final int totalSteps;
  final Widget child;
  final Widget bottom;
  final bool showBack;

  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.child,
    required this.bottom,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  if (showBack)
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.heading),
                    )
                  else
                    const SizedBox(width: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: step / totalSteps,
                        minHeight: 6,
                        backgroundColor: AppColors.trackBg,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$step/$totalSteps',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: child),
              const SizedBox(height: 8),
              bottom,
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
