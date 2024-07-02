import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/src/plugins/plugin.dart';
import 'package:vader_popup/vader_popup.dart';

class LocalizationPlugin extends Plugin {
  LocalizationPlugin({
    required LocalizationData initialData,
  }) : super(
          id: PluginId.localization,
          icon: (context) => initialData.supportedLocales.values.length > 1 ? _buildIcon(context, initialData) : null,
          wrapperBuilder: (BuildContext context, Widget? child) => _buildWrapper(context, child, initialData),
        );
}

Widget _buildIcon(BuildContext context, LocalizationData state) {
  return GestureDetector(
    child: Icon(Icons.language),
    onTap: () async {
      final String value = await PopupDialog().choose(
        context: context,
        title: "Language",
        message: "Choose language:",
        options: [
          for (MapEntry<String, Locale> locale in state.supportedLocales.entries)
            PopupOption(label: locale.key, value: locale.value.languageCode),
        ],
      );
      context.read<LocalizationNotifier>().value =
          context.read<LocalizationNotifier>().value.update(Locale.fromSubtags(languageCode: value.toString()));
    },
  );
}

Widget _buildWrapper(BuildContext context, Widget? child, LocalizationData localizationState) =>
    ChangeNotifierProvider<LocalizationNotifier>(
      create: (_) => LocalizationNotifier(state: localizationState),
      child: child ?? const SizedBox.shrink(),
    );

class LocalizationNotifier extends ValueNotifier<LocalizationData> {
  LocalizationNotifier({required LocalizationData state}) : super(state);
}

class LocalizationData {
  const LocalizationData({
    required this.currentLocale,
    required this.supportedLocales,
    required this.delegates,
  });

  final Locale currentLocale;
  final Map<String, Locale> supportedLocales;
  final List<LocalizationsDelegate<dynamic>> delegates;

  factory LocalizationData.initDefault() {
    return LocalizationData(
      supportedLocales: {"English": Locale.fromSubtags(languageCode: 'en')},
      delegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      currentLocale: Locale.fromSubtags(languageCode: 'en'),
    );
  }

  LocalizationData update(Locale locale) {
    return LocalizationData(
      currentLocale: locale,
      supportedLocales: this.supportedLocales,
      delegates: this.delegates,
    );
  }
}
