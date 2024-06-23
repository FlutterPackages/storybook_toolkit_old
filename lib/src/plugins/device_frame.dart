import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/src/common/constants.dart';
import 'package:flutter_storybook/src/common/custom_list_tile.dart';
import 'package:flutter_storybook/src/plugins/code_view.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

/// Plugin that allows wrapping each story into a device frame.
class DeviceFramePlugin extends Plugin {
  DeviceFramePlugin({
    bool enableCompactLayoutDeviceFrame = true,
    bool enableExpandedLayoutDeviceFrame = true,
    DeviceFrameData initialData = defaultDeviceFrameData,
    List<DeviceInfo>? deviceInfoList,
  }) : super(
          id: PluginId.deviceFrame,
          icon: (BuildContext context) => _buildIcon(
            context,
            enableCompactLayoutDeviceFrame,
            enableExpandedLayoutDeviceFrame,
          ),
          storyBuilder: _buildStoryWrapper,
          wrapperBuilder: (BuildContext context, Widget? child) => _buildWrapper(context, child, initial: initialData),
          panelBuilder: (BuildContext context) => _buildPanel(context, deviceInfoList),
        );
}

Widget? _buildIcon(
  BuildContext context,
  bool enableCompactDeviceFrame,
  bool enableExpandedDeviceFrame,
) {
  final EffectiveLayout effectiveLayout = context.watch<EffectiveLayout>();

  final bool showIconForCompactLayout = effectiveLayout == EffectiveLayout.compact && enableCompactDeviceFrame;

  final bool showIconForExpandedLayout = effectiveLayout == EffectiveLayout.expanded && enableExpandedDeviceFrame;

  return showIconForCompactLayout || showIconForExpandedLayout ? const Icon(Icons.phone_android) : null;
}

Widget _buildStoryWrapper(BuildContext context, Widget? child) {
  final deviceFrame = context.watch<DeviceFrameDataNotifier>().value;
  final DeviceInfo? device = deviceFrame.device;
  final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
  final bool isPage = storyNotifier.currentStory?.isPage == true;
  final bool hasError = storyNotifier.hasRouteMatch == false;

  final focusableChild = TapRegion(
    onTapOutside: (PointerDownEvent _) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    onTapInside: (PointerDownEvent _) {
      if (Storybook.storyFocusNode != null) {
        !Storybook.storyFocusNode!.hasFocus
            ? Storybook.storyFocusNode!.requestFocus()
            : FocusManager.instance.primaryFocus?.unfocus();
      }
    },
    child: child ?? const SizedBox.shrink(),
  );

  return Directionality(
    textDirection: TextDirection.ltr,
    child: device == null || isPage || hasError
        ? focusableChild
        : SizedBox(
            width: double.infinity,
            child: Material(
              child: SafeArea(
                bottom: false,
                child: context.watch<CodeViewNotifier>().value
                    ? focusableChild
                    : Padding(
                        padding: const EdgeInsets.all(defaultPaddingValue),
                        child: DeviceFrame(
                          device: device,
                          isFrameVisible: deviceFrame.isFrameVisible,
                          orientation: deviceFrame.orientation,
                          screen: focusableChild,
                        ),
                      ),
              ),
            ),
          ),
  );
}

typedef DeviceFrameData = ({
  bool isFrameVisible,
  DeviceInfo? device,
  Orientation orientation,
});

const DeviceFrameData defaultDeviceFrameData = (
  isFrameVisible: true,
  device: null,
  orientation: Orientation.portrait,
);

class DeviceFrameDataNotifier extends ValueNotifier<DeviceFrameData> {
  DeviceFrameDataNotifier(super._value);
}

Widget _buildWrapper(
  BuildContext context,
  Widget? child, {
  required DeviceFrameData initial,
}) {
  final Layout layout = context.read<LayoutProvider>().value;
  final EffectiveLayout effectiveLayout = context.watch<EffectiveLayout>();

  return layout == Layout.auto
      ? ChangeNotifierProvider(
          create: (BuildContext _) => DeviceFrameDataNotifier(
            (
              isFrameVisible: initial.isFrameVisible,
              device: effectiveLayout == EffectiveLayout.compact ? null : initial.device,
              orientation: initial.orientation,
            ),
          ),
          child: child,
        )
      : ChangeNotifierProvider(
          create: (BuildContext _) => DeviceFrameDataNotifier(initial),
          child: child,
        );
}

