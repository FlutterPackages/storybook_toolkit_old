import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blue,
        title: Text('Third page title'),
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