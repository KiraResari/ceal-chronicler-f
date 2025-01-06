import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/model/temporal_entity.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/move_attribute_down_command.dart';
import '../model/attribute.dart';

class MoveAttributeDownButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();
  final Attribute attribute;
  final TemporalEntity entity;
  final bool enabled;

  MoveAttributeDownButton(this.entity, this.attribute, this.enabled, {super.key})
      : super(icon: Icons.arrow_downward);

  @override
  void onPressed(BuildContext context) {
    var command = MoveAttributeDownCommand(entity, attribute);
    commandProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) => enabled;

  @override
  String? getDisabledReason(BuildContext context) =>
      "Attribute can't be moved down";

  @override
  String? get tooltip => "Move attribute down";
}
