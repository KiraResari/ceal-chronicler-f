abstract class Command {
  void execute();

  void undo();

  String get executeMessage;

  String get undoMessage;
}
