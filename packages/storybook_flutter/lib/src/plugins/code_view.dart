import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/plugins/plugin.dart';

class CodeViewPlugin extends Plugin {
  CodeViewPlugin({
    required bool enableCodeView,
    ValueSetter<bool>? onShowCodeView,
  }) : super(
          icon: enableCodeView ? _buildIcon : null,
          wrapperBuilder: _buildWrapper,
          onPressed: (context) => _onPressed(context, onShowCodeView),
        );
}

Widget _buildIcon(BuildContext context) => Icon(
      context.watch<CodeViewNotifier>().value
          ? Icons.remove_red_eye_outlined
          : Icons.code,
    );

void _onPressed(BuildContext context, ValueSetter<bool>? onShowCodeView) {
  switch (context.read<CodeViewNotifier>().value) {
    case true:
      context.read<CodeViewNotifier>().value = false;
      onShowCodeView?.call(false);
    case false:
      context.read<CodeViewNotifier>().value = true;
      onShowCodeView?.call(true);
  }
}

Widget _buildWrapper(BuildContext context, Widget? child) =>
    ChangeNotifierProvider<CodeViewNotifier>(
      create: (_) => CodeViewNotifier(false),
      child: Builder(
        builder: (context) => child ?? const SizedBox.shrink(),
      ),
    );

/// Use this notifier to get whether code view is selected.
///
/// `CodeViewPlugin` should be added to plugins for this to work.
class CodeViewNotifier extends ValueNotifier<bool> {
  CodeViewNotifier(super._value);
}
