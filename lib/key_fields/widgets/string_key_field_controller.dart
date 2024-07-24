import 'package:ceal_chronicler_f/key_fields/commands/add_or_update_key_command.dart';
import 'package:ceal_chronicler_f/key_fields/widgets/key_field_controller.dart';

import '../../timeline/model/point_in_time_id.dart';

class StringKeyFieldController extends KeyFieldController<String>{
  StringKeyFieldController(super.keyField);

  void renameKey(String newName) {
    PointInTimeId pointInTimeId = pointInTimeRepository.activePointInTime.id;
    var command = AddOrUpdateKeyCommand(keyField, pointInTimeId, newName);
    commandProcessor.process(command);
  }

}