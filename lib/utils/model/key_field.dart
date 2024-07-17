import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';

class KeyField<T> {
  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  final T _initialValue;
  final Map<PointInTimeId, T> _keys = {};

  KeyField(this._initialValue);

  T get currentValue {
    T mostRecentValue = _initialValue;
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      T? valueAtPointInTime = _keys[pointInTime.id];
      if (valueAtPointInTime != null) {
        mostRecentValue = valueAtPointInTime;
      }
    }
    return mostRecentValue;
  }

  void addOrUpdateKeyAtTime(T newValue, PointInTimeId pointInTimeId) {
    _keys[pointInTimeId] = newValue;
  }

  void deleteKeyAtTime(PointInTimeId pointInTimeId) {
    _keys.remove(pointInTimeId);
  }

  bool get hasNext {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (_keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  bool get hasPrevious {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (_keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  PointInTimeId? get nextPointInTimeId {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (_keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return null;
  }

  PointInTimeId getPreviousPointInTimeId(PointInTimeId earliestId) {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (_keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return earliestId;
  }
}
