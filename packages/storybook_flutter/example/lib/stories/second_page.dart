import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

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
          onPressed: () => context.go(firstPagePath),
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
