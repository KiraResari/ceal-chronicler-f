import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/character.dart';
import '../model/character_repository.dart';

class CreateCharacterCommand extends Command {
  final _repository = getIt.get<CharacterRepository>();
  final PointInTimeId _pointId;
  Character? _createdCharacter;

  CreateCharacterCommand(this._pointId);

  @override
  void execute() {
    _createdCharacter ??= Character(_pointId);
    _repository.add(_createdCharacter!);
  }

  @override
  String get executeMessage =>
      "Created new Character $_characterNameOrNothing";

  @override
  void undo() {
    if (_createdCharacter != null) {
      _repository.remove(_createdCharacter!);
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of Incident $_characterNameOrNothing";

  String get _characterNameOrNothing {
    if (_createdCharacter != null) {
      return "'${_createdCharacter!.name}'";
    }
    return "";
  }
}
