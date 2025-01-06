import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/model/temporal_entity.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/delete_attribute_command.dart';
import '../model/attribute.dart';

class DeleteAttributeButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();
  final TemporalEntity entity;
  final Attribute attribute;

  DeleteAttributeButton(this.entity, this.attribute, {super.key})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteAttributeCommand(entity, attribute);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete attribute";
}
