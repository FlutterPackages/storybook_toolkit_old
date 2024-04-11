import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knob_list_tile.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// {@template select_knob}
/// A knob that allows the user to select an option from a list of options.
///
/// See also:
/// * [Option], which represents a single option in the list.
/// * [SelectKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class SelectKnobValue<T> extends KnobValue<T> {
  /// {@macro select_knob}
  SelectKnobValue({
    required super.value,
    required this.options,
  });

  /// The list of options that the user can select from.
  ///
  /// See also:
  /// * [Option], which represents a single option in the list.
  final List<Option<T>> options;

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      SelectKnobWidget<T>(
        label: label,
        description: description,
        value: value,
        values: options,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template option}
/// Represents a single option for a `SelectKnob`.
///
/// Every option will be displayed in a dropdown menu.
/// {@endtemplate}
class Option<T> {
  /// {@macro option}
  const Option({
    required this.label,
    this.description,
    required this.value,
  });

  /// The label that will be displayed in the dropdown menu.
  final String label;

  /// An optional description that will be displayed in the dropdown menu.
  final String? description;

  /// The value that will be returned when the user selects this option.
  final T value;
}

/// {@template select_knob_widget}
/// A knob widget that allows the user to select a value from a list of options.
///
/// The knob is displayed as a dropdown menu.
///
/// See also:
/// * [SelectKnobValue], which is the knob that this widget represents.
/// {@endtemplate}

class SelectKnobWidget<T> extends StatelessWidget {
  /// {@macro select_knob_widget}
  const SelectKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.values,
    required this.value,
    required this.nullable,
    required this.enabled,
  });

  final String label;
  final String? description;
  final List<Option<T>> values;
  final T value;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? description = this.description;

    return KnobListTile(
      nullable: nullable,
      enabled: enabled,
      contentPadding: const EdgeInsets.only(
        top: 8.0,
        bottom: 4.0,
        left: 16.0,
        right: 16.0,
      ),
      onToggled: (bool enabled) => context
          .read<KnobsNotifier>()
          .update<T?>(label, enabled ? value : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<Option<T>>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              value: values.firstWhereOrNull(
                (Option<T> option) => option.value == value,
              ),
              onTap: () => FocusScope.of(context).focusedChild?.unfocus(),
              selectedItemBuilder: (BuildContext context) => [
                for (final option in values)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.listTileTheme.titleTextStyle,
                    ),
                  ),
              ],
              items: [
                for (final option in values)
                  DropdownMenuItem<Option<T>>(
                    value: option,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option.label,
                                style: theme.listTileTheme.titleTextStyle
                                    ?.copyWith(
                                  color: value == option.value
                                      ? theme.listTileTheme.selectedColor
                                      : null,
                                ),
                              ),
                            ),
                            if (value == option.value) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check,
                                size: 16,
                                color: theme.listTileTheme.selectedColor,
                              ),
                            ],
                          ],
                        ),
                        if (option.description != null)
                          Text(
                            // ignore: avoid-non-null-assertion, checked for null
                            option.description!,
                            style: theme.listTileTheme.subtitleTextStyle,
                          ),
                      ],
                    ),
                  ),
              ],
              onChanged: (Option<T>? option) {
                if (option != null) {
                  context.read<KnobsNotifier>().update<T>(label, option.value);
                }
              },
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                description,
                style: theme.listTileTheme.subtitleTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
