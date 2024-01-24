import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

import 'command.dart';

class CommandStack extends ChangeNotifier {
  final List<Command> _commandHistory = [];
  final _lock = Lock();
  int _currentIndex = 0;

  Future<void> addAndExecute(Command command) async {
    await _lock.synchronized(() async {
      _clearHistoryPastCurrentIndex();
      await command.execute();
      _commandHistory.add(command);
      _currentIndex++;
      notifyListeners();
    });
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _currentIndex + 1;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  Future<void> undo() async {
    await _lock.synchronized(() async {
      if (_currentIndex == 0) {
        return;
      }
      Command commandToUndo = _commandHistory[_currentIndex];
      await commandToUndo.undo();
      _currentIndex--;
      notifyListeners();
    });
  }

  Future<void> redo() async {
    await _lock.synchronized(() async {
      if (_currentIndexIsAlreadyAtEnd) {
        return;
      }
      _currentIndex++;
      Command commandToRedo = _commandHistory[_currentIndex];
      commandToRedo.execute();
      notifyListeners();
    });
  }

  bool get _currentIndexIsAlreadyAtEnd =>
      (_currentIndex + 1) == _commandHistory.length;
}
