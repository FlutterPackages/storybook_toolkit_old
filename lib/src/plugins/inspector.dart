import 'package:flutter/material.dart';
import 'package:inspector/inspector.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/plugin.dart';

class InspectorPlugin extends Plugin {
  InspectorPlugin({
    ValueSetter<TextDirection>? onTextDirectionChanged,
  }) : super(
          id: PluginId.inspector,
          icon: _buildIcon,
          wrapperBuilder: _buildWrapper,
        );
}

Widget _buildIcon(BuildContext context) => GestureDetector(
      onTap: () => context.read<InspectorNotifier>().value = !context.read<InspectorNotifier>().value,
      child: Icon(context.watch<InspectorNotifier>().value ? Icons.search_off : Icons.search),
    );

Widget _buildWrapper(BuildContext _, Widget? child) => ChangeNotifierProvider<InspectorNotifier>(
      create: (_) => InspectorNotifier(false),
      child: Builder(
        builder: (context) => Inspector(
          isEnabled: context.watch<InspectorNotifier>().value,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );

class InspectorNotifier extends ValueNotifier<bool> {
  InspectorNotifier(super._value);
}
