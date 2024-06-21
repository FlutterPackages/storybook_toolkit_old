import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'core/device.dart';
import 'core/golden_test_device_scenario.dart';
import 'lib_test.dart';

void main() {
  group('ListTile Golden Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'list_tile',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 600),
        children: [
          GoldenTestScenario(
            name: 'with title',
            child: ListTile(
              title: Text('ListTile.title'),
            ),
          ),
          GoldenTestScenario(
            name: 'with title and subtitle',
            child: ListTile(
              title: Text('ListTile.title'),
              subtitle: Text('ListTile.subtitle'),
            ),
          ),
          GoldenTestScenario(
            name: 'with trailing icon',
            child: ListTile(
              title: Text('ListTile.title'),
              trailing: Icon(Icons.chevron_right_rounded),
            ),
          ),
        ],
      ),
    );
  });

  group('Alchemist Golden Tests', () {
    Widget buildWidgetUnderTest() => const MyApp();
    goldenTest(
      'golden test',
      fileName: 'test_page',
      builder: () => GoldenTestGroup(
          children: [
            GoldenTestDeviceScenario(
              device: Device.smallPhone,
              name: 'golden test ErrorPage on small phone',
              builder: buildWidgetUnderTest,
            ),
            GoldenTestDeviceScenario(
              device: Device.tabletLandscape,
              name: 'golden test ErrorPage on tablet',
              builder: buildWidgetUnderTest,
            ),
          ],
        ),
    );
  });
}
