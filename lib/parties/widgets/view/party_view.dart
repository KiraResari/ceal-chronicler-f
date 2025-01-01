import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../characters/model/character.dart';
import '../../../characters/widgets/character_button.dart';
import '../../../key_fields/location_id_key_field.dart';
import '../../../locations/widgets/panels/location_id_key_field_panel.dart';
import '../../../utils/string_key.dart';
import '../../../utils/widgets/temporal_entity_view.dart';
import '../../model/party.dart';
import 'party_view_controller.dart';

class PartyView extends TemporalEntityView<Party, PartyViewController> {
  PartyView({required Party party})
      : super(entity: party, key: StringKey(party.toString()));

  @override
  PartyViewController createController() {
    return PartyViewController(entity);
  }

  @override
  List<TableRow> buildAdditionalEntityTableChildren(BuildContext context) {
    LocationIdKeyField locationIdKeyField =
        context.watch<PartyViewController>().locationIdKeyField;
    return [
      buildTableRow(context, "Present Location",
          LocationIdKeyFieldPanel(locationIdKeyField)),
      buildTableRow(
          context, "Characters in party", _buildCharactersInParty(context)),
    ];
  }

  Widget _buildCharactersInParty(BuildContext context) {
    List<Character> charactersPresent =
        context.watch<PartyViewController>().activeCharacters;
    if (charactersPresent.isEmpty) {
      return const Text("none");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: charactersPresent
          .map((character) => CharacterButton(character))
          .toList(),
    );
  }
}
