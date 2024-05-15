import '../commands/processor_listener.dart';
import '../exceptions/operation_canceled_exception.dart';

class ToolBarController extends ProcessorListener {
  ToolBarController() : super();

  bool get isUndoPossible => commandProcessor.isUndoPossible;

  bool get isRedoPossible => commandProcessor.isRedoPossible;

  bool get isSavingPossible => commandProcessor.isSavingNecessary;

  bool get isNavigatingBackPossible => viewProcessor.isNavigatingBackPossible;

  bool get isNavigatingForwardPossible =>
      viewProcessor.isNavigatingForwardPossible;

  void undo() => commandProcessor.undo();

  void redo() => commandProcessor.redo();

  void save() => commandProcessor.save();

  Future<void> load() async {
    try {
      await commandProcessor.load();
      viewProcessor.reset();
    } on OperationCanceledException {
      //Don't reset viewProcessor if operation was canceled
    }
  }

  void navigateBack() => viewProcessor.navigateBack();

  void navigateForward() => viewProcessor.navigateForward();
}
