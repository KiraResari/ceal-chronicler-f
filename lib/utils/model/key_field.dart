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

  get currentValue {
    T mostRecentValue = _initialValue;
    for (PointInTime pointInTime in pointInTimeRepository.pointsInTime) {
      T? valueAtPointInTime = _keys[pointInTime.id];
      if (valueAtPointInTime != null) {
        mostRecentValue = valueAtPointInTime;
      }
      if (pointInTime == pointInTimeRepository.activePointInTime) {
        break;
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
}
