import 'package:flutter/services.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

const String directory = 'assets/code_snippets/';

List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Routing/First page',
    routePath: firstRoute,
    router: router,
    codeString: fetchAsset('first_page.md'),
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    routePath: secondRoute,
    router: router,
    codeString: fetchAsset('second_page.md'),
  ),
  Story.asRoute(
    name: 'Route/Third page',
    routePath: thirdRoute,
    router: router,
    codeString: fetchAsset('third_page.md'),
  ),
];

Future<String> fetchAsset(String assetName) async =>
    rootBundle.loadString('$directory$assetName');
