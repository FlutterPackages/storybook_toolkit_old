import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'lib_test.dart';

void main() {
  testAdaptiveWidgets(
    'Run adaptive test',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: const MyApp(),
        ),
      );

      await tester.expectGolden<CounterPage>(variant);
      await tester.tap(find.byKey(ValueKey("TestField")));
      await tester.pump();
      await tester.expectGolden<CounterPage>(variant);
    },
  );
}
