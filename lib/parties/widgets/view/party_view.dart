import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../characters/model/character.dart';
import '../../../characters/widgets/character_button.dart';
import '../../../locations/model/location.dart';
import '../../../locations/widgets/buttons/location_button.dart';
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
    return [
      buildTableRow(
          context, "Characters in party", _buildCharactersInParty(context)),
      buildTableRow(
          context, "Present location", _buildPresentLocation(context)),
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

  Widget _buildPresentLocation(BuildContext context) {
    Location? presentLocation =
        context.watch<PartyViewController>().presentLocation;
    if(presentLocation == null){
      return const Text("unknown");
    }
    return LocationButton(presentLocation);
  }
}
