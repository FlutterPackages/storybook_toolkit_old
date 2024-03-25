import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'First Page title',
      description: 'Title for First Page app bar.',
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

    final buttonTextKnob = context.knobs.text(
      label: 'Button text',
      initial: 'Go to Second Page',
      description: 'Label for First Page button.',
    );

    return Scaffold(
      appBar: AppBar(
        elevation: elevationKnob,
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
    );
  }
}
