import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/utils/model/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:get_it/get_it.dart';

import 'commands/command_history.dart';
import 'commands/command_processor.dart';
import 'io/file/file_adapter.dart';
import 'io/chronicle_codec.dart';
import 'io/file/file_processor.dart';
import 'timeline/model/point_in_time_repository.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
  getIt.registerSingleton<IncidentRepository>(IncidentRepository());
  getIt.registerSingleton<CharacterRepository>(CharacterRepository());
  getIt.registerSingleton<ViewRepository>(ViewRepository());
  getIt.registerSingleton<MessageBarState>(MessageBarState());

  getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());

  getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
  getIt.registerSingleton<FileAdapter>(FileAdapter());
  getIt.registerSingleton<CommandHistory>(CommandHistory());

  getIt.registerSingleton<FileProcessor>(FileProcessor());
  getIt.registerSingleton<ViewProcessor>(ViewProcessor());
  getIt.registerSingleton<CommandProcessor>(CommandProcessor());
}
