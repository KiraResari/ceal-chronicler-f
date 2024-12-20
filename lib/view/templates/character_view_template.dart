import '../../characters/model/character.dart';
import '../../characters/model/character_repository.dart';
import '../../characters/widgets/character_view.dart';
import '../../get_it_context.dart';
import '../../main_view/main_view_candidate.dart';
import 'main_view_template.dart';
import 'temporally_limited_template.dart';

class CharacterViewTemplate extends TemporallyLimitedTemplate<Character>
    implements MainViewTemplate {
  final _characterRepository = getIt<CharacterRepository>();

  CharacterViewTemplate(super.character);

  @override
  MainViewCandidate get associatedView => CharacterView(character: entity);

  @override
  bool get isValid => _characterRepository.contains(entity.id);

  @override
  String get identifier => "Character '$currentName'";
}
