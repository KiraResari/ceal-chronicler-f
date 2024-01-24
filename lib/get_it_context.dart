import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<CommandProcessor>(CommandProcessor());
  getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
}