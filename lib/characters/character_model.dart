import 'package:ceal_chronicler_f/events/update_character_view_event.dart';
import 'package:event_bus/event_bus.dart';

import '../events/save_character_event.dart';
import '../get_it_context.dart';
import 'character.dart';
import 'character_repository.dart';

class CharacterModel {
  final _characterRepository = getIt<CharacterRepository>();
  final _eventBus = getIt.get<EventBus>();

  CharacterModel() {
    _eventBus.on<SaveCharacterEvent>().listen(
      (event) {
        addOrUpdate(event.character);
      },
    );
  }

  List<Character> get characters {
    return _characterRepository.characters;
  }

  void addOrUpdate(Character character) {
    _characterRepository.addOrUpdate(character);
    _eventBus.fire(UpdateCharacterViewEvent());
  }
}
