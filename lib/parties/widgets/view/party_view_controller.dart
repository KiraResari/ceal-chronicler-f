import '../../../characters/model/character.dart';
import '../../../characters/model/character_repository.dart';
import '../../../get_it_context.dart';
import '../../../key_fields/location_id_key_field.dart';
import '../../../utils/widgets/temporal_entity_view_controller.dart';
import '../../model/party.dart';
import '../../model/party_id.dart';

class PartyViewController extends TemporalEntityViewController<Party> {
  PartyViewController(Party party) : super(party);
  final _characterRepository = getIt.get<CharacterRepository>();

  LocationIdKeyField get locationIdKeyField => entity.presentLocation;

  List<Character> get activeCharacters {
    return _characterRepository.content
        .where((character) => _characterIsActiveAndInParty(character))
        .toList();
  }

  bool _characterIsActiveAndInParty(Character character) {
    PartyId? currentPartyId = keyFieldResolver.getCurrentValue(character.party);
    bool characterIsInParty = currentPartyId == entity.id;
    bool characterIsActive =
        pointInTimeRepository.entityIsPresentlyActive(character);
    return characterIsInParty && characterIsActive;
  }
}
