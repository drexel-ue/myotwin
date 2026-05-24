// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_list_tile.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<ListTileWrapper, ListTileWrapperArgs>;
typedef _Scenario = ListTileWrapperScenario;
typedef _Defaults = ListTileWrapperDefaults;
typedef _Story = ListTileWrapperStory;
typedef _Args = ListTileWrapperArgs;
final ListTileWrapperComponent =
    Component<ListTileWrapper, ListTileWrapperArgs>(
      name: meta.name ?? 'ListTileWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoListTile]
within the Widgetbook.''',
      stories: [
        $Default..$generatedName = 'Default',
        $Selected..$generatedName = 'Selected',
      ],
    );
typedef ListTileWrapperScenario =
    Scenario<ListTileWrapper, ListTileWrapperArgs>;
typedef ListTileWrapperDefaults =
    Defaults<ListTileWrapper, ListTileWrapperArgs>;

class ListTileWrapperStory extends Story<ListTileWrapper, ListTileWrapperArgs> {
  ListTileWrapperStory({
    super.name,
    super.setup,
    super.modes,
    ListTileWrapperArgs? args,
    StoryWidgetBuilder<ListTileWrapper, ListTileWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? ListTileWrapperArgs(),
         builder:
             builder ??
             (context, args) => ListTileWrapper(
               key: args.key,
               title: args.title,
               subtitle: args.subtitle,
               isSelected: args.isSelected,
             ),
       );
}

class ListTileWrapperArgs extends StoryArgs<ListTileWrapper> {
  ListTileWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? title,
    Arg<String>? subtitle,
    Arg<bool>? isSelected,
  }) : this.keyArg = $initArg('key', key, null),
       this.titleArg = $initArg('title', title, StringArg(''))!,
       this.subtitleArg = $initArg('subtitle', subtitle, StringArg(''))!,
       this.isSelectedArg = $initArg('isSelected', isSelected, BoolArg(false))!;

  ListTileWrapperArgs.fixed({
    Key? key,
    String title = '',
    String subtitle = '',
    bool isSelected = false,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.titleArg = Arg.fixed(title),
       this.subtitleArg = Arg.fixed(subtitle),
       this.isSelectedArg = Arg.fixed(isSelected);

  final Arg<Key?>? keyArg;

  final Arg<String> titleArg;

  final Arg<String> subtitleArg;

  final Arg<bool> isSelectedArg;

  Key? get key => keyArg?.value;

  String get title => titleArg.value;

  String get subtitle => subtitleArg.value;

  bool get isSelected => isSelectedArg.value;

  @override
  List<Arg?> get list => [keyArg, titleArg, subtitleArg, isSelectedArg];
}
