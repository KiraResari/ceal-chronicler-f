import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_connection.dart';
import '../model/location_connection_repository.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class DeleteLocationConnectionCommand extends Command {
  final _locationConnectionRepository =
      getIt.get<LocationConnectionRepository>();
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  final LocationConnection locationConnection;

  DeleteLocationConnectionCommand(this.locationConnection);

  @override
  void execute() => _locationConnectionRepository.remove(locationConnection);

  @override
  String get executeMessage =>
      "Deleted connection between '${_getLocationNameOrUnknown(locationConnection.startLocation)}' and '${_getLocationNameOrUnknown(locationConnection.startLocation)}'";

  @override
  void undo() => _locationConnectionRepository.add(locationConnection);

  @override
  String get undoMessage =>
      "Undid deletion of connection between '${_getLocationNameOrUnknown(locationConnection.startLocation)}' and '${_getLocationNameOrUnknown(locationConnection.startLocation)}'";

  String _getLocationNameOrUnknown(LocationId locationId) {
    Location? location = _locationRepository.getContentElementById(locationId);
    if (location != null) {
      String? name = _keyFieldResolver.getCurrentValue(location.name);
      return name ?? "unknown";
    }
    return "unknown";
  }
}
