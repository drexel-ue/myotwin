// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_switch.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<SwitchWrapper, SwitchWrapperArgs>;
typedef _Scenario = SwitchWrapperScenario;
typedef _Defaults = SwitchWrapperDefaults;
typedef _Story = SwitchWrapperStory;
typedef _Args = SwitchWrapperArgs;
final SwitchWrapperComponent = Component<SwitchWrapper, SwitchWrapperArgs>(
  name: meta.name ?? 'SwitchWrapper',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment: r'''A stateful wrapper to allow interactive testing of [MyoSwitch]
within the Widgetbook.''',
  stories: [
    $Default..$generatedName = 'Default',
    $Toggled..$generatedName = 'Toggled',
    $RedSwitch..$generatedName = 'RedSwitch',
  ],
);
typedef SwitchWrapperScenario = Scenario<SwitchWrapper, SwitchWrapperArgs>;
typedef SwitchWrapperDefaults = Defaults<SwitchWrapper, SwitchWrapperArgs>;

class SwitchWrapperStory extends Story<SwitchWrapper, SwitchWrapperArgs> {
  SwitchWrapperStory({
    super.name,
    super.setup,
    super.modes,
    SwitchWrapperArgs? args,
    StoryWidgetBuilder<SwitchWrapper, SwitchWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? SwitchWrapperArgs(),
         builder:
             builder ??
             (context, args) => SwitchWrapper(
               key: args.key,
               initialValue: args.initialValue,
               activeColor: args.activeColor,
               inactiveColor: args.inactiveColor,
               thumbColor: args.thumbColor,
             ),
       );
}

class SwitchWrapperArgs extends StoryArgs<SwitchWrapper> {
  SwitchWrapperArgs({
    Arg<Key?>? key,
    Arg<bool>? initialValue,
    Arg<Color?>? activeColor,
    Arg<Color?>? inactiveColor,
    Arg<Color?>? thumbColor,
  }) : this.keyArg = $initArg('key', key, null),
       this.initialValueArg = $initArg(
         'initialValue',
         initialValue,
         BoolArg(false),
       )!,
       this.activeColorArg = $initArg(
         'activeColor',
         activeColor,
         NullableColorArg(null),
       )!,
       this.inactiveColorArg = $initArg(
         'inactiveColor',
         inactiveColor,
         NullableColorArg(null),
       )!,
       this.thumbColorArg = $initArg(
         'thumbColor',
         thumbColor,
         NullableColorArg(null),
       )!;

  SwitchWrapperArgs.fixed({
    Key? key,
    bool initialValue = false,
    Color? activeColor = null,
    Color? inactiveColor = null,
    Color? thumbColor = null,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.initialValueArg = Arg.fixed(initialValue),
       this.activeColorArg = activeColor == null
           ? null
           : Arg.fixed(activeColor),
       this.inactiveColorArg = inactiveColor == null
           ? null
           : Arg.fixed(inactiveColor),
       this.thumbColorArg = thumbColor == null ? null : Arg.fixed(thumbColor);

  final Arg<Key?>? keyArg;

  final Arg<bool> initialValueArg;

  final Arg<Color?>? activeColorArg;

  final Arg<Color?>? inactiveColorArg;

  final Arg<Color?>? thumbColorArg;

  Key? get key => keyArg?.value;

  bool get initialValue => initialValueArg.value;

  Color? get activeColor => activeColorArg?.value;

  Color? get inactiveColor => inactiveColorArg?.value;

  Color? get thumbColor => thumbColorArg?.value;

  @override
  List<Arg?> get list => [
    keyArg,
    initialValueArg,
    activeColorArg,
    inactiveColorArg,
    thumbColorArg,
  ];
}
