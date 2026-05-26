// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_checkbox_tile.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<CheckboxTileWrapper, CheckboxTileWrapperArgs>;
typedef _Scenario = CheckboxTileWrapperScenario;
typedef _Defaults = CheckboxTileWrapperDefaults;
typedef _Story = CheckboxTileWrapperStory;
typedef _Args = CheckboxTileWrapperArgs;
final CheckboxTileWrapperComponent =
    Component<CheckboxTileWrapper, CheckboxTileWrapperArgs>(
      name: meta.name ?? 'CheckboxTileWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper for [MyoListTile] with a [MyoCheckbox] as leading.
Demonstrates composition: MyoListTile + MyoCheckbox = checkbox tile.''',
      stories: [
        $Off..$generatedName = 'Off',
        $On..$generatedName = 'On',
        $NoSubtitle..$generatedName = 'NoSubtitle',
      ],
    );
typedef CheckboxTileWrapperScenario =
    Scenario<CheckboxTileWrapper, CheckboxTileWrapperArgs>;
typedef CheckboxTileWrapperDefaults =
    Defaults<CheckboxTileWrapper, CheckboxTileWrapperArgs>;

class CheckboxTileWrapperStory
    extends Story<CheckboxTileWrapper, CheckboxTileWrapperArgs> {
  CheckboxTileWrapperStory({
    super.name,
    super.setup,
    super.modes,
    CheckboxTileWrapperArgs? args,
    StoryWidgetBuilder<CheckboxTileWrapper, CheckboxTileWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? CheckboxTileWrapperArgs(),
         builder:
             builder ??
             (context, args) => CheckboxTileWrapper(
               key: args.key,
               title: args.title,
               subtitle: args.subtitle,
               initialValue: args.initialValue,
             ),
       );
}

class CheckboxTileWrapperArgs extends StoryArgs<CheckboxTileWrapper> {
  CheckboxTileWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? title,
    Arg<String?>? subtitle,
    Arg<bool>? initialValue,
  }) : this.keyArg = $initArg('key', key, null),
       this.titleArg = $initArg('title', title, StringArg(''))!,
       this.subtitleArg = $initArg(
         'subtitle',
         subtitle,
         NullableStringArg(null),
       )!,
       this.initialValueArg = $initArg(
         'initialValue',
         initialValue,
         BoolArg(false),
       )!;

  CheckboxTileWrapperArgs.fixed({
    Key? key,
    String title = '',
    String? subtitle = null,
    bool initialValue = false,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.titleArg = Arg.fixed(title),
       this.subtitleArg = subtitle == null ? null : Arg.fixed(subtitle),
       this.initialValueArg = Arg.fixed(initialValue);

  final Arg<Key?>? keyArg;

  final Arg<String> titleArg;

  final Arg<String?>? subtitleArg;

  final Arg<bool> initialValueArg;

  Key? get key => keyArg?.value;

  String get title => titleArg.value;

  String? get subtitle => subtitleArg?.value;

  bool get initialValue => initialValueArg.value;

  @override
  List<Arg?> get list => [keyArg, titleArg, subtitleArg, initialValueArg];
}
