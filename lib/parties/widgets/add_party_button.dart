import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/create_party_command.dart';

class AddPartyButton extends SmallCircularButton {
  final PointInTimeRepository pointInTimeRepository =
      getIt.get<PointInTimeRepository>();
  final CommandProcessor commandProcessor = getIt.get<CommandProcessor>();

  AddPartyButton({super.key}) : super(icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var activePointInTime = pointInTimeRepository.activePointInTime;
    var command = CreatePartyCommand(activePointInTime.id);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Add new party";
}
