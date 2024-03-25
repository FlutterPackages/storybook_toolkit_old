import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ScaffoldPage extends StatelessWidget {
  const ScaffoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'Scaffold Page title',
      description: 'Title for Scaffold Page app bar.',
    );

    final elevationKnob = context.knobs.nullable.slider(
      label: 'elevation',
      initial: 4,
      min: 0,
      max: 10,
      description: 'Elevation for Scaffold Page app bar.',
    );

    final backgroundColorKnob = context.knobs.nullable.options(
      label: 'AppBar color',
      initial: Colors.blue,
      description: 'Background color for Scaffold Page app bar.',
      options: const [
        Option(
          label: 'Blue',
          value: Colors.blue,
        ),
        Option(
          label: 'Indigo Accent',
          value: Colors.indigoAccent,
        ),
      ],
    );

    final itemCountKnob = context.knobs.sliderInt(
      label: 'Items count',
      initial: 2,
      min: 1,
      max: 5,
      description: 'Number of text items to show.',
    );

    final showFabKnob = context.knobs.boolean(
      label: 'show FAB',
      description: 'Show FAB button',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(titleKnob),
        elevation: elevationKnob,
        backgroundColor: backgroundColorKnob,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            itemCountKnob,
            (int _) => const Text('Hello World!'),
          ),
        ),
      ),
      floatingActionButton: showFabKnob
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
