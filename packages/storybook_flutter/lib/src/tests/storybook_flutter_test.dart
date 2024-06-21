import 'dart:async';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

@isTest
Future<void> testStorybook(
  Storybook storybook, {
  Set<Device> devices = const {Device.pixel5, Device.iPhone8, Device.iPhone13},
  bool Function(Story story)? filterStories,
}) async {
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants({
      for (Device device in devices)
        WindowConfigData(
          device.name,
          size: device.size,
          pixelDensity: device.pixelDensity,
          targetPlatform: device.targetPlatform,
          borderRadius: device.borderRadius,
          safeAreaPadding: device.safeAreaPadding,
          keyboardSize: device.keyboardSize,
          homeIndicator: device.homeIndicator,
          notchSize: device.notchSize,
          punchHole: device.punchHole,
        ),
    });
  await loadFonts();
  setupFileComparatorWithThreshold();

  for (final story in storybook.stories.where((s) => filterStories?.call(s) ?? true)) {
    testAdaptiveWidgets(
      'Run ${story.name} test',
      (tester, variant) async {
        await tester.pumpWidget(
          AdaptiveWrapper(
            windowConfig: variant,
            tester: tester,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Storybook(
                initialStory: story.name,
                showPanel: false,
                wrapperBuilder: storybook.wrapperBuilder,
                stories: storybook.stories,
              ),
            ),
          ),
        );

        //await tester.expectGolden(variant);
        //await tester.tap(find.byKey(ValueKey("TestField")));
        //await tester.pump();
        await tester.expectGolden<dynamic>(variant, pathBuilder: () => "goldens/${story.name}/${variant.name}.png");
      },
    );
  }
}
