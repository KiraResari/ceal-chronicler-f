import '../../commands/command.dart';
import '../../exceptions/invalid_operation_exception.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../key_field.dart';

class DeleteKeyCommand<T> extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

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
      "Deleted key at point in time '$_pointInTimeNameOrUnknown' with value '$deletedValue'";

  @override
  void undo() {
    if (deletedValue != null) {
      keyField.addOrUpdateKeyAtTime(deletedValue as T, pointInTimeId);
    } else {
      throw InvalidOperationException(
          "Could not restore key at point in time '$_pointInTimeNameOrUnknown' because the previous value could not be found");
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of key at point in time '$_pointInTimeNameOrUnknown' with value '$deletedValue'";

  String get _pointInTimeNameOrUnknown {
    PointInTime? point = _pointInTimeRepository.get(pointInTimeId);
    return point != null ? point.name : "unknown";
  }
}
