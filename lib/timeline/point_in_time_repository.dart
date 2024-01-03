import 'package:ceal_chronicler_f/timeline/point_in_time.dart';

class PointInTimeRepository {
  final List<PointInTime> _pointsInTime = [
    PointInTime("Default Point in Time"),
    PointInTime("Test Zeitpunkt 1"),
    PointInTime("Test Zeitpunkt 2"),
    PointInTime("Test Zeitpunkt 3"),
  ];

  get all => _pointsInTime;

  get first => _pointsInTime.first;
}
