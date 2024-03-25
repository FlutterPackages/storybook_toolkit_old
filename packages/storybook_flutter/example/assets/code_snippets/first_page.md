import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: const Text('First Page title'),
        ),
        body: Center(
          child: MaterialButton(
            color: Colors.deepPurple.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: () {
              context.go(secondRoute);
              Storybook.storyRouterNotifier.currentStoryRoute = secondRoute;
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Go to Second Page'),
                SizedBox(width: 4),
                Icon(
                  Icons.navigate_next,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
}