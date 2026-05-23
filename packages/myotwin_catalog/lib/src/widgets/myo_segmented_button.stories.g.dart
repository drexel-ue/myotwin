// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_segmented_button.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component =
    Component<SegmentedButtonWrapper, SegmentedButtonWrapperArgs>;
typedef _Scenario = SegmentedButtonWrapperScenario;
typedef _Defaults = SegmentedButtonWrapperDefaults;
typedef _Story = SegmentedButtonWrapperStory;
typedef _Args = SegmentedButtonWrapperArgs;
final SegmentedButtonWrapperComponent =
    Component<SegmentedButtonWrapper, SegmentedButtonWrapperArgs>(
      name: meta.name ?? 'SegmentedButtonWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoSegmentedButton]
within the Widgetbook.''',
      stories: [
        $Default..$generatedName = 'Default',
        $WithIcons..$generatedName = 'WithIcons',
      ],
    );
typedef SegmentedButtonWrapperScenario =
    Scenario<SegmentedButtonWrapper, SegmentedButtonWrapperArgs>;
typedef SegmentedButtonWrapperDefaults =
    Defaults<SegmentedButtonWrapper, SegmentedButtonWrapperArgs>;

class SegmentedButtonWrapperStory
    extends Story<SegmentedButtonWrapper, SegmentedButtonWrapperArgs> {
  SegmentedButtonWrapperStory({
    super.name,
    super.setup,
    super.modes,
    required super.args,
    StoryWidgetBuilder<SegmentedButtonWrapper, SegmentedButtonWrapperArgs>?
    builder,
    super.scenarios,
  }) : super(
         builder:
             builder ??
             (context, args) => SegmentedButtonWrapper(
               key: args.key,
               initialValue: args.initialValue,
               segments: args.segments,
             ),
       );
}

class SegmentedButtonWrapperArgs extends StoryArgs<SegmentedButtonWrapper> {
  SegmentedButtonWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? initialValue,
    required Arg<List<MyoSegment<String>>> segments,
  }) : this.keyArg = $initArg('key', key, null),
       this.initialValueArg = $initArg(
         'initialValue',
         initialValue,
         StringArg(''),
       )!,
       this.segmentsArg = $initArg('segments', segments, null)!;

  SegmentedButtonWrapperArgs.fixed({
    Key? key,
    String initialValue = '',
    required List<MyoSegment<String>> segments,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.initialValueArg = Arg.fixed(initialValue),
       this.segmentsArg = Arg.fixed(segments);

  final Arg<Key?>? keyArg;

  final Arg<String> initialValueArg;

  final Arg<List<MyoSegment<String>>> segmentsArg;

  Key? get key => keyArg?.value;

  String get initialValue => initialValueArg.value;

  List<MyoSegment<String>> get segments => segmentsArg.value;

  @override
  List<Arg?> get list => [keyArg, initialValueArg, segmentsArg];
}
