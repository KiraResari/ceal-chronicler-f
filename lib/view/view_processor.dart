import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../message_bar/message_bar_state.dart';

class ViewProcessor extends ChangeNotifier {
  final _messageBarState = getIt.get<MessageBarState>();

  late final List<ViewCommand> _commandHistory = [];
  int _index = 0;

  void process(ViewCommand command) {
    if (command.isRedoPossible) {
      _clearHistoryPastCurrentIndex();
      command.execute();
      _commandHistory.add(command);
      _index++;
      _updateStatusMessageAndNotifyListeners(command.executeMessage);
    }
  }

  void _updateStatusMessageAndNotifyListeners(String message) {
    _messageBarState.statusMessage = message;
    notifyListeners();
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
    if (targetIndex != null) {
      var command = _commandHistory[targetIndex];
      command.undo();
      _index = targetIndex;
      _updateStatusMessageAndNotifyListeners(command.undoMessage);
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
      if (_commandHistory[i].isRedoPossible) {
        return true;
      }
    }
    return false;
  }

  void navigateForward() {
    int? targetIndex = _nextValidIndex;
    if (targetIndex != null) {
      ViewCommand command = _commandHistory[targetIndex];
      command.redo();
      _index = targetIndex + 1;
      _updateStatusMessageAndNotifyListeners(command.executeMessage);
    }
  }

  int? get _nextValidIndex {
    for (int i = _index; i < _commandHistory.length; i++) {
      if (_commandHistory[i].isRedoPossible) {
        return i;
      }
    }
    return null;
  }

  void reset() {
    _commandHistory.clear();
    _index = 0;
  }

  String get historyStateString {
    int? previousValidIndex = _previousValidIndex;
    int? nextValidIndex = _nextValidIndex;
    String historyStateString = "ViewProcessor history:\n";
    for (int i = 0; i < _commandHistory.length; i++) {
      if (i == _index) {
        historyStateString += "(Current)";
      }
      historyStateString += "[";
      if (previousValidIndex != null && previousValidIndex == i) {
        historyStateString += "(Previous)";
      }
      if (nextValidIndex != null && nextValidIndex == i) {
        historyStateString += "(Next)";
      }
      historyStateString += "${_commandHistory[i]}]\n";
    }
    if (_commandHistory.isEmpty) {
      historyStateString += "(empty)";
    } else if (_index == _commandHistory.length) {
      historyStateString += "(Current)";
    }
    return historyStateString;
  }

  int get index => _index;
}
