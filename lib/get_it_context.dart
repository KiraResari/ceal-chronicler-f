import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:get_it/get_it.dart';

import 'commands/command_processor.dart';
import 'io/file/file_adapter.dart';
import 'io/repository_service.dart';
import 'io/file/file_service.dart';
import 'timeline/model/point_in_time_repository.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
  getIt.registerSingleton<IncidentRepository>(IncidentRepository());
  getIt.registerSingleton<CharacterRepository>(CharacterRepository());
  getIt.registerSingleton<ViewRepository>(ViewRepository());

  getIt.registerSingleton<RepositoryService>(RepositoryService());
  getIt.registerSingleton<FileAdapter>(FileAdapter());
  getIt.registerSingleton<FileService>(FileService());

  getIt.registerSingleton<ViewProcessor>(ViewProcessor());
  getIt.registerSingleton<CommandProcessor>(CommandProcessor());
}
