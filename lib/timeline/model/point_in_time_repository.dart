import '../../exceptions/invalid_operation_exception.dart';
import '../../exceptions/point_in_time_not_found_exception.dart';
import 'point_in_time.dart';
import 'point_in_time_id.dart';

class PointInTimeRepository {
  static const String defaultPointInTimeName = "Point in Time";
  static const int startingRunningNumber = 2;

  PointInTime activePointInTime = PointInTime(defaultPointInTimeName);

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
    pointsInTime.add(activePointInTime);
    _pointsInTimeIdMap[activePointInTime.id] = activePointInTime;
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

  int _getPointIndexById(PointInTimeId id) {
    PointInTime? pointInTime = _pointsInTimeIdMap[id];
    if (pointInTime != null) {
      return getPointIndex(pointInTime);
    }
    throw PointInTimeNotFoundException();
  }

  void activatePointInTime(PointInTimeId id) {
    PointInTime? pointInTime = _pointsInTimeIdMap[id];
    if (pointInTime != null) {
      activePointInTime = pointInTime;
    } else {
      throw PointInTimeNotFoundException();
    }
  }

  bool contains(PointInTimeId id) {
    return _pointsInTimeIdMap.containsKey(id);
  }

  PointInTime? get(PointInTimeId id) => _pointsInTimeIdMap[id];

  List<PointInTime> get futurePointsInTime {
    var activePointInTimeIndex = pointsInTime.indexOf(activePointInTime);
    return pointsInTime.sublist(activePointInTimeIndex + 1);
  }

  List<PointInTime> get pastPointsInTime {
    var activePointInTimeIndex = pointsInTime.indexOf(activePointInTime);
    return pointsInTime.sublist(0, activePointInTimeIndex);
  }

  List<PointInTime> get pastAndPresentPointsInTime {
    var activePointInTimeIndex = pointsInTime.indexOf(activePointInTime);
    return pointsInTime.sublist(0, activePointInTimeIndex + 1);
  }

  List<PointInTime> pointsInTimeBeforeAndIncluding(PointInTime referencePoint) {
    var referencePointIndex = pointsInTime.indexOf(referencePoint);
    return pointsInTime.sublist(0, referencePointIndex + 1);
  }

  List<PointInTime> pointsInTimeIncludingAndAfter(
    PointInTimeId referencePointId,
  ) {
    PointInTime? referencePoint = get(referencePointId);
    if(referencePoint != null) {
      var referencePointIndex = pointsInTime.indexOf(referencePoint);
      return pointsInTime.sublist(referencePointIndex);
    }
    throw PointInTimeNotFoundException();
  }

  bool pointIsInTheFuture(PointInTimeId id) {
    int activePointInTimeIndex = pointsInTime.indexOf(activePointInTime);
    int referencePointIndex = _getPointIndexById(id);
    return referencePointIndex > activePointInTimeIndex;
  }

  bool pointIsInThePast(PointInTimeId id) {
    int activePointInTimeIndex = pointsInTime.indexOf(activePointInTime);
    int referencePointIndex = _getPointIndexById(id);
    return referencePointIndex < activePointInTimeIndex;
  }
}
