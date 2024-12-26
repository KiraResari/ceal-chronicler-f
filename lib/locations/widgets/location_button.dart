import '../../utils/widgets/temporal_entity_button.dart';
import '../../view/commands/open_location_view_command.dart';
import '../model/location.dart';

class LocationButton extends TemporalEntityButton<Location> {
  LocationButton(Location location, {super.key}) : super(location);

  @override
  OpenLocationViewCommand createOpenViewCommand(Location entity) {
    return OpenLocationViewCommand(entity);
  }

  @override
  String get text {
    var locationIcon = entity.locationLevel.icon;
    var locationName = (keyFieldResolver.getCurrentValue(entity.name) ?? "");
    return locationIcon + locationName;
  }

  @override
  String get entityTypeName => "Location";
}
