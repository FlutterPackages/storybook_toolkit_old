import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// Use this wrapper to wrap each route aware story inside default
/// [MaterialApp.router] widget.
class RouteWrapperBuilder {
  RouteWrapperBuilder({
    this.title = '',
    ThemeData? theme,
    ThemeData? darkTheme,
    this.debugShowCheckedModeBanner = false,
    Widget Function(BuildContext, Widget?)? wrapperBuilder,
  })  : theme = theme ?? ThemeData.light(),
        darkTheme = darkTheme ?? ThemeData.dark(),
        wrapperBuilder = wrapperBuilder ?? defaultWrapperBuilder;

  final String title;
  final ThemeData theme;
  final ThemeData darkTheme;
  final bool debugShowCheckedModeBanner;
  final Widget Function(BuildContext, Widget?) wrapperBuilder;

  static Widget defaultWrapperBuilder(BuildContext context, Widget? child) =>
      Scaffold(
        body: Center(
          child: child ?? const SizedBox.shrink(),
        ),
      );
}

/// Use this wrapper to wrap each story into a [MaterialApp] widget.
Widget materialWrapper(BuildContext context, Widget? child) => MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: Directionality.of(context),
        child: Scaffold(
          body: Center(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );

/// Use this wrapper to wrap each story into a [CupertinoApp] widget.
Widget cupertinoWrapper(BuildContext context, Widget? child) => CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: Directionality.of(context),
        child: CupertinoPageScaffold(
          child: Center(child: child),
        ),
      ),
    );

final _defaultPlugins = initializePlugins();

class Storybook extends StatefulWidget {
  Storybook({
    super.key,
    required Iterable<Story> stories,
    Iterable<Plugin>? plugins,
    this.initialStory,
    this.wrapperBuilder = materialWrapper,
    this.routeWrapperBuilder,
    this.showPanel = true,
    this.enableLayout = true,
    this.brandingWidget,
    Layout initialLayout = Layout.auto,
    double autoLayoutThreshold = 800,
  })  : plugins = UnmodifiableListView([
          LayoutPlugin(
            initialLayout,
            autoLayoutThreshold,
            enableLayout: enableLayout,
          ),
          const ContentsPlugin(),
          const KnobsPlugin(),
          ...plugins ?? _defaultPlugins,
        ]),
        stories = UnmodifiableListView(stories);

  /// All enabled plugins.
  final List<Plugin> plugins;

  /// All available stories.
  final List<Story> stories;

  /// Optional initial story.
  final String? initialStory;

  /// Each story will be wrapped into a widget returned by this builder.
  final TransitionBuilder wrapperBuilder;

  /// Each routed story will be wrapped into a widget returned by this builder.
  final RouteWrapperBuilder? routeWrapperBuilder;

  /// Whether to show the plugin panel at the bottom.
  final bool showPanel;

  /// Whether to enable the layout plugin in the plugin panel.
  final bool enableLayout;

  /// Branding widget to use in the plugin panel.
  final Widget? brandingWidget;

  /// Route notifier to use when routing from inside the story.
  static StoryRouteNotifier storyRouterNotifier = StoryRouteNotifier();

  @override
  State<Storybook> createState() => _StorybookState();
}

class _StorybookState extends State<Storybook> {
  final _overlayKey = GlobalKey<OverlayState>();
  final _layerLink = LayerLink();
  late final StoryNotifier _storyNotifier;

  @override
  void initState() {
    super.initState();

    final routeMap = Map.fromEntries(
      widget.stories
          .where((story) => story.router != null)
          .map((story) => MapEntry(story.routePath!, story.name)),
    );

    _storyNotifier = StoryNotifier(
      widget.stories,
      routeStoriesMap: routeMap,
      initial: widget.initialStory,
    )..listenToStoryRouteNotifier(Storybook.storyRouterNotifier);
  }

  @override
  void dispose() {
    _storyNotifier.dispose();
    Storybook.storyRouterNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = CurrentStory(
      wrapperBuilder: widget.wrapperBuilder,
      routeWrapperBuilder: widget.routeWrapperBuilder,
    );

    return TapRegion(
      onTapOutside: (PointerDownEvent _) => FocusScope.of(context).unfocus(),
      child: MediaQuery.fromView(
        view: View.of(context),
        child: Nested(
          children: [
            Provider.value(value: widget.plugins),
            ChangeNotifierProvider.value(value: _storyNotifier),
            ChangeNotifierProvider.value(value: Storybook.storyRouterNotifier),
            ...widget.plugins
                .map((p) => p.wrapperBuilder)
                .whereType<TransitionBuilder>()
                .map((builder) => SingleChildBuilder(builder: builder)),
          ],
          child: widget.showPanel
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Expanded(child: currentStory),
                        RepaintBoundary(
                          child: Material(
                            child: SafeArea(
                              top: false,
                              child: CompositedTransformTarget(
                                link: _layerLink,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.black12),
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: PluginPanel(
                                            plugins: widget.plugins,
                                            overlayKey: _overlayKey,
                                            layerLink: _layerLink,
                                          ),
                                        ),
                                        widget.brandingWidget ??
                                            const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Overlay(key: _overlayKey),
                    ),
                  ],
                )
              : currentStory,
        ),
      ),
    );
  }
}

class CurrentStory extends StatelessWidget {
  const CurrentStory({
    super.key,
    required this.wrapperBuilder,
    this.routeWrapperBuilder,
  });

  final TransitionBuilder wrapperBuilder;
  final RouteWrapperBuilder? routeWrapperBuilder;

  @override
  Widget build(BuildContext context) {
    final story = context.watch<StoryNotifier>().currentStory;
    if (story == null) {
      return const Directionality(
        textDirection: TextDirection.ltr,
        child: Material(child: Center(child: Text('Select story'))),
      );
    }

    final plugins = context.watch<List<Plugin>>();
    final pluginBuilders = plugins
        .map((p) => p.storyBuilder)
        .whereType<TransitionBuilder>()
        .map((builder) => SingleChildBuilder(builder: builder))
        .toList();

    Widget child;

    if (story.router != null) {
      final RouteWrapperBuilder effectiveRouteWrapperBuilder =
          story.routeWrapperBuilder ??
              routeWrapperBuilder ??
              RouteWrapperBuilder();

      child = MaterialApp.router(
        title: effectiveRouteWrapperBuilder.title,
        theme: effectiveRouteWrapperBuilder.theme,
        darkTheme: effectiveRouteWrapperBuilder.darkTheme,
        debugShowCheckedModeBanner:
            effectiveRouteWrapperBuilder.debugShowCheckedModeBanner,
        routerConfig: story.router,
        builder: (BuildContext context, Widget? child) =>
            effectiveRouteWrapperBuilder.wrapperBuilder(
          context,
          Directionality(
            textDirection: context.watch<TextDirectionNotifier>().value,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      );
    } else {
      final Widget Function(BuildContext, Widget?) effectiveWrapperBuilder =
          story.wrapperBuilder ?? wrapperBuilder;

      child = effectiveWrapperBuilder(
        context,
        Builder(builder: story.builder!),
      );
    }

    return KeyedSubtree(
      key: ValueKey(story.name),
      child: pluginBuilders.isEmpty
          ? child
          : Nested(children: pluginBuilders, child: child),
    );
  }
}
