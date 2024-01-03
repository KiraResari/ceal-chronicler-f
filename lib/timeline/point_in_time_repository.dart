import 'package:ceal_chronicler_f/timeline/point_in_time.dart';

class PointInTimeRepository {
  static const String defaultPointInTimeName = "Point in Time";
  static const int startingRunningNumber = 2;

  final List<PointInTime> _pointsInTime = [
    PointInTime(defaultPointInTimeName),
  ];

  List<PointInTime> get all => _pointsInTime;

  PointInTime get first => _pointsInTime.first;

  void createNewAtIndex(int index) {
    PointInTime newPoint = _createPointWithUniqueName();
    _pointsInTime.insert(index, newPoint);
  }

  PointInTime _createPointWithUniqueName() {
    String uniqueName = _determineUniqueName();
    return PointInTime(uniqueName);
  }

  String _determineUniqueName() {
    List<String> existingNames = _getExistingNames();
    if (!existingNames.contains(defaultPointInTimeName)) {
      return defaultPointInTimeName;
    }
    int runningNumber = startingRunningNumber;
    while (true) {
      String potentialName = "$defaultPointInTimeName$runningNumber";
      if (!existingNames.contains(potentialName)) {
        return potentialName;
      }
      runningNumber++;
    }
  }

  List<String> _getExistingNames() {
    return _pointsInTime.map((point) => point.name).toList();
  }
}
