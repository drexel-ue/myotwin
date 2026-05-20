import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class VoidCallbackArg extends Arg<VoidCallback> {
  VoidCallbackArg(
    super.value, {
    super.name,
  });

  @override
  List<Field<dynamic>> get fields => [];

  @override
  VoidCallback valueFromQueryGroup(QueryGroup? group) => value;

  @override
  QueryGroup valueToQueryGroup(VoidCallback value) => .empty;
}
