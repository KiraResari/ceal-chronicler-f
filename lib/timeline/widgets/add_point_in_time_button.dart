import 'package:ceal_chronicler_f/timeline/widgets/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';

class AddPointInTimeButton extends SmallCircularButton {
  final int insertionIndex;

  const AddPointInTimeButton({super.key, required this.insertionIndex})
      : super(tooltip: "Add new point in time", icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    TimeBarController controller = context.read<TimeBarController>();
    controller.addPointInTimeAtIndex(insertionIndex);
  }
}
