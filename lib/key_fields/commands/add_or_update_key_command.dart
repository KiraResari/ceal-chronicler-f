import '../../commands/command.dart';
import '../key_field.dart';
import '../../timeline/model/point_in_time_id.dart';

class AddOrUpdateKeyCommand<T> extends Command {
  final KeyField<T> keyField;
  final PointInTimeId pointInTimeId;
  final T value;
  T? previousValue;

  AddOrUpdateKeyCommand(this.keyField, this.pointInTimeId, this.value);

  @override
  void execute() {
    previousValue = keyField.keys[pointInTimeId];
    keyField.keys[pointInTimeId] = value;
  }

  @override
  String get executeMessage {
    if (previousValue == null) {
      return "Added key with value $value at $pointInTimeId";
    }
    return "Changed value of key at $pointInTimeId from $previousValue to $value";
  }

  @override
  void undo() {
    if (previousValue == null) {
      keyField.deleteKeyAtTime(pointInTimeId);
    } else {
      keyField.keys[pointInTimeId] = previousValue as T;
    }
  }

  @override
  String get undoMessage {
    if (previousValue == null) {
      return "Undid adding of key with value $value at $pointInTimeId";
    }
    return "Undid changing of value of key at $pointInTimeId from $previousValue to $value";
  }
}
