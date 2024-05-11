import 'main_view_template.dart';
import '../../characters/widgets/character_view.dart';
import '../../characters/model/character_id.dart';
import '../../main_view/main_view_candidate.dart';

class CharacterViewTemplate extends MainViewTemplate {
  final CharacterId id;

  CharacterViewTemplate(this.id);

  @override
  MainViewCandidate get associatedView => CharacterView(id: id);
}
