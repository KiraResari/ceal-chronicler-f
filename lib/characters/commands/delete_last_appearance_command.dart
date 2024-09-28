import '../../commands/command.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/character.dart';

class DeleteLastAppearanceCommand extends Command {
  final Character _character;
  PointInTimeId? _oldLastAppearance;

  DeleteLastAppearanceCommand(this._character);

  @override
  void execute() {
    _oldLastAppearance = _character.lastAppearance;
    _character.lastAppearance = null;
  }

  @override
  String get executeMessage => "Removed last appearance of character";

  @override
  void undo() {
    _character.lastAppearance = _oldLastAppearance;
  }

  @override
  String get undoMessage => "Undid removal of last appearance of character";
}
