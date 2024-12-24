import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class UpdateParentLocationCommand extends Command {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final Location _locationBeingEdited;
  final LocationId? _newParentLocationId;
  LocationId? _oldParentLocationId;

  UpdateParentLocationCommand(
      this._locationBeingEdited, this._newParentLocationId);

  @override
  void execute() {
    _oldParentLocationId = _locationBeingEdited.parentLocation;
    _locationBeingEdited.parentLocation = _newParentLocationId;
  }

  @override
  String get executeMessage =>
      "Changed parent of location '$_locationNameOrNothing' from '${_getLocationIdNameOrUnknown(_oldParentLocationId)}' to '${_getLocationIdNameOrUnknown(_newParentLocationId)}'";

  @override
  void undo() {
    _locationBeingEdited.parentLocation = _oldParentLocationId;
  }

  @override
  String get undoMessage =>
      "Undid change of parent of location '$_locationNameOrNothing' from '$_getLocationIdNameOrUnknown($_oldParentLocationId)' to '$_getLocationIdNameOrUnknown($_newParentLocationId)'";

  String get _locationNameOrNothing {
    String? name = _keyFieldResolver.getCurrentValue(_locationBeingEdited.name);
    return name != null ? "'$name'" : "";
  }

  String _getLocationIdNameOrUnknown(LocationId? locationId) {
    if (locationId == null) {
      return "unknown";
    }
    Location? location = _locationRepository.getContentElementById(locationId);
    if (location == null) {
      return "unknown";
    }
    String? name = _keyFieldResolver.getCurrentValue(location.name);
    return name != null ? "'$name'" : "unknown";
  }
}
