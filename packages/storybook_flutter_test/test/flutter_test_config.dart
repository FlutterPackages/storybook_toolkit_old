import 'dart:async';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    //..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants({
      iPhone13,
      pixel5,
    });
  await loadFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
