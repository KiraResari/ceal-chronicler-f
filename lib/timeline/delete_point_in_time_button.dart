import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/widgets/small_circular_button.dart';

class DeletePointInTimeButton extends SmallCircularButton {
  final PointInTime point;

  const DeletePointInTimeButton({super.key, required this.point})
      : super(
          tooltip: "Delete",
          disabledTooltip: "The last point in time can't be deleted",
          icon: Icons.delete,
        );

  @override
  void onPressed(BuildContext context) {
    TimeBarController controller = context.read<TimeBarController>();
    controller.delete(point);
  }

  @override
  bool isEnabled(BuildContext context) {
    TimeBarController controller = context.read<TimeBarController>();
    return controller.isDeletingAllowed;
  }
}
