abstract class Command {
  Future<void> execute();

  Future<void> undo();
}
