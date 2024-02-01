import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../time_processor.dart';

class PointInTimeButtonController extends ChangeNotifier {
  final _timeProcessor = getIt.get<TimeProcessor>();
  final PointInTime _point;

  PointInTimeButtonController(this._point) {
    _timeProcessor.addListener(() => notifyListeners());
  }

  void activatePointInTime() {
    _timeProcessor.activePointInTime = _point;
  }

  bool get isEnabled => _timeProcessor.activePointInTime != _point;
}
