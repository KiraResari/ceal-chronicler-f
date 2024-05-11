import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter/material.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';

class ToolBarController extends ChangeNotifier {
  final _commandProcessor = getIt.get<CommandProcessor>();
  final _viewProcessor = getIt.get<ViewProcessor>();

  ToolBarController() {
    _commandProcessor.addListener(() => notifyListeners());
    _viewProcessor.addListener(() => notifyListeners());
  }

  bool get isUndoPossible => _commandProcessor.isUndoPossible;

  bool get isRedoPossible => _commandProcessor.isRedoPossible;

  bool get isSavingPossible => _commandProcessor.isSavingNecessary;

  bool get isNavigatingBackPossible => _viewProcessor.isNavigatingBackPossible;

  bool get isNavigatingForwardPossible =>
      _viewProcessor.isNavigatingForwardPossible;

  void undo() => _commandProcessor.undo();

  void redo() => _commandProcessor.redo();

  void save() => _commandProcessor.save();

  void load() => _commandProcessor.load();

  void navigateBack() => _viewProcessor.navigateBack();

  void navigateForward() => _viewProcessor.navigateForward();
}
