import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_toolkit_example/stories/home_page.dart';

class RoutingErrorWidget extends StatelessWidget {
  const RoutingErrorWidget({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('404'),
              const SizedBox(height: 16),
              const Text('Page not found'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(HomePage.homePagePath),
                child: const Text('Go back home'),
              ),
            ],
          ),
        ),
      );
}
