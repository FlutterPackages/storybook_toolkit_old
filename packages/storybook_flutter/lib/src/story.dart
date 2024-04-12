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
    Map<String, String>? storyRouteMap,
  })  : _stories = stories.toList(),
        _currentStoryName = initial,
        _storyRouteMap = storyRouteMap ?? {};

  String? get getInitialStoryName => _currentStoryName;

  final Map<String, String> _storyRouteMap;

  Map<String, String> get storyRouteMap => _storyRouteMap;

  String? _getStoryRouteName(String? route) => _storyRouteMap[route];

  String? getStoryRoutePath(String? name) => _storyRouteMap.entries
      .firstWhereOrNull((entry) => entry.value == name)
      ?.key;

  // Stories.
  List<Story> _stories;

  set stories(List<Story> value) {
    _stories = value.toList(growable: false);
    notifyListeners();
  }

  List<Story> get stories => UnmodifiableListView(
        _searchTerm.isEmpty
            ? _stories
            : _stories.where(
                (story) => story.title
                    .toLowerCase()
                    .contains(_searchTerm.toLowerCase()),
              ),
      );

  // Story route path.
  String? _routeStoryPath;

  String? get routeStoryPath => _routeStoryPath;

  set routeStoryPath(String? path) {
    _routeStoryPath = _routeStoryPath;
    _currentStoryName = _getStoryRouteName(_routeStoryPath);
    notifyListeners();
  }

  // Story route name.
  String? _storyRouteName;

  String? get storyRouteName => _storyRouteName;

  // Current Story name.
  String? _currentStoryName;

  String? get currentStoryName => _currentStoryName;

  set currentStoryName(String? value) {
    _currentStoryName = value;
    notifyListeners();
  }

  Story? get currentStory {
    final index =
        _stories.indexWhere((story) => story.name == _currentStoryName);

    final Story? story = index != -1 ? _stories[index] : null;

    _routeStoryPath = story?.router?.routeInformationProvider.value.uri.path;
    _storyRouteName = _getStoryRouteName(_routeStoryPath);

    return story;
  }

  // After web page refresh, the story is reset, so we need to get the correct
  // last story via router.
  Story? get currentStoryRoute {
    final index = _stories.indexWhere(
      (s) => s.name == (_storyRouteName ?? _currentStoryName),
    );

    final Story? story = index != -1 ? _stories[index] : null;

    return story;
  }

  // Search term.
  String _searchTerm = '';

  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  void listenToStoryRouteNotifier(StoryRouteNotifier storyRouterNotifier) {
    storyRouterNotifier.addListener(() {
      _currentStoryName =
          _getStoryRouteName(storyRouterNotifier.currentStoryRoutePath);
      notifyListeners();
    });
  }
}

/// Notifier to set the current story route path.
class StoryRouteNotifier extends ChangeNotifier {
  String _storyRoutePath = '';

  String get currentStoryRoutePath => _storyRoutePath;

  set currentStoryRoutePath(String path) {
    _storyRoutePath = path;
    notifyListeners();
  }
}
