import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/model/temporal_entity.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/create_attribute_command.dart';

class AddAttributeButton extends SmallCircularButton {
  final CommandProcessor commandProcessor = getIt.get<CommandProcessor>();
  final TemporalEntity entity;

  AddAttributeButton(this.entity, {super.key}) : super(icon: Icons.add);

  @override
  void onPressed(BuildContext context) {
    var command = CreateAttributeCommand(entity);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Add new attribute";
}
