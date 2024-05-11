import 'package:ceal_chronicler_f/view/commands/activate_initial_view_command.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../timeline/model/point_in_time_repository.dart';

class ViewProcessor extends ChangeNotifier {
  late final List<ViewCommand> _commandHistory;
  int _index = 0;

  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  ViewProcessor() {
    var originalPointInTime = pointInTimeRepository.first;
    ActivateInitialViewCommand command =
        ActivateInitialViewCommand(originalPointInTime.id);
    _commandHistory = [command];
  }

  void process(ViewCommand command) {
    _clearHistoryPastCurrentIndex();
    command.execute();
    _commandHistory.add(command);
    _index++;
    notifyListeners();
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index + 1;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  bool get isNavigatingBackPossible {
    if (_index == 0) {
      return false;
    }
    for (int i = 0; i < _index; i++) {
      if (_commandHistory[i].isValid()) {
        return true;
      }
    }
    return false;
  }

  bool get isNavigatingForwardPossible {
    if (_index + 1 >= _commandHistory.length) {
      return false;
    }
    for (int i = _index + 1; i < _commandHistory.length; i++) {
      if (_commandHistory[i].isValid()) {
        return true;
      }
    }
    return false;
  }

  void navigateBack() {
    int? targetIndex = _previousValidIndex;
    _navigteToTargetIndex(targetIndex);
  }

  int? get _previousValidIndex {
    for (int i = _index - 1; i >= 0; i--) {
      if (_commandHistory[i].isValid()) {
        return i;
      }
    }
    return null;
  }

  void _navigteToTargetIndex(int? targetIndex) {
    if (targetIndex != null) {
      _index = targetIndex;
      _commandHistory[targetIndex].execute();
      notifyListeners();
    }
  }

  void navigateForward() {
    int? targetIndex = _nextTargetIndex;
    _navigteToTargetIndex(targetIndex);
  }

  int? get _nextTargetIndex {
    for (int i = _index + 1; i < _commandHistory.length; i++) {
      if (_commandHistory[i].isValid()) {
        return i;
      }
    }
    return null;
  }
}
