import 'package:flutter/material.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';
import 'commands/create_point_in_time_command.dart';
import 'commands/delete_point_in_time_command.dart';
import 'point_in_time.dart';
import 'point_in_time_repository.dart';

class TimeBarController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _commandStack = getIt.get<CommandProcessor>();

  late PointInTime _activePointInTime;

  TimeBarController() {
    _commandStack.addListener(() => notifyListeners());
    _activePointInTime = _pointInTimeRepository.first;
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.all;

  get isDeletingAllowed => _pointInTimeRepository.all.length > 1;

  void addPointInTimeAtIndex(int index) {
    var command = CreatePointInTimeCommand(index);
    _commandStack.process(command);
  }

  void delete(PointInTime point) {
    var command = DeletePointInTimeCommand(point);
    _commandStack.process(command);
  }

  void rename(PointInTime point, String newName) {
    _pointInTimeRepository.rename(point, newName);
    notifyListeners();
  }
}
