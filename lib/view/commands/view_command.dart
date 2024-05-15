abstract class ViewCommand {
  void execute();

  void undo();

  bool get isExecutePossible;

  bool get isUndoPossible;
}
