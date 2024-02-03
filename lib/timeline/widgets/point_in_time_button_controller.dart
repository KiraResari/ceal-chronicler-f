import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class PointInTimeButtonController extends ChangeNotifier {
  final _pointInTimeController = getIt.get<PointInTimeRepository>();
  final PointInTime point;

  PointInTimeButtonController(this.point) {
    _pointInTimeController.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  void activatePointInTime() {
    _pointInTimeController.activePointInTime = point;
  }

  bool get isEnabled => _pointInTimeController.activePointInTime != point;

  @override
  void dispose() {
    super.dispose();
    _pointInTimeController.removeListener(_notifyListenersCall);
  }
}
