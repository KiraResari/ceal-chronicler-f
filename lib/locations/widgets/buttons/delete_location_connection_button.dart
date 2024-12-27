import 'package:flutter/material.dart';

import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';
import '../../../utils/widgets/buttons/small_circular_button.dart';
import '../../commands/delete_location_connection_command.dart';
import '../../model/location_connection.dart';

class DeleteLocationConnectionButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();

  final LocationConnection locationConnection;

  DeleteLocationConnectionButton(this.locationConnection, {super.key})
      : super(icon: Icons.link_off);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteLocationConnectionCommand(locationConnection);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Break connection";
}
