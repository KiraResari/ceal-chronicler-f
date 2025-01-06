import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/buttons/small_circular_button.dart';
import '../commands/move_attribute_up_command.dart';

class MoveAttributeUpButton<T extends Object> extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();
  final T attribute;
  final List<T> list;
  final bool enabled;

  MoveAttributeUpButton(this.list, this.attribute, this.enabled, {super.key})
      : super(icon: Icons.arrow_upward);

  @override
  void onPressed(BuildContext context) {
    var command = MoveAttributeUpCommand(list, attribute);
    commandProcessor.process(command);
  }

  @override
  bool isEnabled(BuildContext context) => enabled;

  @override
  String? getDisabledReason(BuildContext context) =>
      "Attribute can't be moved up";

  @override
  String? get tooltip => "Move attribute up";
}
