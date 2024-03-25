import 'package:flutter/services.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:storybook_flutter_example/routing/app_router.dart';

List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Routing/First page',
    routePath: firstPagePath,
    router: router,
    codeString: fetchAsset('first_page.md'),
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    routePath: secondPagePath,
    router: router,
    codeString: fetchAsset('second_page.md'),
  ),
  Story.asRoute(
    name: 'Route/Third page',
    routePath: thirdPagePath,
    router: router,
    codeString: fetchAsset('third_page.md'),
  ),
];

Future<String> fetchAsset(String assetName) async {
  const String directory = 'assets/code_snippets/';

  return rootBundle.loadString('$directory$assetName');
}
