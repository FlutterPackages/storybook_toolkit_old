import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter_example/stories/first_page.dart';
import 'package:storybook_flutter_example/stories/second_page.dart';
import 'package:storybook_flutter_example/stories/third_page.dart';

const String routingDirectory = '/routing';
const String routeDirectory = '/route';

const String firstPagePath = '/routing/first_page';
const String secondPagePath = '/routing/second_page';
const String thirdPagePath = '/route/third_page';

GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: firstPagePath,
  redirect: (context, state) {
    switch (state.uri.path) {
      case routingDirectory:
        return firstPagePath;
      case routeDirectory:
        return thirdPagePath;
      default:
        return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: firstPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: FirstPage()),
    ),
    GoRoute(
      path: secondPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: SecondPage()),
    ),
    GoRoute(
      path: thirdPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ThirdPage()),
    ),
  ],
);
