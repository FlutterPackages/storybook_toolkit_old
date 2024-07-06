import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

class ThemeModePlugin extends Plugin {
  ThemeModePlugin({
    ThemeMode? initialTheme,
    ValueSetter<ThemeMode>? onThemeChanged,
  }) : super(
          id: PluginId.themeMode,
          icon: _buildIcon,
          wrapperBuilder: (context, widget) => _buildWrapper(
            context,
            widget,
            initialTheme,
          ),
          onPressed: (context) => _onPressed(context, onThemeChanged),
        );
}

Widget _buildIcon(BuildContext context) {
  final IconData icon;
  switch (context.watch<ThemeModeNotifier>().value) {
    case ThemeMode.system:
      icon = Icons.brightness_auto_outlined;
    case ThemeMode.light:
      icon = Icons.brightness_5_outlined;
    case ThemeMode.dark:
      icon = Icons.brightness_3_outlined;
  }

  return Icon(icon);
}

void _onPressed(BuildContext context, ValueSetter<ThemeMode>? onThemeChanged) {
  switch (context.read<ThemeModeNotifier>().value) {
    case ThemeMode.system:
      context.read<ThemeModeNotifier>().value = ThemeMode.light;
      onThemeChanged?.call(ThemeMode.light);
    case ThemeMode.light:
      context.read<ThemeModeNotifier>().value = ThemeMode.dark;
      onThemeChanged?.call(ThemeMode.dark);
    case ThemeMode.dark:
      context.read<ThemeModeNotifier>().value = ThemeMode.system;
      onThemeChanged?.call(ThemeMode.system);
  }
}

Widget _buildWrapper(BuildContext _, Widget? child, ThemeMode? initialTheme) =>
    ChangeNotifierProvider<ThemeModeNotifier>(
      create: (_) => ThemeModeNotifier(initialTheme ?? ThemeMode.system),
      child: Builder(
        builder: (BuildContext context) {
          final themeMode = context.watch<ThemeModeNotifier>().value;

          final bool isPage = context.select(
            (StoryNotifier storyNotifier) => storyNotifier.currentStory?.isPage == true,
          );

          final brightness = themeMode == ThemeMode.system
              ? MediaQuery.platformBrightnessOf(context)
              : themeMode == ThemeMode.light
                  ? Brightness.light
                  : Brightness.dark;

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              platformBrightness: isPage ? Brightness.light : brightness,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );

/// Use this notifier to listen to changes in current theme mode.
///
/// `ThemeModePlugin` should be added to plugins for this to work.
class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier(super._value);
}
