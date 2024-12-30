import '../../characters/model/character.dart';
import '../../characters/model/character_id.dart';
import '../../characters/model/character_repository.dart';
import '../../characters/widgets/character_view.dart';
import '../../get_it_context.dart';
import '../../main_view/main_view_candidate.dart';
import 'temporally_limited_template.dart';

class CharacterViewTemplate
    extends TemporallyLimitedTemplate<Character, CharacterId>
     {

  CharacterViewTemplate(Character character)
      : super(character, getIt<CharacterRepository>());

  @override
  MainViewCandidate get associatedView => CharacterView(character: entity);

  @override
  String get identifier => "Character '$currentName'";
}
