import 'package:flutter/material.dart';

import '../exceptions/operation_canceled_exception.dart';
import '../get_it_context.dart';
import '../io/file/file_service.dart';
import 'command.dart';

class CommandProcessor extends ChangeNotifier {
  static const String saveCancelledMessage = "Saving cancelled";
  static const String saveCompletedMessage = "Chronicle saved!";
  static const String loadCancelledMessage = "Loading cancelled";
  static const String loadCompletedMessage = "Loaded chronicle";

  final _fileService = getIt.get<FileService>();

  final List<Command> _commandHistory = [];
  int _index = 0;
  int _savedAtIndex = 0;

  String _statusMessage = "Welcome to the Ceal Chronicler";

  String get statusMessage => _statusMessage;

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
    _clearHistoryPastCurrentIndex();
    command.execute();
    _commandHistory.add(command);
    _index++;
    _updateStatusMessageAndNotifyListeners(command.executeMessage);
  }

  void _updateStatusMessageAndNotifyListeners(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
    _makeSavingNecessaryIfSavedIndexWasRemoved();
  }

  void _makeSavingNecessaryIfSavedIndexWasRemoved() {
    if (_savedAtIndex > _index) {
      _savedAtIndex = -1;
    }
  }

  void undo() {
    try {
      if (isUndoPossible) {
        _performUndo();
      }
    } catch (e) {
      Command command = _commandHistory[_index - 1];
      _updateStatusMessageAndNotifyListeners(
        "Undo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _performUndo() {
    _index--;
    Command commandToUndo = _commandHistory[_index];
    commandToUndo.undo();
    _updateStatusMessageAndNotifyListeners(commandToUndo.undoMessage);
  }

  bool get isUndoPossible => _index > 0;

  void redo() {
    try {
      if (isRedoPossible) {
        _performRedo();
      }
    } catch (e) {
      Command command = _commandHistory[_index];
      _updateStatusMessageAndNotifyListeners(
        "Redo of command failed\n"
        "Command: $command\n"
        "Cause: $e",
      );
    }
  }

  void _performRedo() {
    Command commandToRedo = _commandHistory[_index];
    commandToRedo.execute();
    _index++;
    _updateStatusMessageAndNotifyListeners(commandToRedo.executeMessage);
  }

  bool get isRedoPossible => _index < _commandHistory.length;

  bool get isSavingNecessary {
    return _index != _savedAtIndex;
  }

  Future<void> save() async {
    try {
      await _fileService.save();
      _savedAtIndex = _index;
      _updateStatusMessageAndNotifyListeners(saveCompletedMessage);
    } on OperationCanceledException {
      _updateStatusMessageAndNotifyListeners(saveCancelledMessage);
    }
  }

  Future<void> load() async {
    try {
      await _fileService.load();
      _resetHistoryAndIndexes();
      _updateStatusMessageAndNotifyListeners(loadCompletedMessage);
    } on OperationCanceledException {
      _updateStatusMessageAndNotifyListeners(loadCancelledMessage);
      throw OperationCanceledException();
    }
  }

  void _resetHistoryAndIndexes() {
    _commandHistory.clear();
    _index = 0;
    _savedAtIndex = 0;

  }
}
