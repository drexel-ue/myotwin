import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_slider.stories.g.dart';

const meta = Meta<MyoSliderWrapper>(name: 'MyoSlider');

/// A stateful wrapper to allow interactive testing of [MyoSlider]
/// within the Widgetbook.
class MyoSliderWrapper extends StatefulWidget {
  const MyoSliderWrapper({
    super.key,
    this.value = 0.5,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.highlightColor,
    this.trackColor,
    this.thumbColor,
    this.activeColor,
    this.tickColor,
  });

  /// The initial value of the slider.
  final double value;

  /// The minimum value the slider can represent.
  final double min;

  /// The maximum value the slider can represent.
  final double max;

  /// The number of discrete tick marks on the track.
  final int? divisions;

  /// Color for the active portion of the track.
  final Color? highlightColor;

  /// Color for the inactive portion of the track.
  final Color? trackColor;

  /// Color for the slider thumb fill.
  final Color? thumbColor;

  /// Color for the thumb border accent.
  final Color? activeColor;

  /// Color for the division tick marks.
  final Color? tickColor;

  @override
  State<MyoSliderWrapper> createState() => _MyoSliderWrapperState();
}

class _MyoSliderWrapperState extends State<MyoSliderWrapper> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.value.clamp(widget.min, widget.max);
  }

  void _onChanged(double newValue) {
    setState(() {
      _sliderValue = newValue.clamp(widget.min, widget.max);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacing16),
      child: MyoSlider(
        value: _sliderValue,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        onChanged: _onChanged,
        highlightColor: widget.highlightColor,
        trackColor: widget.trackColor,
        thumbColor: widget.thumbColor,
        activeColor: widget.activeColor,
        tickColor: widget.tickColor,
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    value: DoubleArg(0.5),
    min: DoubleArg(0.0),
    max: DoubleArg(1.0),
  ),
);

final $Discrete = _Story(
  name: 'Discrete',
  args: _Args(
    value: DoubleArg(0.5),
    min: DoubleArg(0.0),
    max: DoubleArg(1.0),
    divisions: IntArg(10),
  ),
);

final $Extended = _Story(
  name: 'Extended Range',
  args: _Args(
    value: DoubleArg(50.0),
    min: DoubleArg(0.0),
    max: DoubleArg(100.0),
    divisions: IntArg(10),
  ),
);
