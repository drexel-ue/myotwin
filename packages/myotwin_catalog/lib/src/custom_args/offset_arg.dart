import 'dart:ui';

import 'package:widgetbook/widgetbook.dart';

class OffsetArg extends Arg<Offset> {
  OffsetArg(
    super.value, {
    super.name,
  });

  static const _xOffset = 'x offset';
  static const _yOffset = 'y offset';

  @override
  List<Field<dynamic>> get fields => [
    DoubleInputField(
      name: _xOffset,
      initialValue: value.dx,
    ),
    DoubleInputField(
      name: _yOffset,
      initialValue: value.dy,
    ),
  ];

  @override
  Offset valueFromQueryGroup(QueryGroup? group) {
    if (group == null || group.isNullified) return value;

    return Offset(
      valueOf(_xOffset, group),
      valueOf(_yOffset, group),
    );
  }

  @override
  QueryGroup valueToQueryGroup(Offset value) {
    return QueryGroup({
      _xOffset: paramOf(_xOffset, value.dx),
      _yOffset: paramOf(_yOffset, value.dy),
    });
  }
}
