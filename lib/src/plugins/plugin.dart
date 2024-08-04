import 'package:flutter/widgets.dart';
import 'package:storybook_toolkit/src/plugins/code_view.dart';
import 'package:storybook_toolkit/src/plugins/device_frame.dart';
import 'package:storybook_toolkit/src/plugins/directionality.dart';
import 'package:storybook_toolkit/src/plugins/inspector.dart';
import 'package:storybook_toolkit/src/plugins/localization.dart';
import 'package:storybook_toolkit/src/plugins/text_sizer.dart';
import 'package:storybook_toolkit/src/plugins/theme_mode.dart';
import 'package:storybook_toolkit/src/plugins/time_dilation.dart';

export 'contents/contents.dart';
export 'device_frame.dart';
export 'knobs.dart';
export 'layout.dart';
export 'theme_mode.dart';

/// Use this method to initialize and customize built-in plugins.
List<Plugin> initializePlugins({
  bool enableThemeMode = true,
  bool enableCompactLayoutDeviceFrame = true,
  bool enableExpandedLayoutDeviceFrame = true,
  bool enableTimeDilation = true,
  bool enableDirectionality = true,
  bool enableCodeView = false,
  bool enableTextSizer = true,
  bool enableInspector = true,
  LocalizationData? localizationData,
  DeviceFrameData initialDeviceFrameData = defaultDeviceFrameData,
}) =>
    [
      if (enableThemeMode) ThemeModePlugin(),
      if (enableCompactLayoutDeviceFrame || enableExpandedLayoutDeviceFrame)
        DeviceFramePlugin(
          initialData: initialDeviceFrameData,
          enableCompactLayoutDeviceFrame: enableCompactLayoutDeviceFrame,
          enableExpandedLayoutDeviceFrame: enableExpandedLayoutDeviceFrame,
        ),
      if (enableTimeDilation) TimeDilationPlugin(),
      if (enableDirectionality) DirectionalityPlugin(),
      if (enableTextSizer) TextSizerPlugin(),
      CodeViewPlugin(enableCodeView: enableCodeView),
      LocalizationPlugin(initialData: localizationData ?? LocalizationData.initDefault()),
      InspectorPlugin(enableInspector: enableInspector),
    ];

typedef OnPluginButtonPressed = void Function(BuildContext context);
typedef NullableWidgetBuilder = Widget? Function(BuildContext context);

enum PluginId {
  contents,
  codeView,
  localization,
  directionality,
  deviceFrame,
  textSizer,
  inspector,
  knobs,
  layout,
  themeMode,
  timeDilation,
}

class Plugin {
  const Plugin({
    required this.id,
    this.wrapperBuilder,
    this.panelBuilder,
    this.storyBuilder,
    this.icon,
    this.onPressed,
  });

  /// Plugin identifier.
  final PluginId id;

  /// Optional wrapper that will be inserted above the whole storybook content,
  /// including panel.
  ///
  /// E.g. `ContentsPlugin` uses this builder to add side panel.
  final TransitionBuilder? wrapperBuilder;

  /// Optional builder that will be used to display panel popup. It appears when
  /// user clicks on the [icon].
  ///
  /// For it to be used, [icon] must be provided.
  final WidgetBuilder? panelBuilder;

  /// Optional wrapper that will be inserted above each story.
  ///
  /// E.g. `DeviceFramePlugin` uses this builder to display device frame.
  final TransitionBuilder? storyBuilder;

  /// Optional icon that will be displayed on the bottom panel.
  final NullableWidgetBuilder? icon;

  /// Optional callback that will be called when user clicks on the [icon].
  ///
  /// For it to be used, [icon] must be provided.
  final OnPluginButtonPressed? onPressed;
}
