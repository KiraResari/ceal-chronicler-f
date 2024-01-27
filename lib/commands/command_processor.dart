import 'package:ceal_chronicler_f/exceptions/operation_canceled_exception.dart';
import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../io/file/file_service.dart';
import '../exceptions/command_failed_exception.dart';
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
      throw CommandFailedException(
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
      throw CommandFailedException(
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
    notifyListeners();
  }

  bool get isUndoPossible => _index > 0;

  void redo() {
    try {
      if (isRedoPossible) {
        _performRedo();
      }
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
    Command commandToRedo = _commandHistory[_index];
    commandToRedo.execute();
    _index++;
    notifyListeners();
  }

  bool get isRedoPossible => _index < _commandHistory.length;

  bool get isSavingNecessary {
    return _index != _savedAtIndex;
  }

  Future<void> save() async {
    try {
      await _fileService.save();
      _savedAtIndex = _index;
      _statusMessage = saveCompletedMessage;
    } on OperationCanceledException {
      _statusMessage = saveCancelledMessage;
    }
    notifyListeners();
  }

  Future<void> load() async {
    try {
      await _fileService.load();
      _resetHistoryAndIndexes();
      _statusMessage = loadCompletedMessage;
    } on OperationCanceledException {
      _statusMessage = loadCancelledMessage;
    }
    notifyListeners();
  }

  void _resetHistoryAndIndexes() {
    _commandHistory.clear();
    _index = 0;
    _savedAtIndex = 0;
  }
}
