import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter/material.dart';

import '../../exceptions/point_in_time_not_found_exception.dart';

class PointInTimeRepository extends ChangeNotifier {
  static const String defaultPointInTimeName = "Point in Time";
  static const int startingRunningNumber = 2;

  PointInTime _activePointInTime = PointInTime(defaultPointInTimeName);

  List<PointInTime> _pointsInTime = [];
  final Map<PointInTimeId, PointInTime> _pointsInTimeIdMap = {};

  List<PointInTime> get pointsInTime => _pointsInTime;

  set pointsInTime(List<PointInTime> points) {
    _pointsInTime = points;
    _pointsInTimeIdMap.clear();
    for (PointInTime point in points) {
      _pointsInTimeIdMap[point.id] = point;
    }
  }

  PointInTimeRepository() {
    pointsInTime.add(_activePointInTime);
    _pointsInTimeIdMap[_activePointInTime.id] = _activePointInTime;
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
    addAtIndex(index, newPoint);
    return newPoint;
  }

  void addAtIndex(int index, PointInTime newPoint) {
    pointsInTime.insert(index, newPoint);
    _pointsInTimeIdMap[newPoint.id] = newPoint;
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
    _handleRemovalOfActivePointInTime(pointToBeRemoved);
    pointsInTime.remove(pointToBeRemoved);
    _pointsInTimeIdMap.remove(pointToBeRemoved.id);
  }

  void _handleRemovalOfActivePointInTime(PointInTime pointToBeRemoved) {
    if (pointToBeRemoved == activePointInTime) {
      activePointInTime = _determineNewActivePoint(pointToBeRemoved);
    }
  }

  PointInTime _determineNewActivePoint(PointInTime pointToBeRemoved) {
    int pointIndex = getPointIndex(pointToBeRemoved);
    if (pointToBeRemoved == last) {
      return pointsInTime[pointIndex - 1];
    }
    return pointsInTime[pointIndex + 1];
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

  bool activePointInTimeIsNotBefore(PointInTimeId id) {
    int activePointIndex = getPointIndex(activePointInTime);
    int comparisonPointIndex = _getPointIndexById(id);
    return activePointIndex >= comparisonPointIndex;
  }

  int _getPointIndexById(PointInTimeId id) {
    PointInTime? pointInTime = _pointsInTimeIdMap[id];
    if (pointInTime != null) {
      return getPointIndex(pointInTime);
    }
    throw PointInTimeNotFoundException();
  }
}
