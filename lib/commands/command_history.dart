import 'command.dart';

class CommandHistory {
  final List<Command> _commandHistory = [];
  int _index = 0;
  int _savedAtIndex = 0;

  void add(Command command) {
    _commandHistory.add(command);
    _index++;
  }

  void clearPastCurrentIndex() {
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

  Command get undoCommand => _commandHistory[_index - 1];

  Command get redoCommand => _commandHistory[_index];

  void incrementIndex() => _index++;

  void decrementIndex() => _index--;

  bool get isUndoPossible => _index > 0;

  bool get isRedoPossible => _index < _commandHistory.length;

  bool get isSavingNecessary {
    return _index != _savedAtIndex;
  }

  void setSavedAtIndexToCurrentIndex() => _savedAtIndex = _index;

  void resetHistoryAndIndexes() {
    _commandHistory.clear();
    _index = 0;
    _savedAtIndex = 0;
  }
}
