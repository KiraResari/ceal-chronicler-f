import 'package:get_it/get_it.dart';

import 'commands/command_processor.dart';
import 'io/file/file_service.dart';
import 'timeline/point_in_time_repository.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
  getIt.registerSingleton<FileService>(FileService());
  getIt.registerSingleton<CommandProcessor>(CommandProcessor());
}
