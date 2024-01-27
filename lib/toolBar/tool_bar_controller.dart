import 'package:flutter/material.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';

class ToolBarController extends ChangeNotifier {
  final _commandProcessor = getIt.get<CommandProcessor>();

  ToolBarController() {
    _commandProcessor.addListener(() => notifyListeners());
  }

  bool get isUndoPossible => _commandProcessor.isUndoPossible;

  bool get isRedoPossible => _commandProcessor.isRedoPossible;

  bool get isSavingPossible => _commandProcessor.isSavingNecessary;

  void undo() {
    _commandProcessor.undo();
  }

  void redo() {
    _commandProcessor.redo();
  }

  void save() {
    _commandProcessor.save();
  }
}
