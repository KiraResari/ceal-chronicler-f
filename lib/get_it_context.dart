import 'package:get_it/get_it.dart';

import 'characters/model/character_repository.dart';
import 'commands/command_history.dart';
import 'commands/command_processor.dart';
import 'incidents/model/incident_repository.dart';
import 'io/chronicle_codec.dart';
import 'io/file/file_adapter.dart';
import 'io/file/file_processor.dart';
import 'key_fields/key_field_resolver.dart';
import 'locations/model/location_connection_repository.dart';
import 'locations/model/location_repository.dart';
import 'message_bar/message_bar_state.dart';
import 'timeline/model/point_in_time_repository.dart';
import 'view/view_processor.dart';
import 'view/view_repository.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
  getIt.registerSingleton<IncidentRepository>(IncidentRepository());
  getIt.registerSingleton<CharacterRepository>(CharacterRepository());
  getIt.registerSingleton<LocationRepository>(LocationRepository());
  getIt.registerSingleton<LocationConnectionRepository>(
      LocationConnectionRepository());
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
