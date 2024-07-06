import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_example/stories/second_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  static String firstPagePath = '/routing/first_page';

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'First Page title',
      description: 'Title for First Page app bar.',
    );

    final backgroundColorKnob = context.knobs.nullable.options(
      label: 'AppBar color',
      initial: Colors.deepPurple.shade100,
      description: 'Color for Third Page app bar.',
      options: [
        Option(
          label: 'DeepPurple 100',
          value: Colors.deepPurple.shade100,
          description: 'This is description',
        ),
        const Option(
          label: 'Deep Purple',
          value: Colors.deepPurple,
          description: 'This is description',
        ),
        const Option(
          label: 'Blue Grey',
          value: Colors.blueGrey,
        ),
        const Option(
          label: 'Blue',
          value: Colors.blue,
        ),
      ],
    );

    final buttonColorKnob = context.knobs.nullable.options(
      label: 'Button color',
      initial: Colors.orange,
      description: 'Color for Third Page button.',
      options: [
        const Option(
          label: 'Orange',
          value: Colors.orange,
        ),
        const Option(
          label: 'Blue',
          value: Colors.blue,
        ),
        const Option(
          label: 'Blue Grey',
          value: Colors.blueGrey,
        ),
        const Option(
          label: 'Light Green',
          value: Colors.lightGreen,
        ),
      ],
    );

    final fabColorKnob = context.knobs.nullable.options(
      label: 'FAB color',
      initial: Colors.pink,
      description: 'Color for Third Page FAB.',
      options: [
        const Option(
          label: 'Pink',
          value: Colors.pink,
        ),
        const Option(
          label: 'Indigo',
          value: Colors.indigo,
        ),
        const Option(
          label: 'Blue Grey',
          value: Colors.blueGrey,
        ),
        const Option(
          label: 'Lime',
          value: Colors.lime,
        ),
      ],
    );

    final elevationKnob = context.knobs.nullable.slider(
      label: 'elevation',
      initial: 4,
      max: 10,
      description: 'Elevation for First Page app bar.',
    );

    final borderRadiusKnob = context.knobs.nullable.sliderInt(
      label: 'borderRadius',
      description: 'Border radius for First Page button.',
      initial: 8,
      max: 32,
    );

    final showFabKnob = context.knobs.boolean(
      label: 'show FAB',
      description: 'Show FAB button',
    );

    final buttonTextKnob = context.knobs.text(
      label: 'Button text',
      initial: 'Go to Second Page',
      description: 'Label for First Page button.',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: elevationKnob,
        backgroundColor: backgroundColorKnob,
        title: Text(titleKnob),
      ),
      body: Center(
        child: MaterialButton(
          color: buttonColorKnob,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadiusKnob != null ? borderRadiusKnob.toDouble() : 8,
            ),
          ),
          onPressed: () => context.go(SecondPage.secondPagePath),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(buttonTextKnob),
              const SizedBox(width: 4),
              const Icon(
                Icons.navigate_next,
                size: 16,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showFabKnob
          ? FloatingActionButton(
              backgroundColor: fabColorKnob,
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
