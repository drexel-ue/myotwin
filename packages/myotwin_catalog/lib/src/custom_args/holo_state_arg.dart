import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

class HoloStateArg extends SingleArg<HoloState> {
  HoloStateArg()
    : super(
        .idle,
        values: HoloState.values,
        style: const SegmentedSingleArgStyle(),
        labelBuilder: (state) => state.name,
      );
}
