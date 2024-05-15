import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:flutter/material.dart';

class ViewProcessor extends ChangeNotifier {
  late final List<ViewCommand> _commandHistory = [];
  int _index = 0;

  void process(ViewCommand command) {
    if (command.isExecutePossible) {
      _clearHistoryPastCurrentIndex();
      command.execute();
      _commandHistory.add(command);
      _index++;
      notifyListeners();
    }
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  bool get isNavigatingBackPossible {
    if (_index == 0) {
      return false;
    }
    for (int i = 0; i < _index; i++) {
      if (_commandHistory[i].isUndoPossible) {
        return true;
      }
    }
    return false;
  }

  void navigateBack() {
    int? targetIndex = _previousValidIndex;
    if(targetIndex != null){
      _commandHistory[targetIndex].undo();
      _index = targetIndex;
    }
  }

  int? get _previousValidIndex {
    for (int i = _index - 1; i >= 0; i--) {
      if (_commandHistory[i].isUndoPossible) {
        return i;
      }
    }
    return null;
  }

  bool get isNavigatingForwardPossible {
    if (_index >= _commandHistory.length) {
      return false;
    }
    for (int i = _index; i < _commandHistory.length; i++) {
      if (_commandHistory[i].isExecutePossible) {
        return true;
      }
    }
    return false;
  }

  void navigateForward() {
    int? targetIndex = _nextTargetIndex;
    if(targetIndex != null){
      _commandHistory[targetIndex].execute();
      _index = targetIndex;
    }
  }

  int? get _nextTargetIndex {
    for (int i = _index; i < _commandHistory.length; i++) {
      if (_commandHistory[i].isExecutePossible) {
        return i;
      }
    }
    return null;
  }

  void reset() {
    _commandHistory.clear();
    _index = 0;
  }
}
