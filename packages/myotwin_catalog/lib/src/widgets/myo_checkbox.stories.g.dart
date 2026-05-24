// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_checkbox.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<CheckboxWrapper, CheckboxWrapperArgs>;
typedef _Scenario = CheckboxWrapperScenario;
typedef _Defaults = CheckboxWrapperDefaults;
typedef _Story = CheckboxWrapperStory;
typedef _Args = CheckboxWrapperArgs;
final CheckboxWrapperComponent =
    Component<CheckboxWrapper, CheckboxWrapperArgs>(
      name: meta.name ?? 'CheckboxWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoCheckbox]
within the Widgetbook.''',
      stories: [
        $Default..$generatedName = 'Default',
        $Checked..$generatedName = 'Checked',
      ],
    );
typedef CheckboxWrapperScenario =
    Scenario<CheckboxWrapper, CheckboxWrapperArgs>;
typedef CheckboxWrapperDefaults =
    Defaults<CheckboxWrapper, CheckboxWrapperArgs>;

class CheckboxWrapperStory extends Story<CheckboxWrapper, CheckboxWrapperArgs> {
  CheckboxWrapperStory({
    super.name,
    super.setup,
    super.modes,
    CheckboxWrapperArgs? args,
    StoryWidgetBuilder<CheckboxWrapper, CheckboxWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? CheckboxWrapperArgs(),
         builder:
             builder ??
             (context, args) => CheckboxWrapper(
               key: args.key,
               initialValue: args.initialValue,
             ),
       );
}

class CheckboxWrapperArgs extends StoryArgs<CheckboxWrapper> {
  CheckboxWrapperArgs({Arg<Key?>? key, Arg<bool>? initialValue})
    : this.keyArg = $initArg('key', key, null),
      this.initialValueArg = $initArg(
        'initialValue',
        initialValue,
        BoolArg(false),
      )!;

  CheckboxWrapperArgs.fixed({Key? key, bool initialValue = false})
    : this.keyArg = key == null ? null : Arg.fixed(key),
      this.initialValueArg = Arg.fixed(initialValue);

  final Arg<Key?>? keyArg;

  final Arg<bool> initialValueArg;

  Key? get key => keyArg?.value;

  bool get initialValue => initialValueArg.value;

  @override
  List<Arg?> get list => [keyArg, initialValueArg];
}
