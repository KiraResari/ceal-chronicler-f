import '../../characters/model/character.dart';
import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../key_fields/location_id_key_field.dart';
import '../../locations/model/location_id.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/party.dart';
import '../model/party_id.dart';
import '../party_location_resolver.dart';

class AddOrUpdatePartyAffiliationCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _partyLocationResolver = getIt.get<PartyLocationResolver>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeId pointId;
  final Character character;
  final Party? party;
  PartyId? previousPartyId;
  bool previousKeyExisted = false;
  String? previousLocationKeys;

  AddOrUpdatePartyAffiliationCommand(this.character, this.party, this.pointId);

  @override
  void execute() {
    if (character.party.keys.containsKey(pointId)) {
      previousPartyId = _keyFieldResolver.getValueAt(character.party, pointId);
      previousKeyExisted = true;
    }
    Map<PointInTimeId, LocationId?> partyLocationMapBeforeAddingCharacter =
        partyLocationMap;
    character.party.addOrUpdateKeyAtTime(party?.id, pointId);
    if (partyLocationMapBeforeAddingCharacter.isNotEmpty) {
      previousLocationKeys = character.presentLocation.toJsonString();
      imprintPartyLocationsOnCharacter(partyLocationMapBeforeAddingCharacter);
    }
  }

  Map<PointInTimeId, LocationId?> get partyLocationMap {
    return party == null
          ? {}
          : _partyLocationResolver.getLocationMapOfParty(party!);
  }

  void imprintPartyLocationsOnCharacter(
    Map<PointInTimeId, LocationId?> partyLocationMap,
  ) {
    for (var entry in partyLocationMap.entries) {
      PartyId? characterPartyAffiliationAtEntry =
          _keyFieldResolver.getValueAt(character.party, entry.key);
      if (party != null && characterPartyAffiliationAtEntry == party!.id) {
        character.presentLocation.addOrUpdateKeyAtTime(entry.value, entry.key);
      }
    }
  }

  @override
  String get executeMessage =>
      "Added character '$characterName' to party '$partyName' at '$pointName'";

  @override
  void undo() {
    if (previousKeyExisted) {
      character.party.addOrUpdateKeyAtTime(party?.id, pointId);
    } else {
      character.party.deleteKeyAtTime(pointId);
    }
    if (previousLocationKeys != null) {
      character.presentLocation =
          LocationIdKeyField.fromJsonString(previousLocationKeys!);
    }
  }

  @override
  String get undoMessage =>
      "Undid adding of character '$characterName' to party '$partyName' at '$pointName'";

  String get characterName =>
      _keyFieldResolver.getCurrentValue(character.name) ?? "unknown";

  String get partyName {
    if(party == null){
      return "none";
    }
    return _keyFieldResolver.getCurrentValue(party!.name) ?? "unknown";
  }

  String get pointName {
    PointInTime? point = _pointInTimeRepository.get(pointId);
    return point != null ? point.name : "unknown";
  }
}
