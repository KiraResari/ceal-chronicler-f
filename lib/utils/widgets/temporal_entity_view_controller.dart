import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../../view/commands/activate_point_in_time_command.dart';
import '../commands/delete_last_appearance_command.dart';
import '../commands/update_first_appearance_command.dart';
import '../commands/update_last_appearance_command.dart';
import '../model/temporal_entity.dart';

abstract class TemporalEntityViewController<T extends TemporalEntity>
    extends ProcessorListener {
  final T entity;

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final keyFieldResolver = getIt.get<KeyFieldResolver>();

  TemporalEntityViewController(this.entity) : super();

  StringKeyField get nameField => entity.name;

  String get name {
    return keyFieldResolver.getCurrentValue(entity.name) ?? "";
  }

  PointInTime? get firstAppearance {
    PointInTime? point = _pointInTimeRepository.get(entity.firstAppearance);
    if (point != null) {
      return point;
    }
    return null;
  }

  PointInTime? get lastAppearance {
    PointInTimeId? lastAppearance = entity.lastAppearance;
    if (lastAppearance != null) {
      PointInTime? point = _pointInTimeRepository.get(lastAppearance);
      if (point != null) {
        return point;
      }
    }
    return null;
  }

  void updateFirstAppearance(PointInTime? newFirstAppearance) {
    if (newFirstAppearance != null &&
        newFirstAppearance.id != entity.firstAppearance) {
      var command = UpdateFirstAppearanceCommand(entity, newFirstAppearance.id);
      commandProcessor.process(command);
      if (_pointInTimeRepository.pointIsInTheFuture(newFirstAppearance.id)) {
        var viewCommand = ActivatePointInTimeCommand(newFirstAppearance.id);
        viewProcessor.process(viewCommand);
      }
    }
  }

  void updateLastAppearance(PointInTime? newLastAppearance) {
    if (newLastAppearance != null &&
        newLastAppearance.id != entity.lastAppearance) {
      var command = UpdateLastAppearanceCommand(entity, newLastAppearance.id);
      commandProcessor.process(command);
      if (_pointInTimeRepository.pointIsInThePast(newLastAppearance.id)) {
        var viewCommand = ActivatePointInTimeCommand(newLastAppearance.id);
        viewProcessor.process(viewCommand);
      }
    }
  }

  List<PointInTime> get validFirstAppearances {
    return _pointInTimeRepository
        .pointsInTimeBeforeAndIncluding(_latestPossibleFirstAppearance);
  }

  PointInTime get _latestPossibleFirstAppearance {
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (nameField.hasKeyAt(point.id) || point.id == entity.lastAppearance) {
        return point;
      }
    }
    return _pointInTimeRepository.last;
  }

  List<PointInTime> get validLastAppearances {
    return _pointInTimeRepository
        .pointsInTimeIncludingAndAfter(_earliestPossibleLastAppearance);
  }

  PointInTimeId get _earliestPossibleLastAppearance {
    PointInTimeId earliestPossibleLastAppearance = entity.firstAppearance;
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (nameField.hasKeyAt(point.id)) {
        earliestPossibleLastAppearance = point.id;
      }
    }
    return earliestPossibleLastAppearance;
  }

  void deleteLastAppearance() {
    var command = DeleteLastAppearanceCommand(entity);
    commandProcessor.process(command);
  }
}
