import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/src/storybook.dart';

const _sectionSeparator = '/';

@immutable
class Story {
  const Story({
    required this.name,
    required this.builder,
    this.description,
    this.wrapperBuilder,
    this.codeString,
  })  : router = null,
        routePath = null,
        routeWrapperBuilder = null;

  const Story.asRoute({
    required this.name,
    required this.router,
    required this.routePath,
    this.description,
    this.routeWrapperBuilder,
    this.codeString,
  })  : wrapperBuilder = null,
        builder = null;

  /// Router for route aware story.
  final GoRouter? router;

  /// Route path for route aware story.
  final String? routePath;

  /// Unique name of the story.
  ///
  /// Use `/` to group stories in sections, e.g. `Buttons/FlatButton`
  /// will create a section `Buttons` with a story `FlatButton` in it.
  final String name;

  /// Optional description of the story.
  ///
  /// It will be used as a secondary text under story name.
  final String? description;

  /// Code string to show for the story.
  final Future<String>? codeString;

  /// Wrapper builder for story.
  final TransitionBuilder? wrapperBuilder;

  /// Wrapper builder for route aware story.
  final RouteWrapperBuilder? routeWrapperBuilder;

  /// Story builder.
  final WidgetBuilder? builder;

  List<String> get path => name.split(_sectionSeparator);

  String get title => name.split(_sectionSeparator).last;
}

/// Use this notifier to get the current story.
class StoryNotifier extends ChangeNotifier {
  StoryNotifier(
    List<Story> stories, {
    String? initial,
    Map<String, String>? routeStoriesMap,
  })  : _stories = stories.toList(),
        _currentStoryName = initial,
        _routeStoriesMap = routeStoriesMap ?? {};

  String? get getInitialStoryName => _currentStoryName;

  final Map<String, String> _routeStoriesMap;

  String? _getRouteName(String? route) => _routeStoriesMap[route];

  String? getStoryRoute(String? name) => _routeStoriesMap.entries
      .firstWhereOrNull((entry) => entry.value == name)
      ?.key;

  List<Story> _stories;

  set stories(List<Story> value) {
    _stories = value.toList(growable: false);
    notifyListeners();
  }

  List<Story> get stories => UnmodifiableListView(
        _searchTerm.isEmpty
            ? _stories
            : _stories.where(
                (s) =>
                    s.title.toLowerCase().contains(_searchTerm.toLowerCase()),
              ),
      );

  String? _routeStoryPath;

  String? get routeStoryPath => _routeStoryPath;

  set routeStoryPath(String? path) {
    _routeStoryPath = _routeStoryPath;
    _currentStoryName = _getRouteName(_routeStoryPath);
    notifyListeners();
  }

  String? _routeStoryName;

  String? get routeStoryName => _routeStoryName;

  String? _currentStoryName;

  Story? get currentStory {
    final index = _stories.indexWhere((s) => s.name == _currentStoryName);

    final Story? story = index != -1 ? _stories[index] : null;

    _routeStoryPath = story?.router?.routeInformationProvider.value.uri.path;
    _routeStoryName = _getRouteName(_routeStoryPath);

    return story;
  }

  // After web page refresh, the story is reset, so we need to get the correct
  // last story via router.
  Story? get currentRouteStory {
    final index = _stories.indexWhere(
      (s) => s.name == (_routeStoryName ?? _currentStoryName),
    );

    final Story? story = index != -1 ? _stories[index] : null;

    return story;
  }

  String? get currentStoryName => _currentStoryName;

  set currentStoryName(String? value) {
    _currentStoryName = value;
    notifyListeners();
  }

  String _searchTerm = '';

  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  void listenToStoryRouteNotifier(StoryRouteNotifier storyRouterNotifier) {
    storyRouterNotifier.addListener(() {
      _currentStoryName = _getRouteName(storyRouterNotifier.currentStoryRoute);
      notifyListeners();
    });
  }
}

/// Use this notifier to set the current story route when using routing
/// from inside the story.
class StoryRouteNotifier extends ChangeNotifier {
  String _storyRoute = '';

  String get currentStoryRoute => _storyRoute;

  set currentStoryRoute(String route) {
    _storyRoute = route;
    notifyListeners();
  }
}
