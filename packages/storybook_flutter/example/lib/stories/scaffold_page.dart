import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ScaffoldPage extends StatelessWidget {
  const ScaffoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.text(
      label: 'Title',
      initial: 'Scaffold',
      description: 'The title of the app bar.',
    );

    final elevation = context.knobs.nullable.slider(
      label: 'AppBar elevation',
      initial: 4,
      min: 0,
      max: 10,
      description: 'Elevation of the app bar.',
    );

    final backgroundColor = context.knobs.nullable.options(
      label: 'AppBar color',
      initial: Colors.blue,
      description: 'Background color of the app bar.',
      options: const [
        Option(
          label: 'Blue',
          value: Colors.blue,
          description: 'Blue color',
        ),
        Option(
          label: 'Green',
          value: Colors.green,
          description: 'Green color',
        ),
      ],
    );

    final itemCount = context.knobs.sliderInt(
      label: 'Items count',
      initial: 2,
      min: 1,
      max: 5,
      description: 'Number of items in the body container.',
    );

    final showFab = context.knobs.boolean(
      label: 'FAB',
      initial: true,
      description: 'Show FAB button',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: elevation,
        backgroundColor: backgroundColor,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            itemCount,
            (int _) => const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Hello World!'),
            ),
          ),
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
