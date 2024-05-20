import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';

class DeletePointInTimeButton extends SmallCircularButton {
  final PointInTime point;

  const DeletePointInTimeButton({super.key, required this.point})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<TimeBarController>();
    controller.delete(point);
  }

  @override
  bool isEnabled(BuildContext context) =>
      context.watch<TimeBarController>().canPointBeDeleted(point);

  @override
  String? getDisabledReason(BuildContext context) => context
      .watch<TimeBarController>()
      .getPointDeleteButtonDisabledReason(point);

  @override
  String? get tooltip => "Delete point in time";
}
