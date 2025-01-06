import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/character.dart';
import '../model/character_repository.dart';

class DeleteCharacterCommand extends Command {
  final characterRepository = getIt.get<CharacterRepository>();
  final pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final resolver = getIt.get<KeyFieldResolver>();
  final Character character;

  DeleteCharacterCommand(this.character);

  @override
  void execute() => characterRepository.remove(character);

  @override
  String get executeMessage => "Removed character '$name'";

  @override
  void undo() => characterRepository.add(character);

  @override
  String get undoMessage => "Restored deleted character '$name'";

  get name => resolver.getCurrentValue(character.name);
}
