import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finora/values/app_colors.dart';

void main() {
  test('Design tokens are defined', () {
    expect(AppColors.primary, isA<Color>());
    expect(AppColors.heroGradient.colors.length, greaterThan(1));
  });
}
