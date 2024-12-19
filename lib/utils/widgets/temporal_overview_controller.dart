import '../../commands/processor_listener.dart';
import '../../exceptions/point_in_time_not_found_exception.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/repository.dart';
import '../model/temporal_entity.dart';
import '../readable_uuid.dart';

abstract class TemporalOverviewController<T extends TemporalEntity<U>,
    U extends ReadableUuid> extends ProcessorListener {
  final Repository<U, T> repository;
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  TemporalOverviewController(this.repository);

  List<T> get entitiesAtActivePointInTime {
    List<T> allEntities = repository.content;
    List<T> extantEntities = [];
    for (T entity in allEntities) {
      if (_entityExistsAtCurrentPointInTime(entity)) {
        extantEntities.add(entity);
      }
    }
    return extantEntities;
  }

  bool _entityExistsAtCurrentPointInTime(T entity) {
    try {
      var firstAppearanceHasHappened = _pointInTimeRepository
          .activePointInTimeIsNotBefore(entity.firstAppearance);
      var lastAppearanceHasNotHappened = entity.lastAppearance == null
          ? true
          : _pointInTimeRepository
              .activePointInTimeIsNotAfter(entity.lastAppearance!);
      return firstAppearanceHasHappened && lastAppearanceHasNotHappened;
    } on PointInTimeNotFoundException catch (_) {
      return false;
    }
  }
}
