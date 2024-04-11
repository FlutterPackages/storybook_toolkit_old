import 'package:flutter/material.dart';

import 'package:storybook_flutter/src/common/custom_list_tile.dart';

class KnobListTile extends StatefulWidget {
  const KnobListTile({
    super.key,
    required this.enabled,
    required this.nullable,
    required this.onToggled,
    this.title,
    this.subtitle,
    this.contentPadding,
  });

  final Widget? title;
  final Widget? subtitle;
  final bool enabled;
  final bool nullable;
  final ValueChanged<bool> onToggled;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<KnobListTile> createState() => _KnobListTileState();
}

class _KnobListTileState extends State<KnobListTile> {
  @override
  Widget build(BuildContext context) => widget.nullable
      ? CustomListTile(
          isThreeLine: true,
          contentPadding: widget.contentPadding,
          onTap: () => widget.onToggled(!widget.enabled),
          leading: SizedBox(
            width: 40,
            child: Transform.scale(
              scaleX: 0.75,
              scaleY: 0.75,
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
          contentPadding: widget.contentPadding,
          title: widget.title,
          subtitle: widget.subtitle,
        );
}
