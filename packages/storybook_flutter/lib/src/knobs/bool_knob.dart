import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/plugins/knobs.dart';

/// {@template bool_knob_value}
/// A knob value that allows the user to toggle a boolean value.
///
/// See also:
/// * [BooleanKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class BoolKnobValue extends KnobValue<bool> {
  /// {@macro bool_knob_value}
  BoolKnobValue({required super.value});

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      BooleanKnobWidget(
        label: label,
        description: description,
        value: value,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template boolean_knob_widget}
/// A knob widget that allows the user to toggle a boolean value.
///
/// The knob is displayed as a checkbox.
///
/// See also:
/// * [BoolKnobValue], which is the knob that this widget represents.
/// {@endtemplate}
class BooleanKnobWidget extends StatelessWidget {
  /// {@macro boolean_knob_widget}
  const BooleanKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.enabled,
    required this.nullable,
  });

  final String label;
  final String? description;
  final bool value;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    final description = this.description;

    return MediaQuery(
      data: const MediaQueryData(padding: EdgeInsets.zero),
      child: CheckboxListTile(
        tristate: nullable,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        checkboxShape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: enabled ? value : null,
        onChanged: (bool? value) =>
            context.read<KnobsNotifier>().update(label, value),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  description,
                  style: Theme.of(context).listTileTheme.subtitleTextStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
