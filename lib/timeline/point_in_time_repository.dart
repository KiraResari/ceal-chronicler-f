import 'package:ceal_chronicler_f/timeline/point_in_time.dart';

class PointInTimeRepository {
  final List<PointInTime> _pointsInTime = [
    PointInTime("Default Point in Time"),
    PointInTime("Test Zeitpunkt 1"),
    PointInTime("Test Zeitpunkt 2"),
    PointInTime("Test Zeitpunkt 3"),
    PointInTime("Test Zeitpunkt 4"),
    PointInTime("Test Zeitpunkt 5"),
    PointInTime("Test Zeitpunkt 36"),
    PointInTime("Test Zeitpunkt 37"),
    PointInTime("Test Zeitpunkt 38"),
    PointInTime("Test Zeitpunkt 39"),
  ];

  get all => _pointsInTime;

  get first => _pointsInTime.first;
}
