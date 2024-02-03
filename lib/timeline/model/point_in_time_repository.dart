import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:flutter/material.dart';

class PointInTimeRepository extends ChangeNotifier {
  static const String defaultPointInTimeName = "Point in Time";
  static const int startingRunningNumber = 2;

  PointInTime _activePointInTime = PointInTime(defaultPointInTimeName);

  List<PointInTime> pointsInTime = [];

  PointInTimeRepository() {
    pointsInTime.add(_activePointInTime);
  }

  PointInTime get activePointInTime => _activePointInTime;

  set activePointInTime(PointInTime value) {
    _activePointInTime = value;
    notifyListeners();
  }

  PointInTime get first => pointsInTime.first;

  PointInTime get last => pointsInTime.last;

  PointInTime createNewAtIndex(int index) {
    PointInTime newPoint = _createPointWithUniqueName();
    return createAtIndex(index, newPoint);
  }

  PointInTime createAtIndex(int index, PointInTime newPoint) {
    pointsInTime.insert(index, newPoint);
    return newPoint;
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
    return pointsInTime.map((point) => point.name).toList();
  }

  void remove(PointInTime pointToBeRemoved) {
    _assertPointExistsInRepository(pointToBeRemoved);
    if (pointsInTime.length == 1) {
      throw InvalidOperationException(
          "The final point in time can't be removed");
    }
    pointsInTime.remove(pointToBeRemoved);
  }

  void _assertPointExistsInRepository(PointInTime point) {
    if (!pointsInTime.contains(point)) {
      throw InvalidOperationException(
          "PointInTimeRepository does not contain PointInTime with name ${point.name}");
    }
  }

  void rename(PointInTime pointToBeRenamed, String newName) {
    _assertPointExistsInRepository(pointToBeRenamed);
    if (newName != pointToBeRenamed.name) {
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

  int getPointIndex(PointInTime point) => pointsInTime.indexOf(point);
}
