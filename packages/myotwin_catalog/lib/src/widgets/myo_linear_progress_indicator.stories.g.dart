// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_linear_progress_indicator.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component =
    Component<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs>;
typedef _Scenario = ProgressIndicatorWrapperScenario;
typedef _Defaults = ProgressIndicatorWrapperDefaults;
typedef _Story = ProgressIndicatorWrapperStory;
typedef _Args = ProgressIndicatorWrapperArgs;
final ProgressIndicatorWrapperComponent =
    Component<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs>(
      name: meta.name ?? 'ProgressIndicatorWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoLinearProgressIndicator]
within the Widgetbook.''',
      stories: [
        $InfiniteWhite..$generatedName = 'InfiniteWhite',
        $InfiniteError..$generatedName = 'InfiniteError',
        $FixedWhite..$generatedName = 'FixedWhite',
        $FixedError..$generatedName = 'FixedError',
      ],
    );
typedef ProgressIndicatorWrapperScenario =
    Scenario<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs>;
typedef ProgressIndicatorWrapperDefaults =
    Defaults<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs>;

class ProgressIndicatorWrapperStory
    extends Story<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs> {
  ProgressIndicatorWrapperStory({
    super.name,
    super.setup,
    super.modes,
    ProgressIndicatorWrapperArgs? args,
    StoryWidgetBuilder<ProgressIndicatorWrapper, ProgressIndicatorWrapperArgs>?
    builder,
    super.scenarios,
  }) : super(
         args: args ?? ProgressIndicatorWrapperArgs(),
         builder:
             builder ??
             (context, args) => ProgressIndicatorWrapper(
               key: args.key,
               initialProgress: args.initialProgress,
               style: args.style,
               isInfinite: args.isInfinite,
             ),
       );
}

class ProgressIndicatorWrapperArgs extends StoryArgs<ProgressIndicatorWrapper> {
  ProgressIndicatorWrapperArgs({
    Arg<Key?>? key,
    Arg<double?>? initialProgress,
    Arg<MyoLinearProgressStyle>? style,
    Arg<bool>? isInfinite,
  }) : this.keyArg = $initArg('key', key, null),
       this.initialProgressArg = $initArg(
         'initialProgress',
         initialProgress,
         NullableDoubleArg(null),
       )!,
       this.styleArg = $initArg(
         'style',
         style,
         EnumArg<MyoLinearProgressStyle>(
           MyoLinearProgressStyle.white,
           values: MyoLinearProgressStyle.values,
         ),
       )!,
       this.isInfiniteArg = $initArg('isInfinite', isInfinite, BoolArg(false))!;

  ProgressIndicatorWrapperArgs.fixed({
    Key? key,
    double? initialProgress = null,
    MyoLinearProgressStyle style = MyoLinearProgressStyle.white,
    bool isInfinite = false,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.initialProgressArg = initialProgress == null
           ? null
           : Arg.fixed(initialProgress),
       this.styleArg = Arg.fixed(style),
       this.isInfiniteArg = Arg.fixed(isInfinite);

  final Arg<Key?>? keyArg;

  final Arg<double?>? initialProgressArg;

  final Arg<MyoLinearProgressStyle> styleArg;

  final Arg<bool> isInfiniteArg;

  Key? get key => keyArg?.value;

  double? get initialProgress => initialProgressArg?.value;

  MyoLinearProgressStyle get style => styleArg.value;

  bool get isInfinite => isInfiniteArg.value;

  @override
  List<Arg?> get list => [keyArg, initialProgressArg, styleArg, isInfiniteArg];
}
