import 'package:ceal_chronicler_f/locations/widgets/buttons/location_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../key_fields/location_id_key_field.dart';
import '../../key_fields/party_id_key_field.dart';
import '../../locations/model/location.dart';
import '../../locations/widgets/panels/location_id_key_field_panel.dart';
import '../../parties/widgets/panels/party_id_key_field_panel.dart';
import '../../utils/string_key.dart';
import '../../utils/widgets/temporal_entity_view.dart';
import '../model/character.dart';
import 'character_view_controller.dart';

class CharacterView
    extends TemporalEntityView<Character, CharacterViewController> {
  CharacterView({required Character character})
      : super(entity: character, key: StringKey(character.toString()));

  @override
  CharacterViewController createController() {
    return CharacterViewController(entity);
  }

  @override
  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) {
    PartyIdKeyField partyIdKeyField =
        context.watch<CharacterViewController>().partyIdKeyField;
    return [
      buildNamedTableRow(
          context, "Present Location", _buildPresentLocationPanel(context)),
      buildNamedTableRow(
          context, "Party", PartyIdKeyFieldPanel(entity, partyIdKeyField)),
    ];
  }

  Widget _buildPresentLocationPanel(BuildContext context) {
    bool characterIsInParty =
        context.watch<CharacterViewController>().isPresentlyInParty;
    if (characterIsInParty) {
      Location? partyLocation =
          context.watch<CharacterViewController>().partyLocation;
      return partyLocation == null
          ? const Text("unknown")
          : LocationButton(partyLocation);
    }
    LocationIdKeyField locationIdKeyField =
        context.watch<CharacterViewController>().locationIdKeyField;
    return LocationIdKeyFieldPanel(locationIdKeyField);
  }
}
