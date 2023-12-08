import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

const firstRoute = '/routing/first_page';
const secondRoute = '/routing/second_page';
const thirdRoute = '/route/third_page';
const routing = '/routing';
const route = '/route';

GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: firstRoute,
  redirect: (context, state) {
    if (state.uri.path == routing) {
      return firstRoute;
    } else if (state.uri.path == route) {
      return thirdRoute;
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) {
        Storybook.storyRouterNotifier.currentStoryRoute = firstRoute;
        return firstRoute;
      },
    ),
    GoRoute(
      path: firstRoute,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: FirstPage()),
    ),
    GoRoute(
      path: secondRoute,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: SecondPage()),
    ),
    GoRoute(
      path: thirdRoute,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: ThirdPage()),
    ),
  ],
);

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.text(
      label: 'First page title',
      initial: 'First page title',
      description: 'The title of the app bar.',
    );
    final elevation = context.knobs.nullable.slider(
      label: 'First page app bar elevation',
      initial: 4,
      min: 0,
      max: 10,
      description: 'Elevation of the app bar.',
    );

    return Scaffold(
      appBar: AppBar(
        elevation: elevation,
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

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.text(
      label: 'Second page title',
      initial: 'Second page title',
      description: 'The title of the app bar.',
    );

    final elevation = context.knobs.nullable.slider(
      label: 'Second page app bar elevation',
      initial: 4,
      min: 0,
      max: 10,
      description: 'Second Elevation of the app bar.',
    );

    return Scaffold(
      appBar: AppBar(
        elevation: elevation,
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(firstRoute);
            Storybook.storyRouterNotifier.currentStoryRoute = firstRoute;
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
              ),
              SizedBox(width: 4),
              Text('Go to First page'),
            ],
          ),
        ),
      ),
    );
  }
}

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

List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Routing/First page',
    routePath: firstRoute,
    router: router,
    codeString: fetchAsset('first_page_code.md'),
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    routePath: secondRoute,
    router: router,
    codeString: fetchAsset('second_page_code.md'),
  ),
  Story.asRoute(
    name: 'Route/Third page',
    routePath: thirdRoute,
    router: router,
    codeString: fetchAsset('third_page_code.md'),
  ),
];

Future<String> fetchAsset(String assetName) async =>
    rootBundle.loadString(assetName);
