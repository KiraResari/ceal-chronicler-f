import 'package:flutter/material.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';
import 'commands/create_point_in_time_command.dart';
import 'commands/delete_point_in_time_command.dart';
import 'commands/rename_point_in_time_command.dart';
import 'point_in_time.dart';
import 'point_in_time_repository.dart';

class TimeBarController extends ChangeNotifier {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _commandProcessor = getIt.get<CommandProcessor>();

  late PointInTime _activePointInTime;

  TimeBarController() {
    _commandProcessor.addListener(() => notifyListeners());
    _activePointInTime = _pointInTimeRepository.first;
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.pointsInTime;

  get isDeletingAllowed => _pointInTimeRepository.pointsInTime.length > 1;

  void addPointInTimeAtIndex(int index) {
    var command = CreatePointInTimeCommand(index);
    _commandProcessor.process(command);
  }

  void delete(PointInTime point) {
    var command = DeletePointInTimeCommand(point);
    _commandProcessor.process(command);
  }

  void rename(PointInTime point, String newName) {
    var command = RenamePointInTimeCommand(point, newName);
    _commandProcessor.process(command);
  }
}
