import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

const firstRoute = '/routing/first_page';
const secondRoute = '/routing/second_page';

GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: firstRoute,
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

List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Routing/First page',
    routePath: firstRoute,
    router: router,
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    routePath: secondRoute,
    router: router,
  ),
];
