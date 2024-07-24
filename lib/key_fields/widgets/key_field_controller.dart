import 'package:ceal_chronicler_f/key_fields/commands/add_or_update_key_command.dart';
import 'package:ceal_chronicler_f/key_fields/commands/delete_key_command.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';

import '../../../../commands/processor_listener.dart';
import '../../../../get_it_context.dart';
import '../../../../timeline/model/point_in_time_id.dart';
import '../../commands/command.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../key_field.dart';
import '../key_field_resolver.dart';

class KeyFieldController<T> extends ProcessorListener {
  final KeyField<T> keyField;

  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  KeyFieldController(this.keyField);

  T get currentValue => _keyFieldResolver.getCurrentValue(keyField);

  bool get hasNext => _keyFieldResolver.hasNext(keyField);

  bool get hasPrevious => _keyFieldResolver.hasPrevious(keyField);

  bool get keyExistsAtCurrentPointInTime =>
      _keyFieldResolver.keyExistsAtCurrentPointInTime(keyField);

  void goToPrevious() {
    PointInTimeId? pointInTimeId =
        _keyFieldResolver.getPreviousPointInTimeId(keyField);
    if (pointInTimeId != null) {
      var command = ActivatePointInTimeCommand(pointInTimeId);
      viewProcessor.process(command);
    }
  }

  void goToNext() {
    PointInTimeId? pointInTimeId =
        _keyFieldResolver.getNextPointInTimeId(keyField);
    if (pointInTimeId != null) {
      var command = ActivatePointInTimeCommand(pointInTimeId);
      viewProcessor.process(command);
    }
  }

  void toggleKey() => commandProcessor.process(_toggleCommand);

  Command get _toggleCommand {
    PointInTimeId pointInTimeId = _pointInTimeRepository.activePointInTime.id;
    if (keyExistsAtCurrentPointInTime) {
      return DeleteKeyCommand(keyField, pointInTimeId);
    }
    return AddOrUpdateKeyCommand(keyField, pointInTimeId, currentValue);
  }
}
