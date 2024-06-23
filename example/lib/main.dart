import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook_example/common/logo_widget.dart';
import 'package:flutter_storybook_example/routing/route_aware_stories.dart';
import 'package:flutter_storybook_example/stories/counter_page.dart';
import 'package:flutter_storybook_example/stories/scaffold_page.dart';

void main() {
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Home',
        plugins: initializePlugins(
          enableCodeView: false,
          initialDeviceFrameData: (
            isFrameVisible: true,
            device: Devices.ios.iPhone12ProMax,
            orientation: Orientation.portrait
          ),
          enableDirectionality: false,
          enableTimeDilation: false,
        ),
        routeWrapperBuilder: RouteWrapperBuilder(title: 'Storybook'),
        logoWidget: const LogoWidget(),
        brandingWidget: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Storybook'),
          ),
        ),
        stories: [
          ...routeAwareStories,
          Story(
            name: 'Screens/Scaffold',
            builder: (context) => const ScaffoldPage(),
          ),
          Story(
            name: 'Screens/Counter',
            description: 'Counter app with dialog.',
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
            description: 'Story with a longer description example.',
            builder: (context) => const Center(child: Text('Simple text')),
          ),
        ],
      );
}
