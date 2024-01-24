import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
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

  List<String> get existingNames {
    return _pointsInTime.map((point) => point.name).toList();
  }

  void remove(PointInTime pointToBeRemoved) {
    _assertPointExistsInRepository(pointToBeRemoved);
    if (_pointsInTime.length == 1) {
      throw InvalidOperationException(
          "The final point in time can't be removed");
    }
    _pointsInTime.remove(pointToBeRemoved);
  }

  void _assertPointExistsInRepository(PointInTime point) {
    if (!_pointsInTime.contains(point)) {
      throw InvalidOperationException(
          "PointInTimeRepository does not contain PointInTime with name ${point.name}");
    }
  }

  void rename(PointInTime pointToBeRenamed, String newName) {
    _assertPointExistsInRepository(pointToBeRenamed);
    if(newName != pointToBeRenamed.name) {
      _assertNameIsUnique(newName);
      pointToBeRenamed.name = newName;
    }
  }

  void _assertNameIsUnique(String newName) {
    if (existingNames.contains(newName)) {
      throw InvalidOperationException(
          "Name $newName already exists in PointInTime repository");
    }
  }
}