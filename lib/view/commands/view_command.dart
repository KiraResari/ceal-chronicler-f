abstract class ViewCommand {
  void execute();

  void undo();

  void redo();

  bool get isUndoPossible;

  bool get isRedoPossible;

  String get executeMessage;

  String get undoMessage;
}
