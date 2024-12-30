import '../../../characters/model/character.dart';
import '../../../characters/model/character_repository.dart';
import '../../../get_it_context.dart';
import '../../../locations/model/location.dart';
import '../../../utils/widgets/temporal_entity_view_controller.dart';
import '../../model/party.dart';
import '../../model/party_id.dart';
import '../../party_location_resolver.dart';

class PartyViewController extends TemporalEntityViewController<Party> {
  PartyViewController(Party party) : super(party);
  final _characterRepository = getIt.get<CharacterRepository>();
  final _partyLocationResolver = getIt.get<PartyLocationResolver>();

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

  Location? get presentLocation =>
      _partyLocationResolver.getPresentLocationOf(entity);
}
