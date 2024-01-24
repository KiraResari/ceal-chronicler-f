import 'command.dart';

class CommandStack {
  final List<Command> _commandHistory = [];
  int _index = 0;

  void addAndExecute(Command command) {
    _clearHistoryPastCurrentIndex();
    command.execute();
    _commandHistory.add(command);
    _index++;
  }

  void _clearHistoryPastCurrentIndex() {
    int removalRangeStart = _index;
    int removalRangeEnd = _commandHistory.length;
    _commandHistory.removeRange(removalRangeStart, removalRangeEnd);
  }

  void undo() {
    if (_historyIsEmpty) {
      return;
    }
    _index--;
    Command commandToUndo = _commandHistory[_index];
    commandToUndo.undo();
  }

  bool get _historyIsEmpty => _index == 0;

  void redo() {
    if (_nothingToRedo) {
      return;
    }
    _index++;
    Command commandToRedo = _commandHistory[_index];
    commandToRedo.execute();
  }

  bool get _nothingToRedo => _index == _commandHistory.length;
}
