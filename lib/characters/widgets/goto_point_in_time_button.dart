import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../../view/view_processor.dart';

class GotoPointInTimeButton extends SmallCircularButton {
  final viewProcessor = getIt.get<ViewProcessor>();
  final pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final PointInTimeId? pointInTimeId;
  final String referenceName;

  GotoPointInTimeButton({
    super.key,
    required super.icon,
    required this.pointInTimeId,
    required this.referenceName,
  });

  @override
  void onPressed(BuildContext context) {
    if (pointInTimeId != null) {
      var command = ActivatePointInTimeCommand(pointInTimeId!);
      viewProcessor.process(command);
    }
  }

  @override
  bool isEnabled(BuildContext context) =>
      pointInTimeId != null &&
      pointInTimeRepository.activePointInTime.id != pointInTimeId;

  @override
  String? getDisabledReason(BuildContext context) {
    if (pointInTimeId == null) {
      return "No $referenceName to go to";
    }
    if (pointInTimeRepository.activePointInTime.id == pointInTimeId){
      return "This is already the $referenceName";
    }
    return "Button should be active; this might be a bug";
  }

  @override
  String? get tooltip => "Go to $referenceName";
}
