import '../../commands/command.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../model/temporal_entity.dart';

class UpdateLastAppearanceCommand extends Command {
  final PointInTimeId _newLastAppearance;
  final TemporalEntity _character;
  PointInTimeId? _oldLastAppearance;

  UpdateLastAppearanceCommand(this._character, this._newLastAppearance);

  @override
  void execute() {
    _oldLastAppearance = _character.lastAppearance;
    _character.lastAppearance = _newLastAppearance;
  }

  @override
  String get executeMessage => "Updated last appearance";

  @override
  void undo() {
    _character.lastAppearance = _oldLastAppearance;
  }

  @override
  String get undoMessage => "Undid updating of last appearance";
}
