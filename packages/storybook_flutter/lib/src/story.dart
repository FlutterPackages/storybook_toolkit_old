import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_flutter/src/storybook.dart';

@immutable
class Story {
  const Story({
    required this.name,
    required this.builder,
    this.description,
    this.wrapperBuilder,
  })  : router = null,
        routePath = null,
        routeWrapperBuilder = null;

  const Story.asRoute({
    required this.name,
    required this.router,
    required this.routePath,
    this.description,
    this.routeWrapperBuilder,
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
  /// It will be used in the contents as a secondary text.
  final String? description;

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
    Map<String, String>? routeMap,
  })  : _stories = stories.toList(),
        _currentStoryName = initial,
        _routeMap = routeMap ?? {};

  String? get getInitialStoryName => _currentStoryName;

  final Map<String, String> _routeMap;

  String? getRouteName(String? path) => _routeMap[path];

  String? getRoutePath(String? name) =>
      _routeMap.entries.firstWhereOrNull((entry) => entry.value == name)?.key;

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

  String? _currentStoryName;

  Story? get currentStory {
    final index = _stories.indexWhere((s) => s.name == _currentStoryName);

    return index != -1 ? _stories[index] : null;
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
}

const _sectionSeparator = '/';

/// Use this notifier to set the current story path when using routing
/// from inside the story to change the selected story list item.
class StoryRouteNotifier extends ChangeNotifier {
  String _currentStoryRoute = '';

  String get currentStoryRoute => _currentStoryRoute;

  set currentStoryRoute(String path) {
    _currentStoryRoute = path;
    notifyListeners();
  }
}
