import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';

import '../../locations/model/location.dart';
import '../../parties/model/party.dart';
import '../../parties/model/party_repository.dart';

import '../../get_it_context.dart';
import '../../key_fields/location_id_key_field.dart';
import '../../key_fields/party_id_key_field.dart';
import '../../parties/model/party_id.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  var partyRepository = getIt.get<PartyRepository>();
  var locationRepository = getIt.get<LocationRepository>();

  LocationIdKeyField get locationIdKeyField => entity.presentLocation;

  PartyIdKeyField get partyIdKeyField => entity.party;

  bool get isPresentlyInParty {
    PartyId? presentParty = keyFieldResolver.getCurrentValue(entity.party);
    return presentParty != null;
  }

  Location? get partyLocation {
    PartyId? partyId = keyFieldResolver.getCurrentValue(entity.party);
    if (partyId == null) {
      return null;
    }
    Party? presentParty = partyRepository.getContentElementById(partyId);
    if (presentParty == null) {
      return null;
    }
    LocationId? locationId =
        keyFieldResolver.getCurrentValue(presentParty.presentLocation);
    return locationId == null
        ? null
        : locationRepository.getContentElementById(locationId);
  }
}
