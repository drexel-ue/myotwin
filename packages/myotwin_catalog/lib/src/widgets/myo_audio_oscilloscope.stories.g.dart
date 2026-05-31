// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_audio_oscilloscope.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<OscilloscopeWrapper, OscilloscopeWrapperArgs>;
typedef _Scenario = OscilloscopeWrapperScenario;
typedef _Defaults = OscilloscopeWrapperDefaults;
typedef _Story = OscilloscopeWrapperStory;
typedef _Args = OscilloscopeWrapperArgs;
final OscilloscopeWrapperComponent =
    Component<OscilloscopeWrapper, OscilloscopeWrapperArgs>(
      name: meta.name ?? 'OscilloscopeWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment: null,
      stories: [$Default..$generatedName = 'Default'],
    );
typedef OscilloscopeWrapperScenario =
    Scenario<OscilloscopeWrapper, OscilloscopeWrapperArgs>;
typedef OscilloscopeWrapperDefaults =
    Defaults<OscilloscopeWrapper, OscilloscopeWrapperArgs>;

class OscilloscopeWrapperStory
    extends Story<OscilloscopeWrapper, OscilloscopeWrapperArgs> {
  OscilloscopeWrapperStory({
    super.name,
    super.setup,
    super.modes,
    OscilloscopeWrapperArgs? args,
    StoryWidgetBuilder<OscilloscopeWrapper, OscilloscopeWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? OscilloscopeWrapperArgs(),
         builder:
             builder ??
             (context, args) => OscilloscopeWrapper(
               key: args.key,
               isListening: args.isListening,
               strokeWidth: args.strokeWidth,
             ),
       );
}

class OscilloscopeWrapperArgs extends StoryArgs<OscilloscopeWrapper> {
  OscilloscopeWrapperArgs({
    Arg<Key?>? key,
    Arg<bool>? isListening,
    Arg<double>? strokeWidth,
  }) : this.keyArg = $initArg('key', key, null),
       this.isListeningArg = $initArg(
         'isListening',
         isListening,
         BoolArg(false),
       )!,
       this.strokeWidthArg = $initArg(
         'strokeWidth',
         strokeWidth,
         DoubleArg(0.0),
       )!;

  OscilloscopeWrapperArgs.fixed({
    Key? key,
    bool isListening = false,
    double strokeWidth = 0.0,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.isListeningArg = Arg.fixed(isListening),
       this.strokeWidthArg = Arg.fixed(strokeWidth);

  final Arg<Key?>? keyArg;

  final Arg<bool> isListeningArg;

  final Arg<double> strokeWidthArg;

  Key? get key => keyArg?.value;

  bool get isListening => isListeningArg.value;

  double get strokeWidth => strokeWidthArg.value;

  @override
  List<Arg?> get list => [keyArg, isListeningArg, strokeWidthArg];
}
