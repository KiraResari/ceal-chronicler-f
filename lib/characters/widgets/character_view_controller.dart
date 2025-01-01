import '../../key_fields/location_id_key_field.dart';
import '../../key_fields/party_id_key_field.dart';
import '../../parties/model/party_id.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  LocationIdKeyField get locationIdKeyField => entity.presentLocation;

  PartyIdKeyField get partyIdKeyField => entity.party;

  bool get isPresentlyInParty {
    PartyId? presentParty = keyFieldResolver.getCurrentValue(entity.party);
    return presentParty != null;
  }
}
