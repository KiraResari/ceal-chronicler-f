import '../../get_it_context.dart';
import '../../utils/widgets/temporal_overview_controller.dart';
import '../model/party.dart';
import '../model/party_id.dart';
import '../model/party_repository.dart';


class PartyOverviewController
    extends TemporalOverviewController<Party, PartyId> {
  PartyOverviewController() : super(getIt.get<PartyRepository>());
}
