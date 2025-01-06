import 'package:flutter/material.dart';

import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';
import '../../commands/attributes/create_attribute_command.dart';
import '../../model/temporal_entity.dart';
import '../buttons/small_circular_button.dart';

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
