import '../../../characters/model/character.dart';
import '../../../characters/model/character_repository.dart';
import '../../../get_it_context.dart';
import '../../../utils/widgets/temporal_entity_view_controller.dart';
import '../../commands/delete_parent_location_command.dart';
import '../../model/location.dart';
import '../../model/location_connection.dart';
import '../../model/location_connection_direction.dart';
import '../../model/location_connection_repository.dart';
import '../../model/location_id.dart';
import '../../model/location_level.dart';
import '../../model/location_repository.dart';
import '../panels/connected_location_panel_template.dart';

class LocationViewController extends TemporalEntityViewController<Location> {
  LocationViewController(Location location) : super(location);

  final _characterRepository = getIt.get<CharacterRepository>();
  final _locationRepository = getIt.get<LocationRepository>();
  final _locationConnectionRepository =
      getIt.get<LocationConnectionRepository>();

  List<Character> get charactersPresentAtLocation {
    return _characterRepository.content
        .where((character) => _characterIsPresent(character))
        .toList();
  }

  Location? get parentLocation {
    LocationId? parentLocationId = entity.parentLocation;
    if (parentLocationId == null) {
      return null;
    }
    return _locationRepository.getContentElementById(parentLocationId);
  }

  bool _characterIsPresent(Character character) {
    LocationId? currentLocationId =
        keyFieldResolver.getCurrentValue(character.presentLocation);
    bool characterIsAtLocation = currentLocationId == entity.id;
    bool characterIsActive =
        pointInTimeRepository.entityIsPresentlyActive(character);
    return characterIsAtLocation && characterIsActive;
  }

  List<Location> get childLocations {
    List<Location> allLocations = _locationRepository.content;
    return allLocations
        .where((location) => _locationIsChildAndActive(location))
        .toList();
  }

  bool _locationIsChildAndActive(Location location) {
    bool locationIsChild = location.parentLocation == entity.id;
    bool locationIsActive =
        pointInTimeRepository.entityIsPresentlyActive(location);
    return locationIsChild && locationIsActive;
  }

  LocationLevel get locationLevel => entity.locationLevel;

  void deleteParentLocation() {
    var command = DeleteParentLocationCommand(entity);
    commandProcessor.process(command);
  }

  List<ConnectedLocationPanelTemplate> getConnectedLocationsForDirection(
    LocationConnectionDirection direction,
  ) {
    List<LocationConnection> allConnectionsForDirection =
        _locationConnectionRepository.content
            .where((connection) => connection.direction == direction)
            .toList();
    List<LocationConnection> allConnectionsForOppositeDirection =
    _locationConnectionRepository.content
        .where((connection) => connection.direction == direction.opposite)
        .toList();
    return [
      ..._getTemplatesWhereThisIsStart(allConnectionsForDirection),
      ..._getTemplatesWhereThisIsEnd(allConnectionsForOppositeDirection),
    ];
  }

  List<ConnectedLocationPanelTemplate> _getTemplatesWhereThisIsStart(
    List<LocationConnection> allConnections,
  ) {
    List<LocationConnection> connectionsWhereThisIsStart = allConnections
        .where((connection) => connection.startLocation == entity.id)
        .toList();
    return connectionsWhereThisIsStart
        .map((connection) => _buildConnectedLocationPanelTemplate(
            connection.endLocation, connection))
        .whereType<ConnectedLocationPanelTemplate>()
        .toList();
  }

  List<ConnectedLocationPanelTemplate> _getTemplatesWhereThisIsEnd(
    List<LocationConnection> allConnections,
  ) {
    List<LocationConnection> connectionsWhereThisIsEnd = allConnections
        .where((connection) => connection.endLocation == entity.id)
        .toList();
    return connectionsWhereThisIsEnd
        .map((connection) => _buildConnectedLocationPanelTemplate(
            connection.startLocation, connection))
        .whereType<ConnectedLocationPanelTemplate>()
        .toList();
  }

  ConnectedLocationPanelTemplate? _buildConnectedLocationPanelTemplate(
    LocationId locationId,
    LocationConnection connection,
  ) {
    Location? location = _locationRepository.getContentElementById(locationId);
    return location != null
        ? ConnectedLocationPanelTemplate(location, connection)
        : null;
  }
}
