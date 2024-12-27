import '../../../get_it_context.dart';
import '../../../key_fields/key_field_resolver.dart';
import '../../../timeline/model/point_in_time_repository.dart';
import '../../../utils/widgets/buttons/dropdown_popup_button_controller.dart';
import '../../commands/create_location_connection_command.dart';
import '../../model/location.dart';
import '../../model/location_connection_direction.dart';
import '../../model/location_id.dart';
import '../../model/location_level.dart';
import '../../model/location_repository.dart';

class AddLocationConnectionButtonController
    extends DropdownPopupButtonController<LocationId> {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  final Location presentLocation;
  final LocationConnectionDirection direction;

  AddLocationConnectionButtonController(this.presentLocation, this.direction);

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
    var locationIsOfEquivalentLevel =
        location.locationLevel == LocationLevel.notSet ||
            location.locationLevel.isEquivalent(presentLocation.locationLevel);
    return locationIsActive && locationIsOfEquivalentLevel;
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
  CreateLocationConnectionCommand buildCommand(LocationId selection) =>
      CreateLocationConnectionCommand(
        presentLocation.id,
        direction,
        selection,
      );
}
