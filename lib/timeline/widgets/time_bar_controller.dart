import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../commands/create_point_in_time_command.dart';
import '../commands/delete_point_in_time_command.dart';
import '../commands/rename_point_in_time_command.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class TimeBarController extends ChangeNotifier {
  static const String lastPointDeletionForbiddenReason =
      "The last point in time can't be deleted";
  static const String incidentsPresentDeletionForbiddenReason =
      "A point in time with incidents can't be deleted";
  static const String unknownDeletionForbiddenReason =
      "The reason why this point in time can't be deleted is unknown\n"
      "This might indicate a bug";

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _commandProcessor = getIt.get<CommandProcessor>();

  TimeBarController() {
    _commandProcessor.addListener(() => notifyListeners());
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.pointsInTime;

  bool canPointBeDeleted(PointInTime point) =>
      _pointInTimeRepository.pointsInTime.length > 1 &&
      point.incidentReferences.isEmpty;

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

  String getPointDeleteButtonDisabledReason(PointInTime point) {
    if (_pointInTimeRepository.pointsInTime.length < 2) {
      return lastPointDeletionForbiddenReason;
    }
    if (point.incidentReferences.isNotEmpty){
      return incidentsPresentDeletionForbiddenReason;
    }
    return unknownDeletionForbiddenReason;
  }
}
