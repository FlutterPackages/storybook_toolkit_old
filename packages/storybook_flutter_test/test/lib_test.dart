import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_test/storybook_flutter_test.dart';

void main() => testStorybook(
      storybook,
      layouts: [
        (
          device: Devices.android.mediumTablet,
          orientation: Orientation.landscape,
          isFrameVisible: true,
        ),
        (
          device: Devices.android.smallPhone,
          orientation: Orientation.portrait,
          isFrameVisible: true,
        ),
        (
          device: Devices.ios.iPhone13,
          orientation: Orientation.portrait,
          isFrameVisible: true,
        ),
        (
          device: Devices.ios.iPadPro11Inches,
          orientation: Orientation.landscape,
          isFrameVisible: true,
        ),
        (
          device: Devices.android.samsungGalaxyA50,
          orientation: Orientation.portrait,
          isFrameVisible: true,
        ),
      ],
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
      builder: (context) => CounterPage(),
    ),
  ],
);

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'Counter Page title',
      description: 'Title for Counter Page app bar.',
    );

    final enabledKnob = context.knobs.boolean(
      label: 'FAB enabled',
      description: 'Whether the FAB is enabled.',
      initial: true,
    );

    final sizeKnob = context.knobs.boolean(
      label: 'mini',
      description: 'Whether the FAB is mini.',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(titleKnob),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Storybook',
              applicationVersion: '0.0.1',
              applicationIcon: const Icon(Icons.book),
              applicationLegalese: 'MIT License',
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: sizeKnob,
        tooltip: 'Increment',
        onPressed: enabledKnob ? _incrementCounter : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
