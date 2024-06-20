import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/plugins/code_view.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// Plugin that adds story customization knobs.
///
/// If `sidePanel` is true, the knobs will be displayed in the right side panel.
class KnobsPlugin extends Plugin {
  const KnobsPlugin()
      : super(
          id: PluginId.knobs,
          icon: _buildIcon,
          panelBuilder: _buildPanel,
          wrapperBuilder: _buildWrapper,
        );
}

Widget? _buildIcon(BuildContext context) => switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => const Icon(Icons.settings),
      EffectiveLayout.expanded => null,
    };

Widget _buildPanel(BuildContext context) {
  final KnobsNotifier knobs = context.watch<KnobsNotifier>();
  final bool isCodeView = context.watch<CodeViewNotifier>().value;
  final bool isSidePanel = context.watch<OverlayController?>() == null;
  final String? currentStoryName = context.read<StoryNotifier>().storyRouteName;

  final List<Knob<dynamic>> items = isCodeView ? [] : knobs.all();

  final Story? currentStory = context.select((StoryNotifier storyNotifier) => storyNotifier.currentStory);

  return items.isEmpty
      ? isCodeView
          ? const SizedBox()
          : const Center(child: Text('No knobs'))
      : ListView.separated(
          key: ValueKey(currentStoryName ?? currentStory?.name ?? ''),
          primary: false,
          padding: EdgeInsets.symmetric(vertical: isSidePanel ? 16.0 : 0.0),
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index].build(),
        );
}

Widget _buildWrapper(BuildContext context, Widget? child) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectKnobDropdownStateManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => KnobsNotifier(context.read<StoryNotifier>()),
        ),
      ],
      builder: (BuildContext context, Widget? _) {
        final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
        final bool isPage = storyNotifier.currentStory?.isPage == true;
        final bool isErrorScreen = !(storyNotifier.hasRouteMatch ?? true);

        return isPage || isErrorScreen
            ? child!
            : switch (context.watch<EffectiveLayout>()) {
                EffectiveLayout.compact => child!,
                EffectiveLayout.expanded => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(child: child ?? const SizedBox.shrink()),
                        TapRegion(
                          onTapOutside: (PointerDownEvent _) {
                            context.read<SelectKnobDropdownStateManager>().popDropdown();
                          },
                          child: RepaintBoundary(
                            child: Material(
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                child: SafeArea(
                                  left: false,
                                  child: SizedBox(
                                    width: 250,
                                    child: Navigator(
                                      onGenerateRoute: (_) => PageRouteBuilder<void>(
                                        pageBuilder: (BuildContext context, _, __) => _buildPanel(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              };
      },
    );

extension Knobs on BuildContext {
  KnobsBuilder get knobs => watch<KnobsNotifier>();
}

class KnobsNotifier extends ChangeNotifier implements KnobsBuilder {
  KnobsNotifier(this._storyNotifier) {
    _storyNotifier.addListener(_onStoryChanged);
  }

  final StoryNotifier _storyNotifier;
  final Map<String, Map<String, Knob<dynamic>>> _knobs = {};

  @override
  late final nullable = _NullableKnobsBuilder(this);

  void _onStoryChanged() => notifyListeners();

  void update<T>(String label, T value) {
    final story = _storyNotifier.currentStory;
    if (story == null) return;

    final String? currentStoryName = _storyNotifier.storyRouteName;

    _knobs[currentStoryName ?? story.name]![label]!.value = value;

    notifyListeners();
  }

  T get<T>(String label) {
    // ignore: avoid-non-null-assertion, having null here is a bug
    final story = _storyNotifier.currentStory!;
    final String? routeStoryName = _storyNotifier.storyRouteName;

    return _knobs[routeStoryName ?? story.name]![label]!.value as T;
  }

  List<Knob<dynamic>> all() {
    final story = _storyNotifier.currentStory;
    if (story == null) return [];

    final String? routeStoryName = _storyNotifier.storyRouteName;

    return _knobs[routeStoryName ?? story.name]?.values.toList() ?? [];
  }

  T _addKnob<T>(Knob<T> value) {
    // ignore: avoid-non-null-assertion, having null here is a bug
    final story = _storyNotifier.currentStory!;
    final String? routeStoryName = _storyNotifier.storyRouteName;

    final knobs = _knobs.putIfAbsent(routeStoryName ?? story.name, () => {});

    return (knobs.putIfAbsent(value.label, () {
      Future.microtask(notifyListeners);

      return value;
    }) as Knob<T>)
        .value;
  }

  @override
  bool boolean({
    required String label,
    String? description,
    bool initial = false,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: BoolKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  String text({
    required String label,
    String? description,
    String initial = '',
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: StringKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  T options<T>({
    required String label,
    String? description,
    required T initial,
    List<Option<T>> options = const [],
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SelectKnobValue(
            value: initial,
            options: options,
          ),
        ),
      );

  @override
  double slider({
    required String label,
    String? description,
    double? initial,
    double max = 1,
    double min = 0,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: initial ?? min,
            max: max,
            min: min,
          ),
        ),
      );

  @override
  int sliderInt({
    required String label,
    String? description,
    int? initial,
    int max = 100,
    int min = 0,
    int? divisions,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: (initial ?? min).toDouble(),
            max: max.toDouble(),
            min: min.toDouble(),
            divisions: divisions,
            formatValue: (v) => v.toInt().toString(),
          ),
        ),
      ).toInt();

  @override
  void dispose() {
    _storyNotifier.removeListener(_onStoryChanged);
    super.dispose();
  }
}

class _NullableKnobsBuilder extends NullableKnobsBuilder {
  const _NullableKnobsBuilder(this._knobs);

  final KnobsNotifier _knobs;

  @override
  bool? boolean({
    required String label,
    String? description,
    bool initial = false,
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: BoolKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  T? options<T>({
    required String label,
    String? description,
    required T initial,
    List<Option<T>> options = const [],
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: SelectKnobValue(
            value: initial,
            options: options,
          ),
        ),
      );

  @override
  double? slider({
    required String label,
    String? description,
    double? initial,
    double max = 1,
    double min = 0,
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: initial ?? min,
            max: max,
            min: min,
          ),
        ),
      );

  @override
  int? sliderInt({
    required String label,
    String? description,
    int? initial,
    int max = 100,
    int min = 0,
    int? divisions,
    bool enabled = true,
  }) =>
      _knobs
          ._addKnob(
            NullableKnob(
              enabled: enabled,
              label: label,
              description: description,
              knobValue: SliderKnobValue(
                value: (initial ?? min).toDouble(),
                max: max.toDouble(),
                min: min.toDouble(),
                divisions: divisions,
                formatValue: (v) => v.toInt().toString(),
              ),
            ),
          )
          ?.toInt();

  @override
  String? text({
    required String label,
    String? description,
    String initial = '',
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: StringKnobValue(
            value: initial,
          ),
        ),
      );
}
