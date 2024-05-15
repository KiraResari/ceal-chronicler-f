import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class PointInTimeButtonController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _viewProcessor = getIt.get<ViewProcessor>();
  final PointInTime point;

  PointInTimeButtonController(this.point) {
    _viewProcessor.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  void activatePointInTime() {
    var command = ActivatePointInTimeCommand(point.id);
    _viewProcessor.process(command);
  }

  bool get isEnabled => _pointInTimeRepository.activePointInTime != point;

  @override
  void dispose() {
    super.dispose();
    _viewProcessor.removeListener(_notifyListenersCall);
  }
}
