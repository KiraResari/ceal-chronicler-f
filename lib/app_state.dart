import 'package:ceal_chronicler_f/characters/character.dart';
import 'package:ceal_chronicler_f/characters/character_repository.dart';
import 'package:ceal_chronicler_f/characters/character_selection_view.dart';
import 'package:ceal_chronicler_f/events/open_character_selection_view_event.dart';
import 'package:ceal_chronicler_f/title_view.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

import 'get_it_context.dart';

class AppState extends ChangeNotifier {
  Widget activeView = const TitleView();

  final _characterSelectionView = const CharacterSelectionView();
  final _characterRepository = CharacterRepository();

  AppState() {
    var eventBus = getIt.get<EventBus>();
    eventBus.on<OpenCharacterSelectionViewEvent>().listen(
      (event) {
        _onOpenCharacterSelectionViewEvent();
      },
    );
  }

  void _onOpenCharacterSelectionViewEvent() {
    activeView = _characterSelectionView;
    notifyListeners();
  }

  List<Character> getCharacters() {
    return _characterRepository.characters;
  }
}
