import 'package:flutter/material.dart';

import 'command.dart';

class CommandStack extends ChangeNotifier {
  final List<Command> _commandHistory = [];
  int _index = 0;

  void process(Command command) {
    _clearHistoryPastCurrentIndex();
    command.execute();
    _commandHistory.add(command);
    _index++;
    notifyListeners();
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  void undo() {
    if (_historyIsEmpty) {
      return;
    }
    _index--;
    Command commandToUndo = _commandHistory[_index];
    commandToUndo.undo();
    notifyListeners();
  }

  bool get _historyIsEmpty => _index == 0;

  void redo() {
    if (_nothingToRedo) {
      return;
    }
    _index++;
    Command commandToRedo = _commandHistory[_index];
    commandToRedo.execute();
    notifyListeners();
  }

  bool get _nothingToRedo => _index == _commandHistory.length;
}
