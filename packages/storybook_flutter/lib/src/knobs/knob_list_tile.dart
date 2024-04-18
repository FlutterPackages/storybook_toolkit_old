import 'package:flutter/material.dart';

import 'package:storybook_flutter/src/common/custom_list_tile.dart';

const defaultContentPadding = EdgeInsets.symmetric(horizontal: 24.0);
const inputKnobInputPadding = EdgeInsets.symmetric(horizontal: 12.0);
const inputKnobContentPadding = EdgeInsets.only(
  top: 8.0,
  bottom: 4.0,
  left: 24.0,
  right: 24.0,
);

class KnobListTile extends StatefulWidget {
  const KnobListTile({
    super.key,
    required this.enabled,
    required this.nullable,
    this.contentPadding,
    this.onToggled,
    this.title,
    this.subtitle,
    this.leading,
  });

  final bool enabled;
  final bool nullable;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<bool>? onToggled;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;

  @override
  State<KnobListTile> createState() => _KnobListTileState();
}

class _KnobListTileState extends State<KnobListTile> {
  @override
  Widget build(BuildContext context) {
    const double horizontalTitleGap = 12.0;
    final onToggled = widget.onToggled != null
        ? () => widget.onToggled!(!widget.enabled)
        : null;

    return widget.nullable
        ? CustomListTile(
            isThreeLine: true,
            horizontalTitleGap: horizontalTitleGap,
            contentPadding: widget.contentPadding ?? defaultContentPadding,
            onTap: onToggled,
            leading: SizedBox(
              width: 32,
              child: Transform.scale(
                scale: 0.6,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Switch(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: widget.enabled,
                    onChanged: widget.onToggled,
                  ),
                ),
              ),
            ),
            title: IgnorePointer(
              key: const Key('knobListTile_ignorePointer_disableTitle'),
              ignoring: !widget.enabled,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: widget.title ?? const SizedBox.shrink(),
              ),
            ),
            subtitle: IgnorePointer(
              key: const Key('knobListTile_ignorePointer_disableSubtitle'),
              ignoring: !widget.enabled,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: widget.subtitle,
              ),
            ),
          )
        : CustomListTile(
            isThreeLine: false,
            horizontalTitleGap: horizontalTitleGap,
            contentPadding: widget.contentPadding ?? defaultContentPadding,
            onTap: onToggled,
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subtitle,
          );
  }
}
