import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/src/plugins/plugin.dart';

class LocalizationPlugin extends Plugin {
  LocalizationPlugin({
    required LocalizationData initialData,
  }) : super(
          id: PluginId.localization,
          icon: (context) => _buildIcon(context, initialData),
          wrapperBuilder: (BuildContext context, Widget? child) => _buildWrapper(context, child, initialData),
        );
}

Widget _buildIcon(BuildContext context, LocalizationData state) => state.supportedLocales.length > 1
    ? DropdownButton(
        isDense: true,
        underline: SizedBox.shrink(),
        onChanged: (value) {
          context.read<LocalizationNotifier>().value =
              context.read<LocalizationNotifier>().value.update(Locale.fromSubtags(languageCode: value.toString()));
        },
        value: context.watch<LocalizationNotifier>().value.currentLocale.languageCode,
        items: [
          for (Locale locale in state.supportedLocales)
            DropdownMenuItem(
              child: Text(locale.languageCode.toUpperCase()),
              value: locale.languageCode,
            ),
        ],
      )
    : const SizedBox.shrink();

Widget _buildWrapper(BuildContext context, Widget? child, LocalizationData localizationState) =>
    ChangeNotifierProvider<LocalizationNotifier>(
      create: (_) => LocalizationNotifier(state: localizationState),
      child: Builder(
        builder: (context) => child ?? const SizedBox.shrink(),
      ),
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
  final List<Locale> supportedLocales;
  final List<LocalizationsDelegate<dynamic>> delegates;

  factory LocalizationData.initDefault() {
    return LocalizationData(
      supportedLocales: [Locale.fromSubtags(languageCode: 'en')],
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
