import '../characters/model/character.dart';
import '../characters/model/character_repository.dart';
import '../get_it_context.dart';
import '../key_fields/key_field_resolver.dart';
import '../locations/model/location.dart';
import '../locations/model/location_id.dart';
import '../locations/model/location_repository.dart';
import '../timeline/model/point_in_time.dart';
import '../timeline/model/point_in_time_id.dart';
import '../timeline/model/point_in_time_repository.dart';
import 'model/party.dart';
import 'model/party_id.dart';

class PartyLocationResolver {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _characterRepository = getIt.get<CharacterRepository>();
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  Location? getPresentLocationOf(Party party) {
    Map<PointInTimeId, LocationId?> locationMap = getLocationMapOfParty(party);
    LocationId? locationId = _getCurrentValue(locationMap);
    return locationId != null
        ? _locationRepository.getContentElementById(locationId)
        : null;
  }

  Map<PointInTimeId, LocationId?> getLocationMapOfParty(Party party) {
    Map<PointInTimeId, LocationId?> locationMap = {};
    LocationId? lastAddedLocationId =
        LocationId(); //A random ID is assigned here so that a null-assignment will register as a change
    for (PointInTime point in _getSortedPointsInTimeAtWhichPartyExists(party)) {
      Character? character = getFirstCharacterInPartyAt(party, point);
      LocationId? locationIdToAdd = character == null
          ? null
          : _getCharacterLocationAt(character, point.id);
      if (locationIdToAdd != lastAddedLocationId) {
        lastAddedLocationId = locationIdToAdd;
        locationMap[point.id] = locationIdToAdd;
      }
    }
    return locationMap;
  }

  List<PointInTime> _getSortedPointsInTimeAtWhichPartyExists(Party party) {
    PointInTimeId firstAppearance = party.firstAppearance;
    PointInTimeId? lastAppearance = party.lastAppearance;
    return lastAppearance != null
        ? _pointInTimeRepository.getPointsInTimeFromUntilInclusive(
            firstAppearance, lastAppearance)
        : _pointInTimeRepository.pointsInTimeIncludingAndAfter(firstAppearance);
  }

  Character? getFirstCharacterInPartyAt(Party party, PointInTime point) {
    List<Character> allCharacters = _characterRepository.content;
    var charactersInPartyAtPoint = allCharacters
        .where(
            (character) => _characterIsInPartyAt(character, party.id, point.id))
        .toList();
    return charactersInPartyAtPoint.isEmpty
        ? null
        : charactersInPartyAtPoint.first;
  }

  LocationId? _getCharacterLocationAt(
          Character character, PointInTimeId pointId) =>
      _keyFieldResolver.getValueAt(character.presentLocation, pointId);

  bool _characterIsInPartyAt(
    Character character,
    PartyId id,
    PointInTimeId pointId,
  ) {
    PartyId? partyIdAtPoint =
        _keyFieldResolver.getValueAt(character.party, pointId);
    var characterIsInPartyAtPoint = id == partyIdAtPoint;
    var characterIsActiveAtPoint =
        _pointInTimeRepository.entityIsActiveAtPoint(character, pointId);
    return characterIsInPartyAtPoint && characterIsActiveAtPoint;
  }

  LocationId? _getCurrentValue(Map<PointInTimeId, LocationId?> locationMap) {
    LocationId? mostRecentValue;
    for (PointInTime pointInTime
        in _pointInTimeRepository.pastAndPresentPointsInTime) {
      if (locationMap.containsKey(pointInTime.id)) {
        mostRecentValue = locationMap[pointInTime.id];
      }
    }
    return mostRecentValue;
  }
}
