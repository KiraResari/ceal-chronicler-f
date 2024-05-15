import '../../characters/model/character_id.dart';
import '../../characters/model/character_repository.dart';
import '../../characters/widgets/character_view.dart';
import '../../get_it_context.dart';
import '../../main_view/main_view_candidate.dart';
import 'main_view_template.dart';

class CharacterViewTemplate extends MainViewTemplate {
  final CharacterRepository characterRepository = getIt<CharacterRepository>();

  final CharacterId id;

  CharacterViewTemplate(this.id);

  @override
  MainViewCandidate get associatedView => CharacterView(id: id);

  @override
  bool get isValid => characterRepository.contains(id);
}
