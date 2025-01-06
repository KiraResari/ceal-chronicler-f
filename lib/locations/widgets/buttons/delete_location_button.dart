import 'package:flutter/material.dart';

import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';
import '../../../utils/widgets/buttons/small_circular_button.dart';
import '../../commands/delete_location_command.dart';
import '../../model/location.dart';

class DeleteLocationButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();

  final Location location;

  DeleteLocationButton(this.location, {super.key}) : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteLocationCommand(location);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete location";
}
