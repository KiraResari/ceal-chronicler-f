import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/buttons/ceal_text_button.dart';
import '../model/point_in_time.dart';
import 'time_bar_controller.dart';

class PointInTimeButton extends CealTextButton {

  final PointInTime point;

  const PointInTimeButton({super.key, required this.point}) : super(width: 150);

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<TimeBarController>();
    controller.activatePointInTime(point.id);
  }

  @override
  bool isEnabled(BuildContext context) {
    var controller = context.watch<TimeBarController>();
    return controller.isButtonEnabled(point);
  }

  @override
  bool isHighlighted(BuildContext context){
    var controller = context.watch<TimeBarController>();
    return controller.isActive(point);
  }

  @override
  String get text => point.name;

  @override
  String? get tooltip => "Make this the active point in time";

  @override
  String? getDisabledReason(BuildContext context) {
    var controller = context.watch<TimeBarController>();
    return controller.getPointInTimeButtonDisabledReason(point);
  }
}
