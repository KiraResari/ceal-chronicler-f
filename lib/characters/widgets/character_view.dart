import '../../utils/widgets/temporal_entity_view.dart';
import '../model/character.dart';
import 'character_view_controller.dart';

class CharacterView
    extends TemporalEntityView<Character, CharacterViewController> {
  const CharacterView({super.key, required Character character})
      : super(entity: character);

  @override
  CharacterViewController createController() {
    return CharacterViewController(entity);
  }
}
