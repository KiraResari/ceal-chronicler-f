import '../../get_it_context.dart';
import '../../utils/widgets/buttons/edit_button_controller.dart';
import '../commands/update_location_level_command.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_level.dart';
import '../model/location_repository.dart';

class EditLocationLevelButtonController
    extends EditButtonController<LocationLevel> {
  final _locationRepository = getIt.get<LocationRepository>();

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
