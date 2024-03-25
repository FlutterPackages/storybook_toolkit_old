import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'Third Page title',
      description: 'Title for Third Page app bar.',
    );

    final backgroundColorKnob = context.knobs.nullable.options(
      label: 'AppBar color',
      initial: Colors.deepPurple.shade100,
      description: 'Color for Third Page app bar.',
      options: [
        Option(
          label: 'Deep Purple 100',
          value: Colors.deepPurple.shade100,
        ),
        const Option(
          label: 'Deep Purple',
          value: Colors.deepPurple,
        ),
      ],
    );

    final borderRadiusKnob = context.knobs.nullable.sliderInt(
      label: 'borderRadius',
      description: 'Border radius for Third Page button.',
      initial: 8,
      max: 32,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorKnob,
        title: Text(titleKnob),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.deepPurple.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadiusKnob != null ? borderRadiusKnob.toDouble() : 8,
            ),
          ),
          onPressed: () {
            context.go(secondPagePath);
            Storybook.storyRouterNotifier.currentStoryRoute = secondPagePath;
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.navigate_before,
                size: 16,
              ),
              SizedBox(width: 4),
              Text('Go to Second Page'),
            ],
          ),
        ),
      ),
    );
  }
}
