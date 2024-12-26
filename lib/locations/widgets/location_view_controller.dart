import 'package:ceal_chronicler_f/locations/model/location_level.dart';

import '../../characters/model/character.dart';
import '../../characters/model/character_repository.dart';
import '../../get_it_context.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class LocationViewController extends TemporalEntityViewController<Location> {
  LocationViewController(Location location) : super(location);

  final _characterRepository = getIt.get<CharacterRepository>();
  final _locationRepository = getIt.get<LocationRepository>();

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
}
