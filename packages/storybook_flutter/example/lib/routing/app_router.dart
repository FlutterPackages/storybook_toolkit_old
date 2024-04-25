import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter_example/common/routing_error_widget.dart';
import 'package:storybook_flutter_example/stories/colors_page.dart';
import 'package:storybook_flutter_example/stories/first_page.dart';
import 'package:storybook_flutter_example/stories/home_page.dart';
import 'package:storybook_flutter_example/stories/scaffold_page.dart';
import 'package:storybook_flutter_example/stories/second_page.dart';
import 'package:storybook_flutter_example/stories/third_page.dart';

const String routeDirectory = '/route';
const String routingDirectory = '/routing';
const String nestingSubDirectory = '/routing/nesting';

GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: HomePage.homePagePath,
  errorBuilder: (BuildContext context, GoRouterState state) =>
      const RoutingErrorWidget(),
  redirect: (context, state) {
    switch (state.uri.path) {
      case routingDirectory:
        return FirstPage.firstPagePath;
      case routeDirectory:
        return ThirdPage.thirdPagePath;
      case nestingSubDirectory:
        return ScaffoldPage.examplePagePath;
      default:
        return null;
    }
  },
  routes: <RouteBase>[
    // Pages
    GoRoute(
      path: HomePage.homePagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: HomePage()),
    ),
    GoRoute(
      path: ColorsPage.colorsPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ColorsPage()),
    ),

    // Stories
    GoRoute(
      path: FirstPage.firstPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: FirstPage()),
    ),
    GoRoute(
      path: SecondPage.secondPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: SecondPage()),
    ),
    GoRoute(
      path: ScaffoldPage.examplePagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ScaffoldPage()),
    ),
    GoRoute(
      path: ThirdPage.thirdPagePath,
      pageBuilder: (BuildContext _, GoRouterState __) =>
          const NoTransitionPage(child: ThirdPage()),
    ),
  ],
);
