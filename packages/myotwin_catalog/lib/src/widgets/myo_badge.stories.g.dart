// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_badge.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<BadgeWrapper, BadgeWrapperArgs>;
typedef _Scenario = BadgeWrapperScenario;
typedef _Defaults = BadgeWrapperDefaults;
typedef _Story = BadgeWrapperStory;
typedef _Args = BadgeWrapperArgs;
final BadgeWrapperComponent = Component<BadgeWrapper, BadgeWrapperArgs>(
  name: meta.name ?? 'BadgeWrapper',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment: r'''A stateful wrapper to allow interactive testing of [MyoBadge]
within the Widgetbook.''',
  stories: [
    $Default..$generatedName = 'Default',
    $ErrorFilled..$generatedName = 'ErrorFilled',
    $ErrorOutlined..$generatedName = 'ErrorOutlined',
    $WhiteOutlined..$generatedName = 'WhiteOutlined',
  ],
);
typedef BadgeWrapperScenario = Scenario<BadgeWrapper, BadgeWrapperArgs>;
typedef BadgeWrapperDefaults = Defaults<BadgeWrapper, BadgeWrapperArgs>;

class BadgeWrapperStory extends Story<BadgeWrapper, BadgeWrapperArgs> {
  BadgeWrapperStory({
    super.name,
    super.setup,
    super.modes,
    BadgeWrapperArgs? args,
    StoryWidgetBuilder<BadgeWrapper, BadgeWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? BadgeWrapperArgs(),
         builder:
             builder ??
             (context, args) => BadgeWrapper(
               key: args.key,
               initialCount: args.initialCount,
               style: args.style,
             ),
       );
}

class BadgeWrapperArgs extends StoryArgs<BadgeWrapper> {
  BadgeWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? initialCount,
    Arg<MyoBadgeStyle>? style,
  }) : this.keyArg = $initArg('key', key, null),
       this.initialCountArg = $initArg(
         'initialCount',
         initialCount,
         StringArg(''),
       )!,
       this.styleArg = $initArg(
         'style',
         style,
         EnumArg<MyoBadgeStyle>(
           MyoBadgeStyle.filledWhite,
           values: MyoBadgeStyle.values,
         ),
       )!;

  BadgeWrapperArgs.fixed({
    Key? key,
    String initialCount = '',
    MyoBadgeStyle style = MyoBadgeStyle.filledWhite,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.initialCountArg = Arg.fixed(initialCount),
       this.styleArg = Arg.fixed(style);

  final Arg<Key?>? keyArg;

  final Arg<String> initialCountArg;

  final Arg<MyoBadgeStyle> styleArg;

  Key? get key => keyArg?.value;

  String get initialCount => initialCountArg.value;

  MyoBadgeStyle get style => styleArg.value;

  @override
  List<Arg?> get list => [keyArg, initialCountArg, styleArg];
}
