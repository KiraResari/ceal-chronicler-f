import '../../../get_it_context.dart';
import '../../../timeline/model/point_in_time.dart';
import '../../../timeline/model/point_in_time_id.dart';
import '../../../timeline/model/point_in_time_repository.dart';
import 'key_field.dart';

class KeyFieldController<T>  {

  final KeyField<T> keyField;

  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  KeyFieldController(this.keyField);

  T get currentValue {
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

  bool get hasNext {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  bool get hasPrevious {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return true;
      }
    }
    return false;
  }

  PointInTimeId? get nextPointInTimeId {
    for (PointInTime pointInTime in pointInTimeRepository.futurePointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return null;
  }

  PointInTimeId getPreviousPointInTimeId(PointInTimeId earliestId) {
    for (PointInTime pointInTime
        in pointInTimeRepository.pastAndPresentPointsInTime) {
      if (keyField.keys.containsKey(pointInTime.id)) {
        return pointInTime.id;
      }
    }
    return earliestId;
  }
}
