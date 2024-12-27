import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_connection.dart';
import '../model/location_connection_direction.dart';
import '../model/location_connection_repository.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class CreateLocationConnectionCommand extends Command {
  final _locationConnectionRepository =
      getIt.get<LocationConnectionRepository>();
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  final LocationId startLocation;
  final LocationConnectionDirection direction;
  final LocationId endLocation;
  LocationConnection? _createdLocationConnection;

  CreateLocationConnectionCommand(
      this.startLocation, this.direction, this.endLocation);

  @override
  void execute() {
    _createdLocationConnection ??=
        LocationConnection(startLocation, direction, endLocation);
    _locationConnectionRepository.add(_createdLocationConnection!);
  }

  @override
  String get executeMessage =>
      "Created connection between '${_getLocationNameOrUnknown(startLocation)}' and '${_getLocationNameOrUnknown(startLocation)}'";

  @override
  void undo() {
    if (_createdLocationConnection != null) {
      _locationConnectionRepository.remove(_createdLocationConnection!);
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of connection between '${_getLocationNameOrUnknown(startLocation)}' and '${_getLocationNameOrUnknown(startLocation)}'";

  String _getLocationNameOrUnknown(LocationId locationId) {
    Location? location = _locationRepository.getContentElementById(locationId);
    if (location != null) {
      String? name = _keyFieldResolver.getCurrentValue(location.name);
      return name ?? "unknown";
    }
    return "unknown";
  }
}
