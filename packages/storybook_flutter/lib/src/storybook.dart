import 'dart:ui';

import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/plugins/code_view.dart';
import 'package:storybook_flutter/src/plugins/theme/code_view_syntax_theme.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class _ThemeWrapperBuilder {
  _ThemeWrapperBuilder();

  static Widget themeBuilder(BuildContext context, Widget child) => Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          focusColor: Theme.of(context).focusColor.withAlpha(18),
          expansionTileTheme: const ExpansionTileThemeData(
            shape: RoundedRectangleBorder(),
            collapsedShape: RoundedRectangleBorder(),
          ),
          listTileTheme: ListTileThemeData(
            minLeadingWidth: 0,
            minVerticalPadding: 4,
            horizontalTitleGap: 12,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            subtitleTextStyle:
                Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.0),
            selectedColor: Theme.of(context).primaryColor,
            selectedTileColor: Theme.of(context).focusColor.withAlpha(18),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
          ),
        ),
        child: child,
      );
}

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
    this.logoWidget,
    Layout initialLayout = Layout.auto,
    double autoLayoutThreshold = 800,
  })  : plugins = UnmodifiableListView([
          LayoutPlugin(
            initialLayout,
            autoLayoutThreshold,
            enableLayout: enableLayout,
          ),
          ContentsPlugin(logoWidget: logoWidget),
          ...plugins ?? _defaultPlugins,
          const KnobsPlugin(),
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

  /// Logo widget to use in the left side panel above search field.
  final Widget? logoWidget;

  @override
  State<Storybook> createState() => _StorybookState();
}

/// For internal use to manage focus in Storybook.
final FocusScopeNode storyFocusNode = FocusScopeNode();

class _StorybookState extends State<Storybook> {
  late final StoryNotifier _storyNotifier;

  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    final routeMap = Map.fromEntries(
      widget.stories
          .where((story) => story.router != null)
          .map((story) => MapEntry(story.routePath!, story.name)),
    );

    if (routeMap.isNotEmpty) {
      final Story story =
          widget.stories.firstWhere((element) => element.router != null);

      story.router!.routeInformationProvider.addListener(() {
        Storybook.storyRouterNotifier.currentStoryRoute =
            story.router!.routeInformationProvider.value.uri.path;
      });
    }

    _storyNotifier = StoryNotifier(
      widget.stories,
      routeStoriesMap: routeMap,
      initial: widget.initialStory,
    );

    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      _storyNotifier.listenToStoryRouteNotifier(Storybook.storyRouterNotifier);
    });
  }

  @override
  void dispose() {
    _storyNotifier.dispose();
    storyFocusNode.dispose();
    Storybook.storyRouterNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = CurrentStory(
      wrapperBuilder: widget.wrapperBuilder,
      routeWrapperBuilder: widget.routeWrapperBuilder,
    );

    return _ThemeWrapperBuilder.themeBuilder(
      context,
      TapRegionSurface(
        child: MediaQuery.fromView(
          view: View.of(context),
          child: Localizations(
            delegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            locale: const Locale('en', 'US'),
            child: Nested(
              children: [
                Provider.value(value: widget.plugins),
                ChangeNotifierProvider.value(value: _storyNotifier),
                ChangeNotifierProvider.value(
                  value: Storybook.storyRouterNotifier,
                ),
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
                                            top: BorderSide(
                                              color: Colors.black12,
                                            ),
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
            child: FocusScope(
              node: storyFocusNode,
              child: context.watch<CodeViewNotifier>().value
                  ? Stack(
                      children: [
                        child ?? const SizedBox.shrink(),
                        _CurrentStoryCode(
                          panelBackgroundColor: effectiveRouteWrapperBuilder
                              .darkTheme.scaffoldBackgroundColor,
                        ),
                      ],
                    )
                  : child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      );
    } else {
      final Widget Function(BuildContext, Widget?) effectiveWrapperBuilder =
          story.wrapperBuilder ?? wrapperBuilder;

      child = FocusScope(
        node: storyFocusNode,
        child: effectiveWrapperBuilder(
          context,
          context.watch<CodeViewNotifier>().value
              ? const _CurrentStoryCode()
              : Builder(builder: story.builder!),
        ),
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

class _CurrentStoryCode extends StatelessWidget {
  const _CurrentStoryCode({this.panelBackgroundColor});

  final Color? panelBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final ScrollBehavior scrollBehaviour =
        ScrollConfiguration.of(context).copyWith(
      scrollbars: false,
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      },
    );

    final bool isDesktopWeb = kIsWeb &&
        !(kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android));

    final TextStyle? textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70);

    return ColoredBox(
      color: panelBackgroundColor ?? ThemeData.dark().scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => FutureBuilder<String?>(
                future:
                    context.read<StoryNotifier>().currentRouteStory?.codeString,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Houston, we have a problem with showing the code :(',
                        style: textStyle,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ScrollConfiguration(
                      behavior: scrollBehaviour,
                      child: SingleChildScrollView(
                        child: AnySyntaxHighlighter(
                          snapshot.data ?? '',
                          fontSize: 12,
                          padding: 16,
                          hasCopyButton: true,
                          isSelectableText: isDesktopWeb,
                          reservedWordSets: const {'dart'},
                          theme: CustomSyntaxHighlighterTheme.customTheme(),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'No code provided',
                      style: textStyle,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
