import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/character.dart';
import '../model/character_id.dart';
import '../model/character_repository.dart';

class CharacterViewController extends ProcessorListener {
  final Character? character;

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  CharacterViewController(CharacterId id)
      : character = getIt<CharacterRepository>().getContentElementById(id),
        super();

  bool get characterFound => character != null;

  StringKeyField get nameField => character != null
      ? character!.name
      : StringKeyField("Character not found");

  String get name {
    if (!characterFound) {
      return "Character not found";
    }
    return _keyFieldResolver.getCurrentValue(character!.name);
  }

  String get firstApperance {
    if (character != null) {
      PointInTime? point =
          _pointInTimeRepository.get(character!.firstAppearance);
      if (point != null) {
        return point.name;
      }
    }
    return "Unknown";
  }
}
