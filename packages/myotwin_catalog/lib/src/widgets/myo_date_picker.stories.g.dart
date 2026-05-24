// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_date_picker.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<DatePickerWrapper, DatePickerWrapperArgs>;
typedef _Scenario = DatePickerWrapperScenario;
typedef _Defaults = DatePickerWrapperDefaults;
typedef _Story = DatePickerWrapperStory;
typedef _Args = DatePickerWrapperArgs;
final DatePickerWrapperComponent =
    Component<DatePickerWrapper, DatePickerWrapperArgs>(
      name: meta.name ?? 'DatePickerWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoDatePicker]
within the Widgetbook.''',
      stories: [$Default..$generatedName = 'Default'],
    );
typedef DatePickerWrapperScenario =
    Scenario<DatePickerWrapper, DatePickerWrapperArgs>;
typedef DatePickerWrapperDefaults =
    Defaults<DatePickerWrapper, DatePickerWrapperArgs>;

class DatePickerWrapperStory
    extends Story<DatePickerWrapper, DatePickerWrapperArgs> {
  DatePickerWrapperStory({
    super.name,
    super.setup,
    super.modes,
    DatePickerWrapperArgs? args,
    StoryWidgetBuilder<DatePickerWrapper, DatePickerWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? DatePickerWrapperArgs(),
         builder:
             builder ??
             (context, args) => DatePickerWrapper(
               key: args.key,
               label: args.label,
               initialValue: args.initialValue,
             ),
       );
}

class DatePickerWrapperArgs extends StoryArgs<DatePickerWrapper> {
  DatePickerWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? label,
    Arg<DateTime>? initialValue,
  }) : this.keyArg = $initArg('key', key, null),
       this.labelArg = $initArg('label', label, StringArg(''))!,
       this.initialValueArg = $initArg(
         'initialValue',
         initialValue,
         DateTimeArg(DateTime.now()),
       )!;

  DatePickerWrapperArgs.fixed({
    Key? key,
    String label = '',
    DateTime? initialValue,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.labelArg = Arg.fixed(label),
       this.initialValueArg = Arg.fixed(initialValue ?? DateTime.now());

  final Arg<Key?>? keyArg;

  final Arg<String> labelArg;

  final Arg<DateTime> initialValueArg;

  Key? get key => keyArg?.value;

  String get label => labelArg.value;

  DateTime get initialValue => initialValueArg.value;

  @override
  List<Arg?> get list => [keyArg, labelArg, initialValueArg];
}
