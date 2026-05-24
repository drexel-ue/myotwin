// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_chip.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<ChipWrapper, ChipWrapperArgs>;
typedef _Scenario = ChipWrapperScenario;
typedef _Defaults = ChipWrapperDefaults;
typedef _Story = ChipWrapperStory;
typedef _Args = ChipWrapperArgs;
final ChipWrapperComponent = Component<ChipWrapper, ChipWrapperArgs>(
  name: meta.name ?? 'ChipWrapper',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment: r'''A stateful wrapper to allow interactive testing of [MyoChip]
within the Widgetbook.''',
  stories: [
    $Default..$generatedName = 'Default',
    $Filled..$generatedName = 'Filled',
    $Outlined..$generatedName = 'Outlined',
  ],
);
typedef ChipWrapperScenario = Scenario<ChipWrapper, ChipWrapperArgs>;
typedef ChipWrapperDefaults = Defaults<ChipWrapper, ChipWrapperArgs>;

class ChipWrapperStory extends Story<ChipWrapper, ChipWrapperArgs> {
  ChipWrapperStory({
    super.name,
    super.setup,
    super.modes,
    ChipWrapperArgs? args,
    StoryWidgetBuilder<ChipWrapper, ChipWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? ChipWrapperArgs(),
         builder:
             builder ??
             (context, args) => ChipWrapper(
               key: args.key,
               label: args.label,
               initialSelected: args.initialSelected,
               style: args.style,
             ),
       );
}

class ChipWrapperArgs extends StoryArgs<ChipWrapper> {
  ChipWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? label,
    Arg<bool>? initialSelected,
    Arg<MyoChipStyle>? style,
  }) : this.keyArg = $initArg('key', key, null),
       this.labelArg = $initArg('label', label, StringArg(''))!,
       this.initialSelectedArg = $initArg(
         'initialSelected',
         initialSelected,
         BoolArg(false),
       )!,
       this.styleArg = $initArg(
         'style',
         style,
         EnumArg<MyoChipStyle>(
           MyoChipStyle.filled,
           values: MyoChipStyle.values,
         ),
       )!;

  ChipWrapperArgs.fixed({
    Key? key,
    String label = '',
    bool initialSelected = false,
    MyoChipStyle style = MyoChipStyle.filled,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.labelArg = Arg.fixed(label),
       this.initialSelectedArg = Arg.fixed(initialSelected),
       this.styleArg = Arg.fixed(style);

  final Arg<Key?>? keyArg;

  final Arg<String> labelArg;

  final Arg<bool> initialSelectedArg;

  final Arg<MyoChipStyle> styleArg;

  Key? get key => keyArg?.value;

  String get label => labelArg.value;

  bool get initialSelected => initialSelectedArg.value;

  MyoChipStyle get style => styleArg.value;

  @override
  List<Arg?> get list => [keyArg, labelArg, initialSelectedArg, styleArg];
}
