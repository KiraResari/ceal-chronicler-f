import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../time_processor.dart';

class PointInTimeButtonController extends ChangeNotifier {
  final _timeProcessor = getIt.get<TimeProcessor>();
  final PointInTime point;

  PointInTimeButtonController(this.point) {
    _timeProcessor.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  void activatePointInTime() {
    _timeProcessor.activePointInTime = point;
  }

  bool get isEnabled => _timeProcessor.activePointInTime != point;

  @override
  void dispose() {
    super.dispose();
    _timeProcessor.removeListener(_notifyListenersCall);
  }
}
