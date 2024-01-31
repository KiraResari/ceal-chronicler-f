import 'package:ceal_chronicler_f/commands/command.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';

class RenameIncidentCommand extends Command {
  final Incident _incident;
  final String _newName;
  String? _oldName;

  RenameIncidentCommand(this._incident, this._newName);

  @override
  void execute() {
    _oldName = _incident.name;
    _incident.name = _newName;
  }

  @override
  String get executeMessage =>
      "Renamed Incident from '$_oldNameOrUnknown' to $_newName";

  @override
  void undo() {
    if (_oldName != null) {
      _incident.name = _oldName!;
    }
  }

  @override
  String get undoMessage =>
      "Renamed Incident back from '$_newName' to $_oldNameOrUnknown";

  String get _oldNameOrUnknown {
    if (_oldName != null) {
      return _oldName!;
    }
    return "Unknown";
  }
}
