// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'frosted_hud.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<FrostedHUD, FrostedHUDArgs>;
typedef _Scenario = FrostedHUDScenario;
typedef _Defaults = FrostedHUDDefaults;
typedef _Story = FrostedHUDStory;
typedef _Args = FrostedHUDArgs;
final FrostedHUDComponent = Component<FrostedHUD, FrostedHUDArgs>(
  name: meta.name ?? 'FrostedHUD',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment:
      r'''A holographic frosted-glass HUD panel with radiating laser effects.''',
  stories: [$Default..$generatedName = 'Default'],
);
typedef FrostedHUDScenario = Scenario<FrostedHUD, FrostedHUDArgs>;
typedef FrostedHUDDefaults = Defaults<FrostedHUD, FrostedHUDArgs>;

class FrostedHUDStory extends Story<FrostedHUD, FrostedHUDArgs> {
  FrostedHUDStory({
    super.name,
    super.setup,
    super.modes,
    required super.args,
    StoryWidgetBuilder<FrostedHUD, FrostedHUDArgs>? builder,
    super.scenarios,
  }) : super(
         builder:
             builder ??
             (context, args) => FrostedHUD(
               key: args.key,
               title: args.title,
               child: args.child,
               impactPoint: args.impactPoint,
               animationProgress: args.animationProgress,
               glitchIntensity: args.glitchIntensity,
             ),
       );
}

class FrostedHUDArgs extends StoryArgs<FrostedHUD> {
  FrostedHUDArgs({
    Arg<Key?>? key,
    Arg<String?>? title,
    required Arg<Widget> child,
    required Arg<Offset> impactPoint,
    Arg<double>? animationProgress,
    Arg<double>? glitchIntensity,
  }) : this.keyArg = $initArg('key', key, null),
       this.titleArg = $initArg('title', title, NullableStringArg(null))!,
       this.childArg = $initArg('child', child, null)!,
       this.impactPointArg = $initArg('impactPoint', impactPoint, null)!,
       this.animationProgressArg = $initArg(
         'animationProgress',
         animationProgress,
         DoubleArg(1.0),
       )!,
       this.glitchIntensityArg = $initArg(
         'glitchIntensity',
         glitchIntensity,
         DoubleArg(0.2),
       )!;

  FrostedHUDArgs.fixed({
    Key? key,
    String? title = null,
    required Widget child,
    required Offset impactPoint,
    double animationProgress = 1.0,
    double glitchIntensity = 0.2,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.titleArg = title == null ? null : Arg.fixed(title),
       this.childArg = Arg.fixed(child),
       this.impactPointArg = Arg.fixed(impactPoint),
       this.animationProgressArg = Arg.fixed(animationProgress),
       this.glitchIntensityArg = Arg.fixed(glitchIntensity);

  final Arg<Key?>? keyArg;

  final Arg<String?>? titleArg;

  final Arg<Widget> childArg;

  final Arg<Offset> impactPointArg;

  final Arg<double> animationProgressArg;

  final Arg<double> glitchIntensityArg;

  Key? get key => keyArg?.value;

  String? get title => titleArg?.value;

  Widget get child => childArg.value;

  Offset get impactPoint => impactPointArg.value;

  double get animationProgress => animationProgressArg.value;

  double get glitchIntensity => glitchIntensityArg.value;

  @override
  List<Arg?> get list => [
    keyArg,
    titleArg,
    childArg,
    impactPointArg,
    animationProgressArg,
    glitchIntensityArg,
  ];
}
