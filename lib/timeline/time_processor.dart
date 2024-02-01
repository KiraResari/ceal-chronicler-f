import 'package:flutter/material.dart';

import '../get_it_context.dart';
import 'model/point_in_time.dart';
import 'model/point_in_time_repository.dart';

class TimeProcessor extends ChangeNotifier{
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  late PointInTime _activePointInTime;

  TimeProcessor(){
    _activePointInTime = _pointInTimeRepository.first;
  }

  PointInTime get activePointInTime => _activePointInTime;

  set activePointInTime(PointInTime value) {
    _activePointInTime = value;
    notifyListeners();
  }
}