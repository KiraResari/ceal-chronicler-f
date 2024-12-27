import 'package:ceal_chronicler_f/locations/model/location_connection.dart';

import '../../../get_it_context.dart';
import '../../../utils/widgets/buttons/dropdown_popup_button_controller.dart';
import '../../commands/update_location_level_command.dart';
import '../../model/location.dart';
import '../../model/location_connection_repository.dart';
import '../../model/location_id.dart';
import '../../model/location_level.dart';
import '../../model/location_repository.dart';

class EditLocationLevelButtonController
    extends DropdownPopupButtonController<LocationLevel> {
  final _locationRepository = getIt.get<LocationRepository>();
  final _locationConnectionRepository =
      getIt.get<LocationConnectionRepository>();

  final Location presentLocation;

  EditLocationLevelButtonController(this.presentLocation);

  @override
  List<LocationLevel> get validEntries {
    List<LocationLevel> allLocationLevels = LocationLevel.values;
    return allLocationLevels
        .where((locationLevel) => _isValid(locationLevel))
        .toList();
  }

  bool _isValid(LocationLevel locationLevel) {
    for (Location childLocation in _childLocations) {
      if (!childLocation.locationLevel.isBelow(locationLevel)) {
        return false;
      }
    }
    for (Location connectedLocation in _connectedLocations) {
      if (!connectedLocation.locationLevel.isEquivalent(locationLevel)) {
        return false;
      }
    }
    LocationLevel? parentLocationLevel = _parentLocationLevel;
    if (parentLocationLevel == null) {
      return true;
    }
    return locationLevel.isBelow(parentLocationLevel);
  }

  List<Location> get _childLocations {
    List<Location> allLocations = _locationRepository.content;
    return allLocations
        .where((location) => location.parentLocation == presentLocation.id)
        .toList();
  }

  List<Location> get _connectedLocations {
    List<LocationConnection> allLocationConnections =
        _locationConnectionRepository.content;
    List<LocationConnection> connectionsWhereThisIsStart =
        allLocationConnections
            .where(
                (connection) => connection.startLocation == presentLocation.id)
            .toList();
    List<LocationId> connectedLocationIds = connectionsWhereThisIsStart
        .map((connection) => connection.endLocation)
        .toList();
    List<LocationConnection> connectionsWhereThisIsEnd = allLocationConnections
        .where((connection) => connection.endLocation == presentLocation.id)
        .toList();
    connectedLocationIds.addAll(connectionsWhereThisIsEnd
        .map((connection) => connection.startLocation)
        .toList());
    return connectedLocationIds
        .map((id) => _locationRepository.getContentElementById(id))
        .whereType<Location>()
        .toList();
  }

  LocationLevel? get _parentLocationLevel {
    LocationId? parentLocationId = presentLocation.parentLocation;
    if (parentLocationId == null) {
      return null;
    }
    Location? parentLocation =
        _locationRepository.getContentElementById(parentLocationId);
    return parentLocation?.locationLevel;
  }

  @override
  String getLabel(LocationLevel entry) => entry.iconAndName;

  @override
  UpdateLocationLevelCommand buildCommand(LocationLevel newValue) =>
      UpdateLocationLevelCommand(presentLocation, newValue);
}
