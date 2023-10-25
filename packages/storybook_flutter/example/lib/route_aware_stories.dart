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
        Storybook.pathNotifier.currentStoryRoute = firstRoute;
        return firstRoute;
      },
    ),
    GoRoute(
      path: firstRoute,
      builder: (BuildContext context, GoRouterState state) => const FirstPage(),
    ),
    GoRoute(
      path: secondRoute,
      builder: (BuildContext context, GoRouterState state) =>
          const SecondPage(),
    ),
  ],
);

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('First Page')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.push(secondRoute);
              Storybook.pathNotifier.currentStoryRoute = secondRoute;
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

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Second Page')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.push(firstRoute);
              Storybook.pathNotifier.currentStoryRoute = firstRoute;
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
