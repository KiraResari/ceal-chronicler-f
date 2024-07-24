import '../../commands/command.dart';
import '../../exceptions/invalid_operation_exception.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../key_field.dart';

class DeleteKeyCommand<T> extends Command {
  final KeyField<T> keyField;
  final PointInTimeId pointInTimeId;
  T? deletedValue;

  DeleteKeyCommand(this.keyField, this.pointInTimeId);

  @override
  void execute() {
    deletedValue = keyField.keys[pointInTimeId];
    keyField.deleteKeyAtTime(pointInTimeId);
  }

  @override
  String get executeMessage =>
      "Deleted key at $pointInTimeId with value $deletedValue";

  @override
  void undo() {
    if (deletedValue != null) {
      keyField.addOrUpdateKeyAtTime(deletedValue as T, pointInTimeId);
    } else {
      throw InvalidOperationException(
          "Could not restore key at $pointInTimeId because the previous value could not be found");
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of key at $pointInTimeId with value $deletedValue";
}
