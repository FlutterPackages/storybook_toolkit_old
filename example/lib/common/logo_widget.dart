import 'package:flutter/material.dart';

import 'package:storybook_flutter_example/routing/app_router.dart';
import 'package:storybook_flutter_example/stories/home_page.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Center(
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 0,
                left: 16,
                right: 16,
              ),
              child: MaterialButton(
                hoverColor: Colors.transparent,
                onPressed: () => router.go(HomePage.homePagePath),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlutterLogo(size: 50),
                    Text(
                      'Flutter',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
