import '../../../utils/widgets/temporal_entity_button.dart';
import '../../../view/commands/open_party_view_command.dart';
import '../../model/party.dart';

class PartyButton extends TemporalEntityButton<Party> {
  PartyButton(Party party, {super.key}) : super(party);

  @override
  OpenPartyViewCommand createOpenViewCommand(Party entity) {
    return OpenPartyViewCommand(entity);
  }

  @override
  String get entityTypeName => "Party";
}
