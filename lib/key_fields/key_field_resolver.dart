import '../../../get_it_context.dart';
import '../../../timeline/model/point_in_time.dart';
import '../../../timeline/model/point_in_time_id.dart';
import '../../../timeline/model/point_in_time_repository.dart';
import 'key_field.dart';

class KeyFieldResolver {
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  T? getCurrentValue<T>(KeyField<T> keyField) {
    T? mostRecentValue = keyField.initialValue;
    for (PointInTime pointInTime
        in _pointInTimeRepository.pastAndPresentPointsInTime) {
      keyField.keys.containsKey(pointInTime.id);
      if (keyField.keys.containsKey(pointInTime.id)) {
        mostRecentValue = keyField.keys[pointInTime.id];
      }
    }
    return mostRecentValue;
  }

  bool hasNext<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime in _pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  bool hasPrevious<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime
        in _pointInTimeRepository.pastPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  bool keyExistsAtCurrentPointInTime(KeyField keyField) {
    var activePointInTimeId = _pointInTimeRepository.activePointInTime.id;
    return keyField.keys.containsKey(activePointInTimeId);
  }

  PointInTimeId? getNextPointInTimeId<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime in _pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return null;
  }

  PointInTimeId? getPreviousPointInTimeId<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime
        in _pointInTimeRepository.pastAndPresentPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return null;
  }
}
