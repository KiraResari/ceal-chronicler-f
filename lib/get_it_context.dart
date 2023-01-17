import 'package:ceal_chronicler_f/characters/character_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

import 'characters/character_selection_view/character_selection_view_model.dart';
import 'characters/character_view/character_view_model.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<CharacterRepository>(CharacterRepository());
  getIt.registerSingleton<CharacterViewModel>(CharacterViewModel());
  getIt.registerSingleton<CharacterSelectionViewModel>(CharacterSelectionViewModel());
}