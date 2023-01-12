import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

final getIt = GetIt.instance;

void initializeGetItContext() {
  getIt.registerSingleton<EventBus>(EventBus());
}