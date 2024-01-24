import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time_repository.dart';
import 'package:flutter/material.dart';

class TimeBarController extends ChangeNotifier {
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  late PointInTime _activePointInTime;

  TimeBarController() {
    _activePointInTime = _pointInTimeRepository.first;
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.all;

  get isDeletingAllowed => _pointInTimeRepository.all.length > 1;

  void addPointInTimeAtIndex(int index) {
    _pointInTimeRepository.createNewAtIndex(index);
    notifyListeners();
  }

  void delete(PointInTime point) {
    _pointInTimeRepository.remove(point);
    notifyListeners();
  }

  void rename(PointInTime point, String newName) {
    _pointInTimeRepository.rename(point, newName);
    notifyListeners();
  }
}
