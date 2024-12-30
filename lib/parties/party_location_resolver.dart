import '../characters/model/character.dart';
import '../characters/model/character_repository.dart';
import '../get_it_context.dart';
import '../key_fields/key_field_resolver.dart';
import '../locations/model/location_id.dart';
import '../timeline/model/point_in_time_id.dart';
import 'model/party_id.dart';

class PartyLocationResolver {
  final _characterRepository = getIt.get<CharacterRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  Map<PointInTimeId, LocationId?> getLocationMapOfParty(PartyId id) {
    List<Character> allCharacters = _characterRepository.content;
    Map<PointInTimeId, LocationId?> locationMap = {};
    for (Character character in allCharacters) {
      Map<PointInTimeId, LocationId?> characterLocationKeys =
          character.presentLocation.keys;
      for (var entry in characterLocationKeys.entries) {
        if (_characterIsInPartyAt(character, id, entry.key)) {
          locationMap[entry.key] = entry.value;
        }
      }
    }
    return locationMap;
  }

  bool _characterIsInPartyAt(
      Character character, PartyId id, PointInTimeId pointId) {
    PartyId? partyIdAtPoint =
        _keyFieldResolver.getValueAt(character.party, pointId);
    return id == partyIdAtPoint;
  }
}
