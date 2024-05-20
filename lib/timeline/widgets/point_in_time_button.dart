import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../utils/widgets/buttons/ceal_text_button.dart';
import '../../view/commands/activate_point_in_time_command.dart';
import '../../view/view_processor.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class PointInTimeButton extends CealTextButton {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _viewProcessor = getIt.get<ViewProcessor>();

  final PointInTime point;

  PointInTimeButton({super.key, required this.point}) : super(width: 150);

  @override
  void onPressed(BuildContext context) {
    var command = ActivatePointInTimeCommand(point.id);
    _viewProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) =>
      _pointInTimeRepository.activePointInTime != point;

  @override
  String get text => point.name;

  @override
  String? get tooltip => "Make this the active point in time";

  @override
  String? getDisabledReason(BuildContext context) =>
      "This is already the active point in time";
}
