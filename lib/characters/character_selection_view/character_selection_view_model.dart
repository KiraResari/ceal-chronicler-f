import 'package:ceal_chronicler_f/events/add_character_event.dart';
import 'package:ceal_chronicler_f/events/update_character_selection_view_event.dart';
import 'package:event_bus/event_bus.dart';

import '../../get_it_context.dart';
import '../character.dart';
import '../character_view/character_view_model.dart';
import '../character_repository.dart';

class CharacterSelectionViewModel {
  final _characterRepository = getIt<CharacterRepository>();
  final _eventBus = getIt.get<EventBus>();
  final _characterModel = getIt.get<CharacterViewModel>();

  CharacterSelectionViewModel() {
    _eventBus.on<AddCharacterEvent>().listen(
      (event) {
        addCharacter();
      },
    );
  }

  List<Character> get characters {
    return _characterRepository.characters;
  }

  void addCharacter() {
    var character = Character();
    _characterModel.addOrUpdate(character);
    _eventBus.fire(UpdateCharacterSelectionViewEvent());
  }
}
