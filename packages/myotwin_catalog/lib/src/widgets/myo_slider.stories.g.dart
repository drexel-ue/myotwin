// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_slider.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<MyoSliderWrapper, MyoSliderWrapperArgs>;
typedef _Scenario = MyoSliderWrapperScenario;
typedef _Defaults = MyoSliderWrapperDefaults;
typedef _Story = MyoSliderWrapperStory;
typedef _Args = MyoSliderWrapperArgs;
final MyoSliderWrapperComponent =
    Component<MyoSliderWrapper, MyoSliderWrapperArgs>(
      name: meta.name ?? 'MyoSliderWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoSlider]
within the Widgetbook.''',
      stories: [
        $Default..$generatedName = 'Default',
        $Discrete..$generatedName = 'Discrete',
        $Extended..$generatedName = 'Extended',
      ],
    );
typedef MyoSliderWrapperScenario =
    Scenario<MyoSliderWrapper, MyoSliderWrapperArgs>;
typedef MyoSliderWrapperDefaults =
    Defaults<MyoSliderWrapper, MyoSliderWrapperArgs>;

class MyoSliderWrapperStory
    extends Story<MyoSliderWrapper, MyoSliderWrapperArgs> {
  MyoSliderWrapperStory({
    super.name,
    super.setup,
    super.modes,
    MyoSliderWrapperArgs? args,
    StoryWidgetBuilder<MyoSliderWrapper, MyoSliderWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? MyoSliderWrapperArgs(),
         builder:
             builder ??
             (context, args) => MyoSliderWrapper(
               key: args.key,
               value: args.value,
               min: args.min,
               max: args.max,
               divisions: args.divisions,
               highlightColor: args.highlightColor,
               trackColor: args.trackColor,
               thumbColor: args.thumbColor,
               activeColor: args.activeColor,
               tickColor: args.tickColor,
             ),
       );
}

class MyoSliderWrapperArgs extends StoryArgs<MyoSliderWrapper> {
  MyoSliderWrapperArgs({
    Arg<Key?>? key,
    Arg<double>? value,
    Arg<double>? min,
    Arg<double>? max,
    Arg<int?>? divisions,
    Arg<Color?>? highlightColor,
    Arg<Color?>? trackColor,
    Arg<Color?>? thumbColor,
    Arg<Color?>? activeColor,
    Arg<Color?>? tickColor,
  }) : this.keyArg = $initArg('key', key, null),
       this.valueArg = $initArg('value', value, DoubleArg(0.5))!,
       this.minArg = $initArg('min', min, DoubleArg(0.0))!,
       this.maxArg = $initArg('max', max, DoubleArg(1.0))!,
       this.divisionsArg = $initArg(
         'divisions',
         divisions,
         NullableIntArg(null),
       )!,
       this.highlightColorArg = $initArg(
         'highlightColor',
         highlightColor,
         NullableColorArg(null),
       )!,
       this.trackColorArg = $initArg(
         'trackColor',
         trackColor,
         NullableColorArg(null),
       )!,
       this.thumbColorArg = $initArg(
         'thumbColor',
         thumbColor,
         NullableColorArg(null),
       )!,
       this.activeColorArg = $initArg(
         'activeColor',
         activeColor,
         NullableColorArg(null),
       )!,
       this.tickColorArg = $initArg(
         'tickColor',
         tickColor,
         NullableColorArg(null),
       )!;

  MyoSliderWrapperArgs.fixed({
    Key? key,
    double value = 0.5,
    double min = 0.0,
    double max = 1.0,
    int? divisions = null,
    Color? highlightColor = null,
    Color? trackColor = null,
    Color? thumbColor = null,
    Color? activeColor = null,
    Color? tickColor = null,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.valueArg = Arg.fixed(value),
       this.minArg = Arg.fixed(min),
       this.maxArg = Arg.fixed(max),
       this.divisionsArg = divisions == null ? null : Arg.fixed(divisions),
       this.highlightColorArg = highlightColor == null
           ? null
           : Arg.fixed(highlightColor),
       this.trackColorArg = trackColor == null ? null : Arg.fixed(trackColor),
       this.thumbColorArg = thumbColor == null ? null : Arg.fixed(thumbColor),
       this.activeColorArg = activeColor == null
           ? null
           : Arg.fixed(activeColor),
       this.tickColorArg = tickColor == null ? null : Arg.fixed(tickColor);

  final Arg<Key?>? keyArg;

  final Arg<double> valueArg;

  final Arg<double> minArg;

  final Arg<double> maxArg;

  final Arg<int?>? divisionsArg;

  final Arg<Color?>? highlightColorArg;

  final Arg<Color?>? trackColorArg;

  final Arg<Color?>? thumbColorArg;

  final Arg<Color?>? activeColorArg;

  final Arg<Color?>? tickColorArg;

  Key? get key => keyArg?.value;

  double get value => valueArg.value;

  double get min => minArg.value;

  double get max => maxArg.value;

  int? get divisions => divisionsArg?.value;

  Color? get highlightColor => highlightColorArg?.value;

  Color? get trackColor => trackColorArg?.value;

  Color? get thumbColor => thumbColorArg?.value;

  Color? get activeColor => activeColorArg?.value;

  Color? get tickColor => tickColorArg?.value;

  @override
  List<Arg?> get list => [
    keyArg,
    valueArg,
    minArg,
    maxArg,
    divisionsArg,
    highlightColorArg,
    trackColorArg,
    thumbColorArg,
    activeColorArg,
    tickColorArg,
  ];
}
