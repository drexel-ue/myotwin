import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetArg extends Arg<Widget> {
  WidgetArg(
    super.value, {
    super.name,
  });

  @override
  List<Field<dynamic>> get fields => [];

  @override
  Widget valueFromQueryGroup(QueryGroup? group) => value;

  @override
  QueryGroup valueToQueryGroup(Widget value) => .empty;
}
