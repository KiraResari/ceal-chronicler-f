import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../key_fields/party_id_key_field.dart';
import '../../../key_fields/widgets/next_key_button.dart';
import '../../../key_fields/widgets/previous_key_button.dart';
import '../../../key_fields/widgets/select_key_button.dart';
import '../../../key_fields/widgets/toggle_key_button.dart';
import '../../model/party.dart';
import '../../model/party_id.dart';
import '../buttons/party_button.dart';
import 'party_id_key_field_panel_controller.dart';

class PartyIdKeyFieldPanel extends StatelessWidget {
  final PartyIdKeyField keyField;

  const PartyIdKeyFieldPanel(this.keyField, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PartyIdKeyFieldPanelController(keyField),
      builder: (context, child) => _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Row(
      children: [
        _buildPreviousKeyButton(context),
        _buildAddOrRemoveKeyButton(context),
        _buildNextKeyButton(context),
        _buildPresentPartyButton(context),
        _buildEditButton(context),
      ],
    );
  }

  Widget _buildPreviousKeyButton(BuildContext context) {
    var controller = context.read<PartyIdKeyFieldPanelController>();
    bool enabled = context.watch<PartyIdKeyFieldPanelController>().hasPrevious;
    return PreviousKeyButton(controller, enabled);
  }

  Widget _buildNextKeyButton(BuildContext context) {
    var controller = context.read<PartyIdKeyFieldPanelController>();
    bool enabled = context.watch<PartyIdKeyFieldPanelController>().hasNext;
    return NextKeyButton(controller, enabled);
  }

  Widget _buildAddOrRemoveKeyButton(BuildContext context) {
    var controller = context.read<PartyIdKeyFieldPanelController>();
    bool keyExistsAtCurrentPointInTime = context
        .watch<PartyIdKeyFieldPanelController>()
        .keyExistsAtCurrentPointInTime;
    return ToggleKeyButton(controller, keyExistsAtCurrentPointInTime);
  }

  Widget _buildPresentPartyButton(BuildContext context) {
    Party? party = context.watch<PartyIdKeyFieldPanelController>().presentParty;
    if (party != null) {
      return PartyButton(party);
    }
    return const Text("none");
  }

  Widget _buildEditButton(BuildContext context) {
    List<DropdownMenuEntry<PartyId>> entries =
        context.watch<PartyIdKeyFieldPanelController>().validPartyEntries;
    var controller = context.read<PartyIdKeyFieldPanelController>();
    return SelectKeyButton(
      controller: controller,
      entries: entries,
      labelText: "Assign character to party",
    );
  }
}
