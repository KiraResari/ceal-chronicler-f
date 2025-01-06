import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/party.dart';
import '../model/party_repository.dart';

class DeletePartyCommand extends Command {
  final partyRepository = getIt.get<PartyRepository>();
  final pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final resolver = getIt.get<KeyFieldResolver>();
  final Party party;

  DeletePartyCommand(this.party);

  @override
  void execute() => partyRepository.remove(party);

  @override
  String get executeMessage => "Removed party '$name'";

  @override
  void undo() => partyRepository.add(party);

  @override
  String get undoMessage => "Restored deleted party '$name'";

  get name => resolver.getCurrentValue(party.name);
}
