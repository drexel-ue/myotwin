import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class NullableAlignmentAddon extends Addon<Alignment?> with SingleFieldOnly {
  NullableAlignmentAddon() : super(name: 'Alignment', initialValue: null);

  static final Map<Alignment?, String> alignments = {
    null: 'None',
    Alignment.topLeft: 'Top Left',
    Alignment.topCenter: 'Top Center',
    Alignment.topRight: 'Top Right',
    Alignment.centerLeft: 'Center Left',
    Alignment.center: 'Center',
    Alignment.centerRight: 'Center Right',
    Alignment.bottomLeft: 'Bottom Left',
    Alignment.bottomCenter: 'Bottom Center',
    Alignment.bottomRight: 'Bottom Right',
  };

  @override
  Field<Alignment?> get field {
    return ObjectDropdownField<Alignment?>(
      name: 'value',
      initialValue: initialValue,
      values: alignments.keys.toList(),
      labelBuilder: (value) => alignments[value]!,
    );
  }

  @override
  Widget apply(BuildContext context, Widget child, Alignment? setting) {
    if (setting == null) {
      return child;
    }
    return Align(
      alignment: setting,
      child: child,
    );
  }
}
