import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';

class IncidentOverviewController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  IncidentOverviewController() {
    _pointInTimeRepository.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  @override
  void dispose() {
    super.dispose();
    _pointInTimeRepository.removeListener(_notifyListenersCall);
  }

  String get activePointInTimeName =>
      _pointInTimeRepository.activePointInTime.name;
}
