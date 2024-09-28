import '../commands/delete_last_appearance_command.dart';
import '../commands/update_first_appearance_command.dart';
import '../../view/commands/activate_point_in_time_command.dart';
import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../commands/update_last_appearance_command.dart';
import '../model/character.dart';

class CharacterViewController extends ProcessorListener {
  final Character character;

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  CharacterViewController(this.character) : super();

  StringKeyField get nameField => character.name;

  String get name {
    return _keyFieldResolver.getCurrentValue(character.name);
  }

  PointInTime? get firstAppearance {
    PointInTime? point = _pointInTimeRepository.get(character.firstAppearance);
    if (point != null) {
      return point;
    }
    return null;
  }

  PointInTime? get lastAppearance {
    PointInTimeId? lastAppearance = character.lastAppearance;
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
        newFirstAppearance.id != character.firstAppearance) {
      var command =
          UpdateFirstAppearanceCommand(character, newFirstAppearance.id);
      commandProcessor.process(command);
      if (_pointInTimeRepository.pointIsInTheFuture(newFirstAppearance)) {
        var viewCommand = ActivatePointInTimeCommand(newFirstAppearance.id);
        viewProcessor.process(viewCommand);
      }
    }
  }

  void updateLastAppearance(PointInTime? newLastAppearance) {
    if (newLastAppearance != null &&
        newLastAppearance.id != character.lastAppearance) {
      var command =
          UpdateLastAppearanceCommand(character, newLastAppearance.id);
      commandProcessor.process(command);
      if (_pointInTimeRepository.pointIsInThePast(newLastAppearance)) {
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
      if (nameField.hasKeyAt(point.id) ||
          point.id == character.lastAppearance) {
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
    PointInTimeId earliestPossibleLastAppearance = character.firstAppearance;
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (nameField.hasKeyAt(point.id)) {
        earliestPossibleLastAppearance = point.id;
      }
    }
    return earliestPossibleLastAppearance;
  }

  void deleteLastAppearance(Character character) {
    var command = DeleteLastAppearanceCommand(character);
    commandProcessor.process(command);
  }
}
