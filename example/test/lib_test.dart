import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook_example/stories/counter_page.dart';

void main() => testStorybook(
      storybook,
      devices: {Device.iPhone8, Device.iPhone13, Device.pixel5, Device.iPadPro},
      filterStories: (Story story) {
        final skipStories = [];
        return !skipStories.contains(story.name);
      },
    );

final storybook = Storybook(
  stories: [
    Story(
      name: 'Button',
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const Text('Button'),
      ),
    ),
    Story(
      name: 'CounterPage',
      builder: (context) => const CounterPage(),
    ),
  ],
  showPanel: true,
  plugins: initializePlugins(
    enableCodeView: false,
    enableDirectionality: false,
    enableTimeDilation: false,
  ),
);
