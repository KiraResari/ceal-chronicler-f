import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../key_field.dart';

class AddOrUpdateKeyCommand<T> extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  final KeyField<T?> keyField;
  final PointInTimeId pointInTimeId;
  final T? value;
  T? previousValue;
  bool previousKeyExisted = false;

  AddOrUpdateKeyCommand(this.keyField, this.pointInTimeId, this.value);

  @override
  void execute() {
    if(keyField.keys.containsKey(pointInTimeId)){
      previousValue = keyField.keys[pointInTimeId];
      previousKeyExisted = true;
    }
    keyField.keys[pointInTimeId] = value;
  }

  @override
  String get executeMessage {
    if (previousValue == null) {
      return "Added key with value '${_prettify(value)}' at point in time '$_pointInTimeNameOrUnknown'";
    }
    return "Changed value of key at point in time '$_pointInTimeNameOrUnknown' from '${_prettify(previousValue)}' to '${_prettify(value)}'";
  }

  @override
  void undo() {
    if (previousKeyExisted) {
      keyField.keys[pointInTimeId] = previousValue;
    } else {
      keyField.deleteKeyAtTime(pointInTimeId);
    }
  }

  @override
  String get undoMessage {
    if (previousValue == null) {
      return "Undid adding of key with value '${_prettify(value)}' at point in time '$_pointInTimeNameOrUnknown'";
    }
    return "Undid changing of value of key at point in time '$_pointInTimeNameOrUnknown' from '${_prettify(previousValue)}' to '${_prettify(value)}'";
  }

  String get _pointInTimeNameOrUnknown {
    PointInTime? point = _pointInTimeRepository.get(pointInTimeId);
    return point != null ? point.name : "unknown";
  }

  String _prettify(T? value) {
    if (value == null) {
      return "unknown";
    }
    if (value is String) {
      return value;
    }
    return "$T($value)";
  }
}
