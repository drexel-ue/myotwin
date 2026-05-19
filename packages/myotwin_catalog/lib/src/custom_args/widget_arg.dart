import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetArg extends Arg<Widget> {
  WidgetArg(
    super.value, {
    super.name,
  });

  static const _widget = 'widget';

  @override
  List<Field<dynamic>> get fields => [];

  @override
  Widget valueFromQueryGroup(QueryGroup? group) {
    return value;
  }

  @override
  QueryGroup valueToQueryGroup(Widget value) {
    return QueryGroup({
      _widget: paramOf(_widget, value),
    });
  }
}
