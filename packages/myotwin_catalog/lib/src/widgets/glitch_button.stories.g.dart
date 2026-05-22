// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'glitch_button.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<GlitchButton, GlitchButtonArgs>;
typedef _Scenario = GlitchButtonScenario;
typedef _Defaults = GlitchButtonDefaults;
typedef _Story = GlitchButtonStory;
typedef _Args = GlitchButtonArgs;
final GlitchButtonComponent = Component<GlitchButton, GlitchButtonArgs>(
  name: meta.name ?? 'GlitchButton',
  path: meta.path ?? 'widgets',
  docsBuilder: meta.docsBuilder,
  docComment:
      r'''A button with a holographic glitch effect that triggers on state transitions
and press events.''',
  stories: [
    $Default..$generatedName = 'Default',
    $Disabled..$generatedName = 'Disabled',
  ],
);
typedef GlitchButtonScenario = Scenario<GlitchButton, GlitchButtonArgs>;
typedef GlitchButtonDefaults = Defaults<GlitchButton, GlitchButtonArgs>;

class GlitchButtonStory extends Story<GlitchButton, GlitchButtonArgs> {
  GlitchButtonStory({
    super.name,
    super.setup,
    super.modes,
    required super.args,
    StoryWidgetBuilder<GlitchButton, GlitchButtonArgs>? builder,
    super.scenarios,
  }) : super(
         builder:
             builder ??
             (context, args) => GlitchButton(
               key: args.key,
               onPressed: args.onPressed,
               child: args.child,
               enabled: args.enabled,
               style: args.style,
             ),
       );
}

class GlitchButtonArgs extends StoryArgs<GlitchButton> {
  GlitchButtonArgs({
    Arg<Key?>? key,
    required Arg<void Function()> onPressed,
    required Arg<Widget> child,
    Arg<bool>? enabled,
    Arg<TextStyle?>? style,
  }) : this.keyArg = $initArg('key', key, null),
       this.onPressedArg = $initArg('onPressed', onPressed, null)!,
       this.childArg = $initArg('child', child, null)!,
       this.enabledArg = $initArg('enabled', enabled, BoolArg(true))!,
       this.styleArg = $initArg('style', style, null);

  GlitchButtonArgs.fixed({
    Key? key,
    required void Function() onPressed,
    required Widget child,
    bool enabled = true,
    TextStyle? style,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.onPressedArg = Arg.fixed(onPressed),
       this.childArg = Arg.fixed(child),
       this.enabledArg = Arg.fixed(enabled),
       this.styleArg = style == null ? null : Arg.fixed(style);

  final Arg<Key?>? keyArg;

  final Arg<void Function()> onPressedArg;

  final Arg<Widget> childArg;

  final Arg<bool> enabledArg;

  final Arg<TextStyle?>? styleArg;

  Key? get key => keyArg?.value;

  void Function() get onPressed => onPressedArg.value;

  Widget get child => childArg.value;

  bool get enabled => enabledArg.value;

  TextStyle? get style => styleArg?.value;

  @override
  List<Arg?> get list => [keyArg, onPressedArg, childArg, enabledArg, styleArg];
}
