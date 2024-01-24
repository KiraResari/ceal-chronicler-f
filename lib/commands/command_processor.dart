import 'package:ceal_chronicler_f/exceptions/command_failed_exception.dart';
import 'package:flutter/material.dart';

import 'command.dart';

class CommandProcessor extends ChangeNotifier {
  final List<Command> _commandHistory = [];
  int _index = 0;

  void process(Command command) {
    try {
      _clearHistoryPastCurrentIndex();
      command.execute();
      _commandHistory.add(command);
      _index++;
      notifyListeners();
    } catch (e) {
      throw CommandFailedException(
        "Processing of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  void undo() {
    try {
      if (_historyIsEmpty) {
        return;
      }
      _index--;
      Command commandToUndo = _commandHistory[_index];
      commandToUndo.undo();
      notifyListeners();
    } catch (e) {
      Command command = _commandHistory[_index - 1];
      throw CommandFailedException(
        "Undo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  bool get _historyIsEmpty => _index == 0;

  void redo() {
    try {
      _performRedo();
    } catch (e) {
      Command command = _commandHistory[_index];
      throw CommandFailedException(
        "Redo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _performRedo() {
    if (_nothingToRedo) {
      return;
    }
    Command commandToRedo = _commandHistory[_index];
    commandToRedo.execute();
    _index++;
    notifyListeners();
  }

  bool get _nothingToRedo => _index == _commandHistory.length;
}
