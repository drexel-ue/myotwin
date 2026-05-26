// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_canvas.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<MyoCanvasWrapper, MyoCanvasWrapperArgs>;
typedef _Scenario = MyoCanvasWrapperScenario;
typedef _Defaults = MyoCanvasWrapperDefaults;
typedef _Story = MyoCanvasWrapperStory;
typedef _Args = MyoCanvasWrapperArgs;
final MyoCanvasWrapperComponent =
    Component<MyoCanvasWrapper, MyoCanvasWrapperArgs>(
      name: meta.name ?? 'MyoCanvasWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment: null,
      stories: [$Default..$generatedName = 'Default'],
    );
typedef MyoCanvasWrapperScenario =
    Scenario<MyoCanvasWrapper, MyoCanvasWrapperArgs>;
typedef MyoCanvasWrapperDefaults =
    Defaults<MyoCanvasWrapper, MyoCanvasWrapperArgs>;

class MyoCanvasWrapperStory
    extends Story<MyoCanvasWrapper, MyoCanvasWrapperArgs> {
  MyoCanvasWrapperStory({
    super.name,
    super.setup,
    super.modes,
    MyoCanvasWrapperArgs? args,
    StoryWidgetBuilder<MyoCanvasWrapper, MyoCanvasWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? MyoCanvasWrapperArgs(),
         builder: builder ?? (context, args) => MyoCanvasWrapper(key: args.key),
       );
}

class MyoCanvasWrapperArgs extends StoryArgs<MyoCanvasWrapper> {
  MyoCanvasWrapperArgs({Arg<Key?>? key})
    : this.keyArg = $initArg('key', key, null);

  MyoCanvasWrapperArgs.fixed({Key? key})
    : this.keyArg = key == null ? null : Arg.fixed(key);

  final Arg<Key?>? keyArg;

  Key? get key => keyArg?.value;

  @override
  List<Arg?> get list => [keyArg];
}
