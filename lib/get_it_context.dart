import 'package:ceal_chronicler_f/characters/character_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

import 'characters/character_model.dart';
import 'characters/character_selection_view_model.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<CharacterRepository>(CharacterRepository());
  getIt.registerSingleton<CharacterModel>(CharacterModel());
  getIt.registerSingleton<CharacterSelectionViewModel>(CharacterSelectionViewModel());
}