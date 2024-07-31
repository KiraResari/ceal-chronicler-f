import '../../commands/command.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/character.dart';

class UpdateFirstAppearanceCommand extends Command {
  final PointInTimeId _newFirstAppearance;
  final Character _character;
  PointInTimeId? _oldFirstAppearance;

  UpdateFirstAppearanceCommand(this._character, this._newFirstAppearance);

  @override
  void execute() {
    _oldFirstAppearance = _character.firstAppearance;
    _character.firstAppearance = _newFirstAppearance;
  }

  @override
  String get executeMessage => "Updated first appearance of character";

  @override
  void undo() {
    if (_oldFirstAppearance != null) {
      _character.firstAppearance = _oldFirstAppearance!;
    }
  }

  @override
  String get undoMessage =>
      "Undid updating of first apperance of character";

}
