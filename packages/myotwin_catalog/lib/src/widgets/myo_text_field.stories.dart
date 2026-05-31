import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_text_field.stories.g.dart';

const meta = Meta<TextFieldWrapper>(name: 'MyoTextField');

/// A stateful wrapper to allow interactive testing of [MyoTextField]
/// within the Widgetbook.
class TextFieldWrapper extends StatefulWidget {
  const TextFieldWrapper({
    super.key,
    required this.label,
    required this.hint,
    required this.enabled,
    required this.obscureText,
  });

  final String label;
  final String hint;
  final bool enabled;
  final bool obscureText;

  @override
  State<TextFieldWrapper> createState() => _TextFieldWrapperState();
}

class _TextFieldWrapperState extends State<TextFieldWrapper> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(16),
        child: MyoTextField(
          controller: _controller,
          label: widget.label,
          hint: widget.hint,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          prefixIcon: const MyoIcon(intent: 'terminal', size: 18),
        ),
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    label: StringArg('TERMINAL_INPUT', name: 'Label'),
    hint: StringArg('ENTER_COMMAND...', name: 'Hint'),
    enabled: BoolArg(true, name: 'Enabled'),
    obscureText: BoolArg(false, name: 'Obscure Text'),
  ),
);

final $Password = _Story(
  name: 'Password',
  args: _Args(
    label: StringArg('ENCRYPTED_ACCESS', name: 'Label'),
    hint: StringArg('ENTER_KEY...', name: 'Hint'),
    enabled: BoolArg(true, name: 'Enabled'),
    obscureText: BoolArg(true, name: 'Obscure Text'),
  ), 
);
