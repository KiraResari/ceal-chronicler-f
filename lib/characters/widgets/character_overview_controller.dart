import '../../get_it_context.dart';
import '../../utils/widgets/temporal_overview_controller.dart';
import '../model/character.dart';
import '../model/character_id.dart';
import '../model/character_repository.dart';

class CharacterOverviewController
    extends TemporalOverviewController<Character, CharacterId> {
  CharacterOverviewController() : super(getIt.get<CharacterRepository>());
}
