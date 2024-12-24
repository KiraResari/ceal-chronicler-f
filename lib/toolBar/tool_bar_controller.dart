import '../commands/processor_listener.dart';
import '../exceptions/operation_canceled_exception.dart';
import '../view/commands/open_overview_view_command.dart';

class ToolBarController extends ProcessorListener {
  ToolBarController() : super();

  bool get isUndoPossible => commandProcessor.isUndoPossible;

  bool get isRedoPossible => commandProcessor.isRedoPossible;

  bool get isSavingPossible => fileProcessor.isSavingNecessary;

  bool get isNavigatingBackPossible => viewProcessor.isNavigatingBackPossible;

  bool get isNavigatingForwardPossible =>
      viewProcessor.isNavigatingForwardPossible;

  void undo() => commandProcessor.undo();

  void redo() => commandProcessor.redo();

  Future<void> save() => fileProcessor.save();

  Future<void> load() async {
    try {
      await fileProcessor.load();
      viewProcessor.process(OpenOverviewViewCommand());
      viewProcessor.reset();
    } on OperationCanceledException {
      //Don't reset viewProcessor if operation was canceled
    }
  }

  void navigateBack() => viewProcessor.navigateBack();

  void navigateForward() => viewProcessor.navigateForward();
}
