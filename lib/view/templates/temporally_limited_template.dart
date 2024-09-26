import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';

import '../../exceptions/point_in_time_not_found_exception.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_repository.dart';

abstract class TemporallyLimitedTemplate {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  PointInTimeId? get firstAppearance;

  PointInTimeId? get lastAppearance;

  bool existsAt(PointInTimeId referencePointId) {
    return !(_isBeforeFirstAppearance(referencePointId) ||
        _isAfterLastAppearance(referencePointId));
  }

  bool _isBeforeFirstAppearance(PointInTimeId referencePointId) {
    PointInTimeId? localFirstAppearance = firstAppearance;
    if (localFirstAppearance != null) {
      return _leftIsBeforeRight(referencePointId, localFirstAppearance);
    }
    return false;
  }

  bool _isAfterLastAppearance(PointInTimeId referencePointId) {
    PointInTimeId? localLastAppearance = lastAppearance;
    if (localLastAppearance != null) {
      return _leftIsBeforeRight(localLastAppearance, referencePointId);
    }
    return false;
  }

  bool _leftIsBeforeRight(PointInTimeId left, PointInTimeId right) {
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (point.id == left) {
        return true;
      }
      if (point.id == right) {
        return false;
      }
    }
    throw PointInTimeNotFoundException();
  }

  String getTemporalInvalidityReason(PointInTimeId referencePointId) {
    if (_isBeforeFirstAppearance(referencePointId)) {
      return "$identifier does not exist yet at this point in time";
    }
    if (_isAfterLastAppearance(referencePointId)) {
      return "$identifier does not exist anymore at this point in time";
    }
    return "$identifier exists at this point in time, so this should be selectable. If you see this, then this might be a bug.";
  }

  String get identifier;
}
