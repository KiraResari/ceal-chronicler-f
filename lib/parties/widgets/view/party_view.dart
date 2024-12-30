import '../../../utils/string_key.dart';
import '../../../utils/widgets/temporal_entity_view.dart';
import '../../model/party.dart';
import 'party_view_controller.dart';

class PartyView
    extends TemporalEntityView<Party, PartyViewController> {
  PartyView({required Party party})
      : super(entity: party, key: StringKey(party.toString()));

  @override
  PartyViewController createController() {
    return PartyViewController(entity);
  }
}
