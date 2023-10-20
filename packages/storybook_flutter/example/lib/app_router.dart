import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: FirstRoute.page, path: '/first-page', initial: true),
        AutoRoute(page: SecondRoute.page, path: '/second-page'),
      ];
}

@RoutePage()
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('First Page')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.router.navigate(const SecondRoute()),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text('To Second page'),
              ],
            ),
          ),
        ),
      );
}

@RoutePage()
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Second Page')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.router.navigate(const FirstRoute()),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text('To First page'),
              ],
            ),
          ),
        ),
      );
}

final List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Routing/First page',
    initialRoutes: const [FirstRoute()],
    router: AppRouter(),
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    initialRoutes: const [SecondRoute()],
    router: AppRouter(),
  ),
];
