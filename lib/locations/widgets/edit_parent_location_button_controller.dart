import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../../utils/widgets/buttons/edit_button_controller.dart';
import '../commands/update_parent_location_command.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_level.dart';
import '../model/location_repository.dart';

class EditParentLocationButtonController
    extends EditButtonController<LocationId> {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  final Location presentLocation;

  EditParentLocationButtonController(this.presentLocation);

  @override
  List<LocationId> get validEntries {
    List<Location> allLocations = _locationRepository.content;
    List<Location> validLocations =
        allLocations.where((location) => _isValid(location)).toList();
    return validLocations.map((location) => location.id).toList();
  }

  bool _isValid(Location location) {
    var locationIsActive =
        _pointInTimeRepository.entityIsPresentlyActive(location);
    var locationIsOfHigherLevel =
        location.locationLevel == LocationLevel.notSet ||
            location.locationLevel.isAbove(presentLocation.locationLevel);
    return locationIsActive && locationIsOfHigherLevel;
  }

  @override
  String getLabel(LocationId entry) {
    Location? location = _locationRepository.getContentElementById(entry);
    if (location == null) {
      return "unknown";
    }
    String name = _keyFieldResolver.getCurrentValue(location.name) ?? "unknown";
    String icon = location.locationLevel.icon;
    return icon + name;
  }

  @override
  UpdateParentLocationCommand buildCommand(LocationId newValue) =>
      UpdateParentLocationCommand(presentLocation, newValue);
}
