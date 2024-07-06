import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_example/stories/first_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  static String secondPagePath = '/routing/second_page';

  @override
  Widget build(BuildContext context) {
    final titleKnob = context.knobs.text(
      label: 'title',
      initial: 'Second Page title',
      description: 'Title for Second Page app bar.',
    );

    final elevationKnob = context.knobs.nullable.slider(
      label: 'elevation',
      initial: 4,
      max: 10,
      description: 'Elevation for Second Page app bar.',
    );

    final borderRadiusKnob = context.knobs.nullable.sliderInt(
      label: 'borderRadius',
      description: 'Border radius for Second Page button.',
      initial: 8,
      max: 32,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          onPressed: () => context.go(FirstPage.firstPagePath),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.navigate_before,
                size: 16,
              ),
              SizedBox(width: 4),
              Text('Go to First Page'),
            ],
          ),
        ),
      ),
    );
  }
}
