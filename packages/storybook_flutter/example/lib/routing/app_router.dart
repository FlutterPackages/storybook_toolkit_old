import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter_example/routing/routing_error_widget.dart';
import 'package:storybook_flutter_example/stories/first_page.dart';
import 'package:storybook_flutter_example/stories/scaffold_page.dart';
import 'package:storybook_flutter_example/stories/second_page.dart';
import 'package:storybook_flutter_example/stories/third_page.dart';

const String routingDirectory = '/routing';
const String routeDirectory = '/route';
const String nestingSubDirectory = '/routing/nesting';

const String firstPagePath = '/routing/first_page';
const String secondPagePath = '/routing/second_page';
const String examplePagePath = '/routing/nesting/example_page';
const String thirdPagePath = '/route/third_page';

GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: firstPagePath,
  errorBuilder: (BuildContext context, GoRouterState state) =>
      const RoutingErrorWidget(),
  redirect: (context, state) {
    switch (state.uri.path) {
      case routingDirectory:
        return firstPagePath;
      case routeDirectory:
        return thirdPagePath;
      case nestingSubDirectory:
        return examplePagePath;
      default:
        return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (BuildContext _, GoRouterState __) => firstPagePath,
    ),
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
      path: examplePagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ScaffoldPage()),
    ),
    GoRoute(
      path: thirdPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ThirdPage()),
    ),
  ],
);
