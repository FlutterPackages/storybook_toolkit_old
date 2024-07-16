import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_toolkit/src/storybook.dart';

const _sectionSeparator = '/';

@immutable
class Story {
  const Story({
    required this.name,
    required this.builder,
    this.description,
    this.wrapperBuilder,
    this.codeString,
    this.loadDuration,
    this.isPage = false,
    this.goldenPathBuilder,
    this.tags = const [],
  })  : router = null,
        routePath = '',
        routeWrapperBuilder = null;

  const Story.asRoute({
    required this.name,
    required GoRouter this.router,
    required this.routePath,
    this.description,
    this.routeWrapperBuilder,
    this.codeString,
    this.loadDuration,
    this.isPage = false,
    this.goldenPathBuilder,
    this.tags = const [],
  })  : wrapperBuilder = null,
        builder = null,
        assert(
          routePath != '',
          'Route path cannot be empty for route aware story.',
        );

  /// If this story is a page.
  /// Plugin and knob panels with respective functionalities are
  /// hidden and disabled for pages.
  final bool isPage;

  /// Router for route aware story.
  final GoRouter? router;

  /// Route path for route aware story. Route path cannot be empty.
  final String routePath;

  /// Tags for tests
  final List<String> tags;

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

  /// Duration of time for waiting then content is loaded.
  ///
  /// It is useful for golden tests generating.
  final Duration? loadDuration;

  /// Wrapper builder for story.
  final TransitionBuilder? wrapperBuilder;

  /// Wrapper builder for route aware story.
  final RouteWrapperBuilder? routeWrapperBuilder;

  /// Story builder.
  final WidgetBuilder? builder;

  /// Golden test path builder.
  final String Function(({String rootPath, String path, String file}))? goldenPathBuilder;

  List<String> get path => name.split(_sectionSeparator);

  String get title => name.split(_sectionSeparator).last;

  List<String> get storyPathFolders => name.split(_sectionSeparator).sublist(0, path.length - 1);
}

/// Use this notifier to get the current story.
class StoryNotifier extends ChangeNotifier {
  StoryNotifier(
    List<Story> stories, {
    String? initial,
    Map<String, String>? storyRouteMap,
  })  : _stories = stories.toList(),
        _currentStoryName = initial,
        _getInitialStoryName = initial,
        _storyRouteMap = storyRouteMap ?? {};

  // Initial story.
  final String? _getInitialStoryName;

  String? get getInitialStoryName => _getInitialStoryName;

  // Story route map.
  final Map<String, String> _storyRouteMap;

  Map<String, String> get storyRouteMap => _storyRouteMap;

  String? getStoryRouteName(String? route) => _storyRouteMap[route];

  String? getStoryRoutePath(String? name) =>
      _storyRouteMap.entries.firstWhereOrNull((entry) => entry.value == name)?.key;

  // Route match.
  bool? _hasRouteMatch;

  set hasRouteMatch(bool? hasRouteMatch) {
    _hasRouteMatch = hasRouteMatch;
    notifyListeners();
  }

  bool? get hasRouteMatch => _hasRouteMatch;

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
                (story) => story.title.toLowerCase().contains(_searchTerm.toLowerCase()),
              ),
      );

  // Story route path.
  String? _storyRoutePath;

  String? get storyRoutePath => _storyRoutePath;

  set storyRoutePath(String? path) {
    _storyRoutePath = _storyRoutePath;
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
    final index = _stories.indexWhere((story) => story.name == _currentStoryName);

    final Story? story = index != -1 ? _stories[index] : null;

    _storyRoutePath = story?.router?.routeInformationProvider.value.uri.path;
    _storyRouteName = getStoryRouteName(_storyRoutePath);

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
