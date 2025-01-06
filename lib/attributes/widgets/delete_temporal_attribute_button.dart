import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/model/temporal_entity.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/delete_temporal_attribute_command.dart';
import '../model/temporal_attribute.dart';

class DeleteTemporalAttributeButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();
  final TemporalEntity entity;
  final TemporalAttribute attribute;

  DeleteTemporalAttributeButton(this.entity, this.attribute, {super.key})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeleteTemporalAttributeCommand(entity, attribute);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete temporal attribute";
}
