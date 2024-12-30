import '../../get_it_context.dart';
import '../../main_view/main_view_candidate.dart';
import '../../parties/model/party.dart';
import '../../parties/model/party_id.dart';
import '../../parties/model/party_repository.dart';
import '../../parties/widgets/party_view.dart';
import 'temporally_limited_template.dart';

class PartyViewTemplate extends TemporallyLimitedTemplate<Party, PartyId> {
  PartyViewTemplate(Party party) : super(party, getIt<PartyRepository>());

  @override
  MainViewCandidate get associatedView => PartyView(party: entity);

  @override
  String get identifier => "Party '$currentName'";
}
