import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_test/devices.dart';
import 'package:storybook_flutter_test/storybook_flutter_test.dart';

import '../example/counter_page.dart';

void main() => testStorybook(
      storybook,
      devices: {Device.iPhone8, Device.iPhone13, Device.pixel5, Device.iPadPro},
      filterStories: (Story story) {
        final skipStories = ['Button'];
        return !skipStories.contains(story.name);
      },
    );

final storybook = Storybook(
  stories: [
    Story(
      name: 'Button',
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const Text('Button123'),
      ),
    ),
    Story(
      name: 'CounterPage',
      builder: (context) => CounterPage(),
    ),
  ],
  showPanel: true,
  plugins: initializePlugins(
    enableCodeView: false,
    enableDirectionality: false,
    enableTimeDilation: false,
  ),
);
