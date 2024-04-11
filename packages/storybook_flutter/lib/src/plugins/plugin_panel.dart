import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/plugins/plugin.dart';
import 'package:storybook_flutter/src/story.dart';

const String _pluginPanelGroupId = 'plugin_panel';

class PluginPanel extends StatefulWidget {
  const PluginPanel({
    super.key,
    required this.plugins,
    required this.layerLink,
    required this.overlayKey,
  });

  final List<Plugin> plugins;
  final LayerLink layerLink;
  final GlobalKey<OverlayState> overlayKey;

  @override
  State<PluginPanel> createState() => _PluginPanelState();
}

class _PluginPanelState extends State<PluginPanel> {
  PluginOverlay? _overlay;

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  OverlayEntry _createEntry(WidgetBuilder childBuilder) => OverlayEntry(
        builder: (context) => Provider<OverlayController>(
          create: (context) => OverlayController(
            remove: () {
              _overlay?.remove();
              _overlay = null;
            },
          ),
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              final MediaQueryData mediaQuery = MediaQuery.of(context);

              final double screenBottomPadding = mediaQuery.padding.bottom;
              final double viewPadding = mediaQuery.viewPadding.bottom;
              final double screenHeight = mediaQuery.size.height;
              final double keyboardHeight = mediaQuery.viewInsets.bottom;
              final double panelHeight =
                  widget.layerLink.leaderSize?.height ?? 0;

              // Compensates the System UI bottom padding on mobile devices
              // when the keyboard is shown/hidden to avoid the Dialog jumping.
              final double bottomSafeArea = viewPadding - screenBottomPadding;
              // To smoothly adjust the Dialog height based on the keyboard's dimensions.
              final double dialogBottomPadding =
                  max(0, panelHeight - keyboardHeight);
              final double mobileDialogHeight =
                  (orientation == Orientation.portrait
                          ? screenHeight * 0.5
                          : screenHeight * 0.9) +
                      bottomSafeArea;

              return Stack(
                children: [
                  Positioned(
                    height: kIsWeb ? 400 : mobileDialogHeight,
                    width: 250,
                    child: CompositedTransformFollower(
                      link: widget.layerLink,
                      // Linked to target's bottom left corner to avoid the
                      // white space between the keyboard and dialog.
                      targetAnchor: Alignment.bottomLeft,
                      followerAnchor: Alignment.bottomLeft,
                      showWhenUnlinked: false,
                      child: TapRegion(
                        groupId: _pluginPanelGroupId,
                        onTapOutside: (PointerDownEvent _) {
                          _overlay?.remove();
                          _overlay = null;
                        },
                        child: Dialog(
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          shadowColor: Colors.black87,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          insetAnimationDuration: Duration.zero,
                          insetPadding:
                              EdgeInsets.only(bottom: dialogBottomPadding),
                          child: Navigator(
                            onGenerateRoute: (_) => MaterialPageRoute<void>(
                              builder: (context) => PointerInterceptor(
                                child: Material(
                                  child: childBuilder(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  void _onPluginButtonPressed(Plugin plugin) {
    plugin.onPressed?.call(context);
    final panelBuilder = plugin.panelBuilder;

    if (panelBuilder == null) return;

    void insertOverlay() {
      final overlay =
          PluginOverlay(plugin: plugin, entry: _createEntry(panelBuilder));
      _overlay = overlay;
      widget.overlayKey.currentState?.insert(overlay.entry);
    }

    final overlay = _overlay;
    if (overlay != null) {
      overlay.remove();
      if (overlay.plugin != plugin) {
        insertOverlay();
      } else {
        _overlay = null;
      }
    } else {
      insertOverlay();
    }
  }

  @override
  Widget build(BuildContext context) => Wrap(
        runAlignment: WrapAlignment.center,
        children: widget.plugins
            .map((plugin) => (plugin, plugin.icon?.call(context)))
            .whereType<(Plugin, Widget)>()
            .map(
              (plugin) => TapRegion(
                groupId: _pluginPanelGroupId,
                child: IconButton(
                  icon: plugin.$2,
                  onPressed:
                      context.watch<StoryNotifier>().routerHasPathMatch ?? true
                          ? () => _onPluginButtonPressed(plugin.$1)
                          : plugin.$1.id == PluginId.contents
                              ? () => _onPluginButtonPressed(plugin.$1)
                              : null,
                ),
              ),
            )
            .toList(),
      );
}

@immutable
class PluginOverlay {
  const PluginOverlay({required this.entry, required this.plugin});

  final OverlayEntry entry;
  final Plugin plugin;

  void remove() => entry.remove();
}

class OverlayController {
  const OverlayController({required this.remove});

  final VoidCallback remove;
}
