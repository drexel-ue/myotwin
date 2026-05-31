// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering, unused_element, strict_raw_type

part of 'myo_text_field.stories.dart';

// **************************************************************************
// StoryGenerator
// **************************************************************************

typedef _Component = Component<TextFieldWrapper, TextFieldWrapperArgs>;
typedef _Scenario = TextFieldWrapperScenario;
typedef _Defaults = TextFieldWrapperDefaults;
typedef _Story = TextFieldWrapperStory;
typedef _Args = TextFieldWrapperArgs;
final TextFieldWrapperComponent =
    Component<TextFieldWrapper, TextFieldWrapperArgs>(
      name: meta.name ?? 'TextFieldWrapper',
      path: meta.path ?? 'widgets',
      docsBuilder: meta.docsBuilder,
      docComment:
          r'''A stateful wrapper to allow interactive testing of [MyoTextField]
within the Widgetbook.''',
      stories: [
        $Default..$generatedName = 'Default',
        $Password..$generatedName = 'Password',
      ],
    );
typedef TextFieldWrapperScenario =
    Scenario<TextFieldWrapper, TextFieldWrapperArgs>;
typedef TextFieldWrapperDefaults =
    Defaults<TextFieldWrapper, TextFieldWrapperArgs>;

class TextFieldWrapperStory
    extends Story<TextFieldWrapper, TextFieldWrapperArgs> {
  TextFieldWrapperStory({
    super.name,
    super.setup,
    super.modes,
    TextFieldWrapperArgs? args,
    StoryWidgetBuilder<TextFieldWrapper, TextFieldWrapperArgs>? builder,
    super.scenarios,
  }) : super(
         args: args ?? TextFieldWrapperArgs(),
         builder:
             builder ??
             (context, args) => TextFieldWrapper(
               key: args.key,
               label: args.label,
               hint: args.hint,
               enabled: args.enabled,
               obscureText: args.obscureText,
             ),
       );
}

class TextFieldWrapperArgs extends StoryArgs<TextFieldWrapper> {
  TextFieldWrapperArgs({
    Arg<Key?>? key,
    Arg<String>? label,
    Arg<String>? hint,
    Arg<bool>? enabled,
    Arg<bool>? obscureText,
  }) : this.keyArg = $initArg('key', key, null),
       this.labelArg = $initArg('label', label, StringArg(''))!,
       this.hintArg = $initArg('hint', hint, StringArg(''))!,
       this.enabledArg = $initArg('enabled', enabled, BoolArg(false))!,
       this.obscureTextArg = $initArg(
         'obscureText',
         obscureText,
         BoolArg(false),
       )!;

  TextFieldWrapperArgs.fixed({
    Key? key,
    String label = '',
    String hint = '',
    bool enabled = false,
    bool obscureText = false,
  }) : this.keyArg = key == null ? null : Arg.fixed(key),
       this.labelArg = Arg.fixed(label),
       this.hintArg = Arg.fixed(hint),
       this.enabledArg = Arg.fixed(enabled),
       this.obscureTextArg = Arg.fixed(obscureText);

  final Arg<Key?>? keyArg;

  final Arg<String> labelArg;

  final Arg<String> hintArg;

  final Arg<bool> enabledArg;

  final Arg<bool> obscureTextArg;

  Key? get key => keyArg?.value;

  String get label => labelArg.value;

  String get hint => hintArg.value;

  bool get enabled => enabledArg.value;

  bool get obscureText => obscureTextArg.value;

  @override
  List<Arg?> get list => [
    keyArg,
    labelArg,
    hintArg,
    enabledArg,
    obscureTextArg,
  ];
}
