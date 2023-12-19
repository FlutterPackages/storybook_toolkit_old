import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.text(
      label: 'Third page title',
      initial: 'Third page title',
      description: 'The title of the app bar.',
    );

    final elevation = context.knobs.nullable.slider(
      label: 'Third page app bar elevation',
      initial: 4,
      min: 0,
      max: 10,
      description: 'Elevation of the app bar.',
    );

    final backgroundColor = context.knobs.nullable.options(
      label: 'AppBar color',
      initial: Colors.blue,
      description: 'Color of the app bar.',
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

    return Scaffold(
      appBar: AppBar(
        elevation: elevation,
        backgroundColor: backgroundColor,
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(secondRoute);
            Storybook.storyRouterNotifier.currentStoryRoute = secondRoute;
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
              ),
              SizedBox(width: 4),
              Text('Go to Second page'),
            ],
          ),
        ),
      ),
    );
  }
}
