import 'package:flutter/material.dart';

import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';
import '../../../utils/widgets/buttons/small_circular_button.dart';
import '../../commands/delete_party_command.dart';
import '../../model/party.dart';

class DeletePartyButton extends SmallCircularButton {
  final commandProcessor = getIt.get<CommandProcessor>();

  final Party party;

  DeletePartyButton(this.party, {super.key}) : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var command = DeletePartyCommand(party);
    commandProcessor.process(command);
  }

  @override
  String? get tooltip => "Delete party";
}
