// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_icon_button.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<MyoIconButton, MyoIconButtonArgs>;
typedef _Scenario = MyoIconButtonScenario;
typedef _Defaults = MyoIconButtonDefaults;
typedef _Story = MyoIconButtonStory;
typedef _Args = MyoIconButtonArgs;
final MyoIconButtonComponent = Component<MyoIconButton, MyoIconButtonArgs>(
  name: meta.name ?? 'MyoIconButton',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment:
      r'''A button that uses a [MyoIcon] as its primary visual, featuring a
holographic glitch effect on interaction.''',
  stories: [
    $Default..$generatedName = 'Default',
    $Disabled..$generatedName = 'Disabled',
    $Corrupted..$generatedName = 'Corrupted',
  ],
);
typedef MyoIconButtonScenario = Scenario<MyoIconButton, MyoIconButtonArgs>;
typedef MyoIconButtonDefaults = Defaults<MyoIconButton, MyoIconButtonArgs>;

class MyoIconButtonStory extends Story<MyoIconButton, MyoIconButtonArgs> {
  MyoIconButtonStory({
    super.name,
    super.setup,
    super.modes,
    required super.args,
    StoryWidgetBuilder<MyoIconButton, MyoIconButtonArgs>? builder,
    super.scenarios,
  }) : super(
         builder:
             builder ??
             (context, args) => MyoIconButton(
               key: args.key,
               onPressed: args.onPressed,
               intent: args.intent,
               fallbackIntent: args.fallbackIntent,
               enabled: args.enabled,
               size: args.size,
               color: args.color,
             ),
       );
}

class MyoIconButtonArgs extends StoryArgs<MyoIconButton> {
  MyoIconButtonArgs({
    Arg<Key?>? key,
    required Arg<void Function()> onPressed,
    Arg<String>? intent,
    Arg<String?>? fallbackIntent,
    Arg<bool>? enabled,
    Arg<double>? size,
    Arg<Color?>? color,
  }) : this.keyArg = $initArg('key', key, null),
       this.onPressedArg = $initArg('onPressed', onPressed, null)!,
       this.intentArg = $initArg('intent', intent, StringArg(''))!,
       this.fallbackIntentArg = $initArg(
         'fallbackIntent',
         fallbackIntent,
         NullableStringArg(null),
       )!,
       this.enabledArg = $initArg('enabled', enabled, BoolArg(true))!,
       this.sizeArg = $initArg('size', size, DoubleArg(spacing24))!,
       this.colorArg = $initArg('color', color, NullableColorArg(null))!;

  MyoIconButtonArgs.fixed({
    Key? key,
    required void Function() onPressed,
    String intent = '',
    String? fallbackIntent = null,
    bool enabled = true,
    double size = spacing24,
    Color? color = null,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.onPressedArg = Arg.fixed(onPressed),
       this.intentArg = Arg.fixed(intent),
       this.fallbackIntentArg = fallbackIntent == null
           ? null
           : Arg.fixed(fallbackIntent),
       this.enabledArg = Arg.fixed(enabled),
       this.sizeArg = Arg.fixed(size),
       this.colorArg = color == null ? null : Arg.fixed(color);

  final Arg<Key?>? keyArg;

  final Arg<void Function()> onPressedArg;

  final Arg<String> intentArg;

  final Arg<String?>? fallbackIntentArg;

  final Arg<bool> enabledArg;

  final Arg<double> sizeArg;

  final Arg<Color?>? colorArg;

  Key? get key => keyArg?.value;

  void Function() get onPressed => onPressedArg.value;

  String get intent => intentArg.value;

  String? get fallbackIntent => fallbackIntentArg?.value;

  bool get enabled => enabledArg.value;

  double get size => sizeArg.value;

  Color? get color => colorArg?.value;

  @override
  List<Arg?> get list => [
    keyArg,
    onPressedArg,
    intentArg,
    fallbackIntentArg,
    enabledArg,
    sizeArg,
    colorArg,
  ];
}
