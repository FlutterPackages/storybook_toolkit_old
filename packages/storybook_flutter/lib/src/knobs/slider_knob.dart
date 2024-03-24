import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knob_list_tile.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/plugins/knobs.dart';

/// A type definition for a function that formats a [double] value.
typedef DoubleFormatter = String Function(double value);

String _defaultFormat(double value) => value.toStringAsFixed(2);

/// {@template slider_knob}
/// A knob that allows the user to select a value from a range.
///
/// See also:
/// * [SliderKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class SliderKnobValue extends KnobValue<double> {
  /// {@macro slider_knob}
  SliderKnobValue({
    required super.value,
    required this.max,
    required this.min,
    this.divisions,
    this.formatValue = _defaultFormat,
  });

  /// The maximum value of the slider.
  final double max;

  /// The minimum value of the slider.
  final double min;

  /// An optional function that formats the value of the slider.
  ///
  /// By default, the value is formatted as a decimal number with two digits
  /// after the decimal point.
  final DoubleFormatter formatValue;

  /// The number of divisions in the slider.
  ///
  /// Using divisions will create a lag in the slider drag.
  final int? divisions;

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      SliderKnobWidget(
        label: label,
        description: description,
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        formatValue: formatValue,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template slider_knob_widget}
/// A knob widget that allows the user to select a value from a range.
///
/// The knob is displayed as a [Slider].
///
/// See also:
/// * [SliderKnobValue], which is the knob that this widget represents.
/// {@endtemplate}
class SliderKnobWidget extends StatelessWidget {
  /// {@macro slider_knob_widget}
  const SliderKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.formatValue,
    required this.enabled,
    required this.nullable,
  });

  final String label;
  final String? description;
  final double min;
  final double max;
  final double value;
  final int? divisions;
  final DoubleFormatter formatValue;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return KnobListTile(
      nullable: nullable,
      enabled: enabled,
      onToggled: (enabled) => context.read<KnobsNotifier>().update(label, enabled ? value : null),
      title: Text('$label (${formatValue(value)})'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null) ...[
            Text(
              description!,
              style: textTheme.bodyMedium?.copyWith(color: textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 4),
          ],
          Slider(
            value: value,
            onChanged: (v) => context.read<KnobsNotifier>().update(label, v),
            max: max,
            min: min,
            divisions: divisions,
            autofocus: false,
          ),
        ],
      ),
    );
  }
}
