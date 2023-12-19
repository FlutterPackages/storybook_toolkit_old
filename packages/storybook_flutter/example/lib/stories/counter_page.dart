import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

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
    final title = context.knobs.text(
      label: 'Title',
      initial: 'Counter',
    );

    final enabled = context.knobs.boolean(
      label: 'Enabled',
      initial: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
      floatingActionButton: enabled
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