Widget _buildPanel(BuildContext context, List<DeviceInfo>? deviceInfoList) {
  final currentDevice = context.watch<DeviceFrameDataNotifier>().value;

  final ThemeData theme = Theme.of(context);
  final ListTileThemeData listTileTheme = theme.listTileTheme;

  void update(DeviceFrameData data) => context.read<DeviceFrameDataNotifier>().value = data;

  final devices = (deviceInfoList ?? Devices.all).map(
    (DeviceInfo device) {
      // Skip this device because it has a misaligned frame.
      if (device.identifier == Devices.ios.iPhone14Pro.identifier) {
        return const SizedBox.shrink();
      }

      return CustomListTile(
        contentPadding: deviceFrameTilePadding,
        horizontalTitleGap: deviceFrameHorizontalTitleGap,
        selected: currentDevice.device == device,
        onTap: () {
          update(
            (
              device: device,
              isFrameVisible: currentDevice.isFrameVisible,
              orientation: currentDevice.orientation,
            ),
          );
        },
        leading: CircleAvatar(
          radius: 16,
          child: Icon(
            device.identifier.type.icon(device.identifier.platform),
            size: 16,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: deviceFrameDescriptionPadding,
              child: Text(
                '${device.screenSize.width.toInt()}×'
                '${device.screenSize.height.toInt()} (${device.identifier.platform.name})',
                style: listTileTheme.subtitleTextStyle?.copyWith(
                  color: currentDevice.device == device ? listTileTheme.selectedColor : null,
                ),
              ),
            ),
          ],
        ),
        trailing: currentDevice.device == device ? const Icon(Icons.check, size: 16) : null,
      );
    },
  ).toList();

  return ListView.separated(
    primary: false,
    padding: EdgeInsets.zero,
    separatorBuilder: (BuildContext context, index) =>
        index == 1 ? Divider(height: 8, color: theme.dividerColor) : const SizedBox(),
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return CustomListTile(
          contentPadding: deviceFrameTilePadding,
          onTap: () {
            update(
              (
                orientation: currentDevice.orientation,
                device: currentDevice.device,
                isFrameVisible: !currentDevice.isFrameVisible,
              ),
            );
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Frame visibility'),
              Padding(
                padding: deviceFrameDescriptionPadding,
                child: Text(
                  currentDevice.isFrameVisible ? 'visible' : 'hidden',
                  style: listTileTheme.subtitleTextStyle,
                ),
              ),
            ],
          ),
        );
      }

      if (index == 1) {
        return CustomListTile(
          contentPadding: deviceFrameTilePadding,
          onTap: () {
            final orientation =
                currentDevice.orientation == Orientation.portrait ? Orientation.landscape : Orientation.portrait;
            update(
              (
                orientation: orientation,
                device: currentDevice.device,
                isFrameVisible: currentDevice.isFrameVisible,
              ),
            );
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Orientation'),
              Padding(
                padding: deviceFrameDescriptionPadding,
                child: Text(
                  currentDevice.orientation.name,
                  style: listTileTheme.subtitleTextStyle,
                ),
              ),
            ],
          ),
        );
      }

      if (index == 2) {
        return CustomListTile(
          minVerticalPadding: 12,
          contentPadding: deviceFrameTilePadding,
          horizontalTitleGap: deviceFrameHorizontalTitleGap,
          selected: currentDevice.device == null,
          onTap: () => update(
            (
              device: null,
              isFrameVisible: currentDevice.isFrameVisible,
              orientation: currentDevice.orientation,
            ),
          ),
          title: const Text('No device'),
          leading: const CircleAvatar(
            radius: 16,
            child: Icon(Icons.phonelink_off, size: 16),
          ),
          trailing: currentDevice.device == null ? const Icon(Icons.check, size: 16) : null,
        );
      }

      // ignore: prefer-returning-conditional-expressions, more readable
      return devices[index - 3];
    },
    itemCount: devices.length + 3,
  );
}

extension on DeviceType {
  IconData icon(TargetPlatform platform) {
    switch (this) {
      case DeviceType.phone:
        return platform == TargetPlatform.android ? Icons.phone_android : Icons.phone_iphone;
      case DeviceType.tablet:
        return platform == TargetPlatform.android ? Icons.tablet_android : Icons.tablet_mac;
      case DeviceType.desktop:
        return platform == TargetPlatform.macOS ? Icons.desktop_mac : Icons.desktop_windows;
      case DeviceType.tv:
        return Icons.tv;
      case DeviceType.laptop:
        return platform == TargetPlatform.macOS ? Icons.laptop_mac : Icons.laptop_windows;
      case DeviceType.unknown:
        return Icons.device_unknown;
    }
  }
}
