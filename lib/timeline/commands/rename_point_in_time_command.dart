import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../point_in_time.dart';
import '../point_in_time_repository.dart';

class RenamePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final PointInTime _point;
  final String _newName;
  String? _oldName;

  RenamePointInTimeCommand(this._point, this._newName);

  @override
  void execute() {
    _oldName = _point.name;
    _pointInTimeRepository.rename(_point, _newName);
  }

  @override
  void undo() {
    if (_oldName != null) {
      _pointInTimeRepository.rename(_point, _oldName!);
    }
  }

  @override
  String get executeMessage =>
      "Renamed Point in Time from '$_oldNameOrUnknown' to $_newName";

  @override
  String get undoMessage =>
      "Renamed Point in Time back from '$_newName' to $_oldNameOrUnknown";

  String get _oldNameOrUnknown {
    if (_oldName != null) {
      return _oldName!;
    }
    return "Unknown";
  }
}
