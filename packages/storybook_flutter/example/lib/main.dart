import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/route_aware_stories.dart';
import 'package:storybook_flutter_example/stories/counter_page.dart';
import 'package:storybook_flutter_example/stories/scaffold_page.dart';

void main() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Routing/First page',
        plugins: initializePlugins(enableCodeView: true),
        routeWrapperBuilder: RouteWrapperBuilder(title: 'Storybook'),
        stories: [
          ...routeAwareStories,
          Story(
            name: 'Screens/Scaffold',
            description: 'Story with scaffold and different knobs.',
            builder: (context) => const ScaffoldPage(),
          ),
          Story(
            name: 'Screens/Counter',
            description: 'Demo Counter app with about dialog.',
            builder: (context) => const CounterPage(),
          ),
          Story(
            name: 'Widgets/Text',
            description: 'Simple text widget.',
            builder: (context) => const Center(child: Text('Simple text')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Times/First',
            builder: (context) => const Center(child: Text('First')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Times/Second',
            builder: (context) => const Center(child: Text('Second')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Third',
            builder: (context) => const Center(child: Text('Third')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Fourth',
            builder: (context) => const Center(child: Text('Fourth')),
          ),
          Story(
            name: 'Story without a category',
            builder: (context) => const Center(child: Text('Simple text')),
          ),
        ],
      );
}
