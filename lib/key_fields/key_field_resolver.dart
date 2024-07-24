import '../../../get_it_context.dart';
import '../../../timeline/model/point_in_time.dart';
import '../../../timeline/model/point_in_time_id.dart';
import '../../../timeline/model/point_in_time_repository.dart';
import 'key_field.dart';

class KeyFieldResolver {
  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  T getCurrentValue<T>(KeyField<T> keyField) {
    T mostRecentValue = keyField.initialValue;
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      T? valueAtPointInTime = keyField.keys[pointInTime.id];
      if (valueAtPointInTime != null) {
        mostRecentValue = valueAtPointInTime;
      }
    }
    return mostRecentValue;
  }

  bool hasNext<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  bool hasPrevious<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  PointInTimeId? getNextPointInTimeId<T>(KeyField<T> keyField) {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return null;
  }

  PointInTimeId getPreviousPointInTimeId<T>(
    KeyField<T> keyField,
    PointInTimeId earliestId,
  ) {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return earliestId;
  }
}
