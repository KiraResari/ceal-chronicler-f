import '../../characters/model/character.dart';
import '../../characters/model/character_repository.dart';
import '../../characters/widgets/character_view.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../main_view/main_view_candidate.dart';
import '../../timeline/model/point_in_time_id.dart';
import 'main_view_template.dart';
import 'temporally_limited_template.dart';

class CharacterViewTemplate extends TemporallyLimitedTemplate
    implements MainViewTemplate {
  final _characterRepository = getIt<CharacterRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  final Character character;

  CharacterViewTemplate(this.character);

  @override
  MainViewCandidate get associatedView => CharacterView(character: character);

  @override
  bool get isValid => _characterRepository.contains(character.id);

  @override
  PointInTimeId? get firstAppearance => character.firstAppearance;

  @override
  PointInTimeId? get lastAppearance => null;

  @override
  String get identifier{
    String name = _keyFieldResolver.getCurrentValue(character.name);
    return "Character '$name'";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterViewTemplate &&
          runtimeType == other.runtimeType &&
          character == other.character;

  @override
  int get hashCode => character.hashCode;
}
