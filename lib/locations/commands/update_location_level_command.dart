import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_level.dart';

class UpdateLocationLevelCommand extends Command {
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final Location _locationBeingEdited;
  final LocationLevel _newLocationLevel;
  LocationLevel? _oldLocationLevel;

  UpdateLocationLevelCommand(this._locationBeingEdited, this._newLocationLevel);

  @override
  void execute() {
    _oldLocationLevel = _locationBeingEdited.locationLevel;
    _locationBeingEdited.locationLevel = _newLocationLevel;
  }

  @override
  String get executeMessage =>
      "Changed location level of '$_locationNameOrNothing' from '${_oldLocationLevel!.name}' to '${_newLocationLevel.name}'";

  @override
  void undo() {
    if (_oldLocationLevel != null) {
      _locationBeingEdited.locationLevel = _oldLocationLevel!;
    }
  }

  @override
  String get undoMessage =>
      "Undid change of parent of location '$_locationNameOrNothing' from '${_oldLocationLevel!.name}' to '${_newLocationLevel.name}'";

  String get _locationNameOrNothing {
    String? name = _keyFieldResolver.getCurrentValue(_locationBeingEdited.name);
    return name != null ? "'$name'" : "";
  }
}
