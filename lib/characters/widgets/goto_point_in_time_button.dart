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
  final PointInTimeId pointInTimeId;
  @override
  final String? tooltip;
  final String? disabledReason;

  GotoPointInTimeButton({
    super.key,
    required super.icon,
    required this.pointInTimeId,
    this.tooltip,
    this.disabledReason,
  });

  @override
  void onPressed(BuildContext context) {
    var command = ActivatePointInTimeCommand(pointInTimeId);
    viewProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) =>
      pointInTimeRepository.activePointInTime.id != pointInTimeId;

  @override
  String? getDisabledReason(BuildContext context) => disabledReason;
}
