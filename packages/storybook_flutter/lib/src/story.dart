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

  final Map<String, String> _storyRouteMap;

  /// Map of story route path as key and story route name as value.
  Map<String, String> get storyRouteMap => _storyRouteMap;

  String? get getInitialStoryName => _currentStoryName;

  // GoRouter.
  bool? _routerHasPathMatch;

  bool? get routerHasPathMatch => _routerHasPathMatch;

  set routerHasPathMatch(bool? routerHasMatch) {
    _routerHasPathMatch = routerHasMatch;
    notifyListeners();
  }

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
                (s) =>
                    s.title.toLowerCase().contains(_searchTerm.toLowerCase()),
              ),
      );

  // Story route path.
  String? _storyRoutePath;

  String? get storyRoutePath => _storyRoutePath;

  set storyRoutePath(String? path) {
    _storyRoutePath = path;
    _storyRouteName = _storyRouteMap[path];
    _currentStoryName = _storyRouteName;
    notifyListeners();
  }

  // Story route name.
  String? _storyRouteName;

  String? get storyRouteName => _storyRouteName;

  // Current story name.
  String? _currentStoryName;

  set currentStoryName(String? storyName) {
    _currentStoryName = storyName;
    _routerHasPathMatch = true;
    notifyListeners();
  }

  // Current story.
  Story? get currentStory {
    final int index =
        _stories.indexWhere((story) => story.name == _currentStoryName);
    final Story? story = index != -1 ? _stories[index] : null;

    _storyRoutePath = story?.router?.routeInformationProvider.value.uri.path;
    _storyRouteName = _storyRouteMap[_storyRoutePath];

    return story;
  }

  // After web page refresh, the story is reset, so we need to get the correct
  // last story via router.
  Story? get currentStoryRoute {
    final int index = _stories.indexWhere(
      (story) => story.name == (_storyRouteName ?? _currentStoryName),
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
}
