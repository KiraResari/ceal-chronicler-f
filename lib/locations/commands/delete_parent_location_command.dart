import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class DeleteParentLocationCommand extends Command {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final Location _locationBeingEdited;
  LocationId? _oldParentLocationId;

  DeleteParentLocationCommand(this._locationBeingEdited);

  @override
  void execute() {
    _oldParentLocationId = _locationBeingEdited.parentLocation;
    _locationBeingEdited.parentLocation = null;
  }

  @override
  String get executeMessage =>
      "Deleted parent of location $_locationNameOrNothing (was: ${_getLocationIdNameOrUnknown(_oldParentLocationId)})";

  @override
  void undo() {
    _locationBeingEdited.parentLocation = _oldParentLocationId;
  }

  @override
  String get undoMessage =>
      "Restored parent of location $_locationNameOrNothing to ${_getLocationIdNameOrUnknown(_oldParentLocationId)}";

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
