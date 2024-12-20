import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/model/temporal_entity.dart';

import '../../exceptions/point_in_time_not_found_exception.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_repository.dart';

abstract class TemporallyLimitedTemplate<T extends TemporalEntity> {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  final T entity;

  TemporallyLimitedTemplate(this.entity);

  PointInTimeId? get firstAppearance => entity.firstAppearance;

  PointInTimeId? get lastAppearance => entity.lastAppearance;

  String get currentName => _keyFieldResolver.getCurrentValue(entity.name);

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
    final pointsInTime = _pointInTimeRepository.pointsInTime;

    final leftIndex = pointsInTime.indexWhere((point) => point.id == left);
    final rightIndex = pointsInTime.indexWhere((point) => point.id == right);

    if (leftIndex == -1 || rightIndex == -1) {
      throw PointInTimeNotFoundException();
    }

    return leftIndex < rightIndex;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TemporallyLimitedTemplate &&
              runtimeType == other.runtimeType &&
              entity == other.entity;

  @override
  int get hashCode => entity.hashCode;
}
