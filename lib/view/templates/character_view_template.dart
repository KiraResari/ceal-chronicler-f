import '../../characters/model/character.dart';
import '../../characters/model/character_repository.dart';
import '../../characters/widgets/character_view.dart';
import '../../get_it_context.dart';
import '../../main_view/main_view_candidate.dart';
import 'main_view_template.dart';

class CharacterViewTemplate extends MainViewTemplate {
  final CharacterRepository characterRepository = getIt<CharacterRepository>();

  final Character character;

  CharacterViewTemplate(this.character);

  @override
  MainViewCandidate get associatedView => CharacterView(character: character);

  @override
  bool get isValid => characterRepository.contains(character.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterViewTemplate &&
          runtimeType == other.runtimeType &&
          character == other.character;

  @override
  int get hashCode => character.hashCode;
}
