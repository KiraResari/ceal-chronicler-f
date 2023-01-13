import 'package:ceal_chronicler_f/characters/character_selection_view.dart';
import 'package:ceal_chronicler_f/characters/character_view.dart';
import 'package:ceal_chronicler_f/events/open_character_selection_view_event.dart';
import 'package:ceal_chronicler_f/title_view.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

import 'events/open_character_view_event.dart';
import 'get_it_context.dart';

class AppState extends ChangeNotifier {
  Widget activeView = const TitleView();

  final _characterSelectionView = const CharacterSelectionView();

  AppState() {
    var eventBus = getIt.get<EventBus>();
    eventBus.on<OpenCharacterSelectionViewEvent>().listen(
      (event) {
        _onOpenCharacterSelectionViewEvent();
      },
    );
    eventBus.on<OpenCharacterViewEvent>().listen(
          (event) {
        _onOpenCharacterViewEvent(event);
      },
    );
  }

  void _onOpenCharacterSelectionViewEvent() {
    activeView = _characterSelectionView;
    notifyListeners();
  }

  void _onOpenCharacterViewEvent(OpenCharacterViewEvent event) {
    activeView = CharacterView(character: event.character);
    notifyListeners();
  }
}
