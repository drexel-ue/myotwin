import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

class InteractiveGridHostAddon extends Addon<void> {
  InteractiveGridHostAddon() : super(name: '', initialValue: null);

  @override
  Widget apply(BuildContext context, Widget child, void setting) {
    return InteractiveGridHost(child: child);
  }

  @override
  List<Field<dynamic>> get fields => [];

  @override
  void valueFromQueryGroup(QueryGroup? group) {}

  @override
  QueryGroup valueToQueryGroup(void value) => .empty;
}
