import 'package:flutter/material.dart';

import '../commands/command_stack.dart';
import '../get_it_context.dart';
import 'commands/create_point_in_time_command.dart';
import 'point_in_time.dart';
import 'point_in_time_repository.dart';

class TimeBarController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _commandStack = getIt.get<CommandStack>();

  late PointInTime _activePointInTime;

  TimeBarController() {
    _activePointInTime = _pointInTimeRepository.first;
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.all;

  get isDeletingAllowed => _pointInTimeRepository.all.length > 1;

  void addPointInTimeAtIndex(int index) {
    var command = CreatePointInTimeCommand(index);
    _commandStack.addAndExecute(command);
    notifyListeners();
  }

  void delete(PointInTime point) {
    _pointInTimeRepository.remove(point);
    notifyListeners();
  }

  void rename(PointInTime point, String newName) {
    _pointInTimeRepository.rename(point, newName);
    notifyListeners();
  }
}
