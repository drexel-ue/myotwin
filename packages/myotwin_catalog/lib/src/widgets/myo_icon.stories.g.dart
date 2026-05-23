// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_icon.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<MyoIcon, MyoIconArgs>;
typedef _Scenario = MyoIconScenario;
typedef _Defaults = MyoIconDefaults;
typedef _Story = MyoIconStory;
typedef _Args = MyoIconArgs;
final MyoIconComponent = Component<MyoIcon, MyoIconArgs>(
  name: meta.name ?? 'MyoIcon',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment:
      r'''An AI-native icon widget that dynamically resolves a semantic [intent] into
an SVG asset at runtime.

If the intent cannot be resolved, it falls back to a
"Corrupted Sector" hardware glitch.''',
  stories: [
    $Default..$generatedName = 'Default',
    $Resolved..$generatedName = 'Resolved',
    $Corrupted..$generatedName = 'Corrupted',
  ],
);
typedef MyoIconScenario = Scenario<MyoIcon, MyoIconArgs>;
typedef MyoIconDefaults = Defaults<MyoIcon, MyoIconArgs>;

class MyoIconStory extends Story<MyoIcon, MyoIconArgs> {
  MyoIconStory({
    super.name,
    super.setup,
    super.modes,
    MyoIconArgs? args,
    StoryWidgetBuilder<MyoIcon, MyoIconArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? MyoIconArgs(),
         builder:
             builder ??
             (context, args) => MyoIcon(
               key: args.key,
               intent: args.intent,
               fallbackIntent: args.fallbackIntent,
               color: args.color,
               size: args.size,
             ),
       );
}

class MyoIconArgs extends StoryArgs<MyoIcon> {
  MyoIconArgs({
    Arg<Key?>? key,
    Arg<String>? intent,
    Arg<String?>? fallbackIntent,
    Arg<Color?>? color,
    Arg<double>? size,
  }) : this.keyArg = $initArg('key', key, null),
       this.intentArg = $initArg('intent', intent, StringArg(''))!,
       this.fallbackIntentArg = $initArg(
         'fallbackIntent',
         fallbackIntent,
         NullableStringArg(null),
       )!,
       this.colorArg = $initArg('color', color, NullableColorArg(null))!,
       this.sizeArg = $initArg('size', size, DoubleArg(spacing24))!;

  MyoIconArgs.fixed({
    Key? key,
    String intent = '',
    String? fallbackIntent = null,
    Color? color = null,
    double size = spacing24,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.intentArg = Arg.fixed(intent),
       this.fallbackIntentArg = fallbackIntent == null
           ? null
           : Arg.fixed(fallbackIntent),
       this.colorArg = color == null ? null : Arg.fixed(color),
       this.sizeArg = Arg.fixed(size);

  final Arg<Key?>? keyArg;

  final Arg<String> intentArg;

  final Arg<String?>? fallbackIntentArg;

  final Arg<Color?>? colorArg;

  final Arg<double> sizeArg;

  Key? get key => keyArg?.value;

  String get intent => intentArg.value;

  String? get fallbackIntent => fallbackIntentArg?.value;

  Color? get color => colorArg?.value;

  double get size => sizeArg.value;

  @override
  List<Arg?> get list => [
    keyArg,
    intentArg,
    fallbackIntentArg,
    colorArg,
    sizeArg,
  ];
}
