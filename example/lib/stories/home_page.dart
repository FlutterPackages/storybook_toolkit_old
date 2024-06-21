import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String homePagePath = '/home';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () => showAboutDialog(
                context: context,
                applicationName: 'Storybook',
                applicationVersion: '0.0.1',
                applicationIcon: const Icon(Icons.book),
                applicationLegalese: 'MIT License',
              ),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text('This is Storybook home page'),
              ],
            ),
          ),
        ),
      );
}
