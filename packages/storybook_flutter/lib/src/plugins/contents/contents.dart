import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/common/custom_list_tile.dart';
import 'package:storybook_flutter/src/plugins/contents/search_text_field.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// Plugin that adds content as expandable list of stories.
///
/// If `sidePanel` is true, the stories are shown in a left side panel,
/// otherwise as a popup.
class ContentsPlugin extends Plugin {
  ContentsPlugin({Widget? logoWidget})
      : super(
          id: PluginId.contents,
          icon: _buildIcon,
          panelBuilder: (BuildContext context) =>
              _buildPanel(context, logoWidget),
          wrapperBuilder: (BuildContext context, Widget? child) =>
              _buildWrapper(context, child, logoWidget),
        );
}

Widget? _buildIcon(BuildContext context) =>
    switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => const Icon(Icons.list),
      EffectiveLayout.expanded => null,
    };

Widget _buildPanel(BuildContext _, Widget? logoWidget) => _Contents(logoWidget);

Widget _buildWrapper(BuildContext context, Widget? child, Widget? logoWidget) =>
    switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => child ?? const SizedBox.shrink(),
      EffectiveLayout.expanded => Row(
          children: [
            Material(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.black12),
                  ),
                ),
                child: SizedBox(
                  width: 250,
                  child: Navigator(
                    onGenerateRoute: (_) => PageRouteBuilder<void>(
                      pageBuilder: (_, __, ___) => _Contents(logoWidget),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: child,
              ),
            ),
          ],
        ),
    };

class _Contents extends StatefulWidget {
  const _Contents(this.logoWidget);

  final Widget? logoWidget;

  @override
  _ContentsState createState() => _ContentsState();
}

class _ContentsState extends State<_Contents> {
  Widget _buildExpansionTile({
    required String title,
    required Iterable<Story> stories,
    required List<Widget> children,
    EdgeInsetsGeometry? childrenPadding,
  }) {
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
    final String? routeStoryPath = storyNotifier.routeStoryPath;

    bool storyNameContainsFolder = false;
    if (routeStoryPath != null && routeStoryPath.isNotEmpty) {
      storyNameContainsFolder = storyNotifier.storyRouteMap.entries
              .firstWhereOrNull((entry) => entry.key.contains(routeStoryPath))
              ?.value
              .contains(title) ??
          false;
    } else {
      storyNameContainsFolder =
          storyNotifier.getInitialStoryName?.contains(title) ?? false;
    }

    final bool initiallyExpanded =
        storyNotifier.searchTerm.isNotEmpty || storyNameContainsFolder;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
      child: ExpansionTile(
        childrenPadding: childrenPadding,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: (bool expanded) => setState(() {}),
        leading: Icon(
          Icons.folder,
          size: 16,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        trailing: Builder(
          builder: (BuildContext context) => SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: ExpansionTileController.of(context).isExpanded ? 0.5 : 0,
                child: const Icon(
                  Icons.expand_more,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        children: children,
      ),
    );
  }

  Widget _buildStoryTile(Story story) {
    final ListTileThemeData listTileTheme = Theme.of(context).listTileTheme;
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
    final GoRouter? router = story.router;

    final String? storyTileRoutePath =
        storyNotifier.getStoryRoutePath(story.name);
    final Story? currentSelectedStory = storyNotifier.currentStory;
    final bool isRouteAwareStory = router != null && story.routePath != null;

    final bool isSelected = isRouteAwareStory
        ? (story.name == storyNotifier.storyRouteName ||
                (storyNotifier.routeStoryPath == '/' &&
                    story.name == storyNotifier.getInitialStoryName)) &&
            currentSelectedStory?.router != null
        : story == currentSelectedStory;

    return CustomListTile(
      selected: isSelected,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
      ),
      onTap: () {
        storyNotifier.currentStoryName = story.name;
        context.read<OverlayController?>()?.remove();
        router?.go(storyTileRoutePath!);
      },
      leading: const Icon(
        Icons.widgets_outlined,
        size: 14,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(story.title),
          if (story.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
              child: Text(
                story.description!,
                style: listTileTheme.subtitleTextStyle?.copyWith(
                  color: isSelected ? listTileTheme.selectedColor : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildListChildren(List<Story> stories, {int depth = 1}) {
    const double sectionPadding = 16.0;

    final EdgeInsetsGeometry childrenPadding = EdgeInsets.only(
      left: depth + sectionPadding,
    );

    final Map<String, List<Story>> grouped = stories.groupListsBy(
      (story) => story.path.length == depth ? '' : story.path[depth - 1],
    );

    final List<Widget> sectionStories =
        (grouped[''] ?? []).map(_buildStoryTile).toList();

    return stories.length == sectionStories.length
        ? sectionStories
        : [
            ...grouped.keys.where((key) => key.isNotEmpty).map(
                  (key) => _buildExpansionTile(
                    childrenPadding: childrenPadding,
                    title: key,
                    stories: grouped[key]!,
                    children: _buildListChildren(
                      grouped[key]!,
                      depth: depth + 1,
                    ),
                  ),
                ),
            ...sectionStories,
          ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isSidePanel = context.watch<OverlayController?>() == null;
    final String searchTerm = context.watch<StoryNotifier>().searchTerm;

    final List<Widget> children = _buildListChildren(
      context.watch<StoryNotifier>().stories,
    );

    return SafeArea(
      top: isSidePanel,
      bottom: isSidePanel,
      left: isSidePanel,
      right: false,
      child: Column(
        children: [
          if (widget.logoWidget != null && isSidePanel) widget.logoWidget!,
          const SearchTextField(),
          Expanded(
            key: ValueKey(searchTerm),
            child: children.isEmpty && searchTerm.isNotEmpty
                ? const Center(child: Text('Nothing found'))
                : Material(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black12),
                        ),
                      ),
                      child: ListView(
                        primary: false,
                        addAutomaticKeepAlives: true,
                        padding: EdgeInsets.only(
                          bottom: isSidePanel ? 16.0 : 0.0,
                          top: 8.0,
                        ),
                        children: children,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
