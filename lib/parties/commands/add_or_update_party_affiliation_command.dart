import '../../characters/model/character.dart';
import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/party.dart';
import '../model/party_id.dart';

class AddOrUpdatePartyAffiliationCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeId pointId;
  final Character character;
  final Party party;
  PartyId? previousPartyId;
  bool previousKeyExisted = false;

  AddOrUpdatePartyAffiliationCommand(this.character, this.party, this.pointId);

  @override
  void execute() {
    if(character.party.keys.containsKey(pointId)){
      previousPartyId = _keyFieldResolver.getValueAt(character.party, pointId);
      previousKeyExisted = true;
    }
    character.party.addOrUpdateKeyAtTime(party.id, pointId);
  }

  @override
  String get executeMessage =>
      "Added character '$characterName' to party '$partyName' at '$pointName'";

  @override
  void undo() {
    if (previousKeyExisted) {
      character.party.addOrUpdateKeyAtTime(party.id, pointId);
    } else {
      character.party.deleteKeyAtTime(pointId);
    }
  }

  @override
  String get undoMessage =>
      "Undid adding of character '$characterName' to party '$partyName' at '$pointName'";

  String get characterName =>
      _keyFieldResolver.getCurrentValue(character.name) ?? "unknown";

  String get partyName =>
      _keyFieldResolver.getCurrentValue(party.name) ?? "unknown";

  String get pointName {
    PointInTime? point = _pointInTimeRepository.get(pointId);
    return point != null ? point.name : "unknown";
  }
}
