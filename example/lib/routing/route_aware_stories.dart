import 'package:flutter/services.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_example/routing/app_router.dart';
import 'package:storybook_toolkit_example/stories/colors_page.dart';
import 'package:storybook_toolkit_example/stories/first_page.dart';
import 'package:storybook_toolkit_example/stories/home_page.dart';
import 'package:storybook_toolkit_example/stories/scaffold_page.dart';
import 'package:storybook_toolkit_example/stories/second_page.dart';
import 'package:storybook_toolkit_example/stories/third_page.dart';

List<Story> routeAwareStories = [
  Story.asRoute(
    name: 'Home',
    routePath: HomePage.homePagePath,
    router: router,
    isPage: true,
  ),
  Story.asRoute(
    name: 'Pages/Colors',
    routePath: ColorsPage.colorsPagePath,
    router: router,
    isPage: true,
  ),
  Story.asRoute(
    name: 'Routing/First page',
    routePath: FirstPage.firstPagePath,
    router: router,
    description: 'First page description',
    codeString: fetchAsset('first_page.md'),
  ),
  Story.asRoute(
    name: 'Routing/Second page',
    routePath: SecondPage.secondPagePath,
    router: router,
    codeString: fetchAsset('second_page.md'),
  ),
  Story.asRoute(
    name: 'Routing/Nesting/Example Page',
    routePath: ScaffoldPage.examplePagePath,
    router: router,
  ),
  Story.asRoute(
    name: 'Route/Third page',
    routePath: ThirdPage.thirdPagePath,
    router: router,
    codeString: fetchAsset('third_page.md'),
  ),
];

Future<String> fetchAsset(String assetName) async {
  const String directory = 'assets/code_snippets/';

  return rootBundle.loadString('$directory$assetName');
}
