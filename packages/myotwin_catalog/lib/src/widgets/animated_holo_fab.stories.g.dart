// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'animated_holo_fab.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<AnimatedHoloFAB, AnimatedHoloFABArgs>;
typedef _Scenario = AnimatedHoloFABScenario;
typedef _Defaults = AnimatedHoloFABDefaults;
typedef _Story = AnimatedHoloFABStory;
typedef _Args = AnimatedHoloFABArgs;
final AnimatedHoloFABComponent =
    Component<AnimatedHoloFAB, AnimatedHoloFABArgs>(
      name: meta.name ?? 'AnimatedHoloFAB',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment: null,
      stories: [$Default..$generatedName = 'Default'],
    );
typedef AnimatedHoloFABScenario =
    Scenario<AnimatedHoloFAB, AnimatedHoloFABArgs>;
typedef AnimatedHoloFABDefaults =
    Defaults<AnimatedHoloFAB, AnimatedHoloFABArgs>;

class AnimatedHoloFABStory extends Story<AnimatedHoloFAB, AnimatedHoloFABArgs> {
  AnimatedHoloFABStory({
    super.name,
    super.setup,
    super.modes,
    required super.args,
    StoryWidgetBuilder<AnimatedHoloFAB, AnimatedHoloFABArgs>? builder,
    super.scenarios,
  }) : super(
         builder:
             builder ??
             (context, args) => AnimatedHoloFAB(
               key: args.key,
               onPressed: args.onPressed,
               icon: args.icon,
               activeColor: args.activeColor,
             ),
       );
}

class AnimatedHoloFABArgs extends StoryArgs<AnimatedHoloFAB> {
  AnimatedHoloFABArgs({
    Arg<Key?>? key,
    required Arg<void Function()> onPressed,
    required Arg<Widget> icon,
    Arg<Color>? activeColor,
  }) : this.keyArg = $initArg('key', key, null),
       this.onPressedArg = $initArg('onPressed', onPressed, null)!,
       this.iconArg = $initArg('icon', icon, null)!,
       this.activeColorArg = $initArg(
         'activeColor',
         activeColor,
         ColorArg(Colors.cyanAccent),
       )!;

  AnimatedHoloFABArgs.fixed({
    Key? key,
    required void Function() onPressed,
    required Widget icon,
    Color activeColor = Colors.cyanAccent,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.onPressedArg = Arg.fixed(onPressed),
       this.iconArg = Arg.fixed(icon),
       this.activeColorArg = Arg.fixed(activeColor);

  final Arg<Key?>? keyArg;

  final Arg<void Function()> onPressedArg;

  final Arg<Widget> iconArg;

  final Arg<Color> activeColorArg;

  Key? get key => keyArg?.value;

  void Function() get onPressed => onPressedArg.value;

  Widget get icon => iconArg.value;

  Color get activeColor => activeColorArg.value;

  @override
  List<Arg?> get list => [keyArg, onPressedArg, iconArg, activeColorArg];
}
