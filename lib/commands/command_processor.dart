import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../message_bar/message_bar_state.dart';
import 'command.dart';
import 'command_history.dart';

class CommandProcessor extends ChangeNotifier {
  final _messageBarState = getIt.get<MessageBarState>();
  final _commandHistory = getIt.get<CommandHistory>();

  void process(Command command) {
    try {
      _processCommand(command);
    } catch (e) {
      _updateStatusMessageAndNotifyListeners(
        "Processing of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _processCommand(Command command) {
    _commandHistory.clearPastCurrentIndex();
    command.execute();
    _commandHistory.add(command);
    _updateStatusMessageAndNotifyListeners(command.executeMessage);
  }

  void _updateStatusMessageAndNotifyListeners(String message) {
    _messageBarState.statusMessage = message;
    notifyListeners();
  }

  void undo() {
    try {
      if (isUndoPossible) {
        _performUndo();
      }
    } catch (e) {
      Command command = _commandHistory.undoCommand;
      _updateStatusMessageAndNotifyListeners(
        "Undo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _performUndo() {
    Command commandToUndo = _commandHistory.undoCommand;
    _commandHistory.decrementIndex();
    commandToUndo.undo();
    _updateStatusMessageAndNotifyListeners(commandToUndo.undoMessage);
  }

  bool get isUndoPossible => _commandHistory.isUndoPossible;

  void redo() {
    try {
      if (isRedoPossible) {
        _performRedo();
      }
    } catch (e) {
      Command command = _commandHistory.redoCommand;
      _updateStatusMessageAndNotifyListeners(
        "Redo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _performRedo() {
    Command commandToRedo = _commandHistory.redoCommand;
    commandToRedo.execute();
    _commandHistory.incrementIndex();
    _updateStatusMessageAndNotifyListeners(commandToRedo.executeMessage);
  }

  bool get isRedoPossible => _commandHistory.isRedoPossible;
}
