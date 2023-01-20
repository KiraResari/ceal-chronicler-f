import 'package:ceal_chronicler_f/events/add_character_event.dart';
import 'package:ceal_chronicler_f/events/export_characters_event.dart';
import 'package:ceal_chronicler_f/events/import_characters_event.dart';
import 'package:ceal_chronicler_f/events/update_character_selection_view_event.dart';
import 'package:event_bus/event_bus.dart';

import '../../get_it_context.dart';
import '../character.dart';
import '../character_repository.dart';

class CharacterSelectionViewModel {
  final _characterRepository = getIt<CharacterRepository>();
  final _eventBus = getIt.get<EventBus>();

  CharacterSelectionViewModel() {
    _eventBus.on<AddCharacterEvent>().listen(
          (event) => addCharacter(),
        );
    _eventBus.on<ImportCharactersEvent>().listen(
          (event) => _importCharacters(),
        );
    _eventBus.on<ExportCharactersEvent>().listen(
          (event) => _exportCharacters(),
        );
  }

  List<Character> get characters => _characterRepository.characters;

  void addCharacter() {
    var character = Character();
    _characterRepository.addOrUpdate(character);
    _updateCharacterSelectionView();
  }

  void _updateCharacterSelectionView() =>
      _eventBus.fire(UpdateCharacterSelectionViewEvent());

  void _importCharacters() {
    var future = _characterRepository.importFromFile();
    future.then((value) => _updateCharacterSelectionView());
  }

  void _exportCharacters() => _characterRepository.exportToFile();
}
