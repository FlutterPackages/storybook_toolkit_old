import 'package:flutter/material.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  static String colorsPagePath = '/pages/colors';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Colors'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 50, width: 50, color: Colors.red),
                    Container(height: 50, width: 50, color: Colors.orange),
                    Container(height: 50, width: 50, color: Colors.indigo),
                    Container(height: 50, width: 50, color: Colors.teal),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 50, width: 50, color: Colors.redAccent),
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.orangeAccent,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.indigoAccent,
                    ),
                    Container(height: 50, width: 50, color: Colors.tealAccent),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
