import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/stories/first_page.dart';
import 'package:storybook_flutter_example/stories/second_page.dart';
import 'package:storybook_flutter_example/stories/third_page.dart';

const String firstRoute = '/routing/first_page';
const String secondRoute = '/routing/second_page';
const String thirdRoute = '/route/third_page';
const String routing = '/routing';
const String route = '/route';

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
