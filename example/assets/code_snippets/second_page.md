import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: const Text('Second Page title'),
        ),
        body: Center(
          child: MaterialButton(
            color: Colors.deepPurple.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: () => context.go(firstRoute),
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