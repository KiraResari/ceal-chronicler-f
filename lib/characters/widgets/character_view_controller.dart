import 'package:ceal_chronicler_f/characters/commands/update_first_appearance_command.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';

import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_repository.dart';
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

  List<PointInTime> get validFirstAppearances {
    return _pointInTimeRepository
        .pointsInTimeBeforeAndIncluding(latestPossibleFirstAppearance);
  }

  PointInTime get latestPossibleFirstAppearance {
    for (PointInTime point in _pointInTimeRepository.pointsInTime) {
      if (nameField.hasKeyAt(point.id)) {
        return point;
      }
    }
    return _pointInTimeRepository.last;
  }
}
