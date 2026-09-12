import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trackflow/presentation/common_components/primary_button.dart';

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );

void main() {
  testWidgets('fires onPressed and shows an ink response', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(PrimaryButton(label: 'Go', onPressed: () => taps++)));

    expect(find.byType(InkWell), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });

  testWidgets('scales down while held and restores on release', (tester) async {
    await tester.pumpWidget(_host(PrimaryButton(label: 'Go', onPressed: () {})));

    double scale() => tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
    expect(scale(), 1);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(PrimaryButton)));
    await tester.pump(const Duration(milliseconds: 150));
    expect(scale(), lessThan(1), reason: 'button should visibly press down');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(scale(), 1);
  });

  testWidgets('disabled button ignores taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(PrimaryButton(label: 'Go', enabled: false, onPressed: () => taps++)),
    );

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(taps, 0);
  });
}
