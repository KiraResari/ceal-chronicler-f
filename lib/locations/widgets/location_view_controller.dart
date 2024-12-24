import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';

import '../../characters/model/character.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/location.dart';
import '../model/location_id.dart';

class LocationViewController extends TemporalEntityViewController<Location> {
  LocationViewController(Location location) : super(location);

  final _characterRepository = getIt.get<CharacterRepository>();

  List<Character> get charactersPresentAtLocation {
    return _characterRepository.content
        .where((character) => _characterIsPresent(character))
        .toList();
  }

  bool _characterIsPresent(Character character) {
    LocationId? currentLocationId =
        keyFieldResolver.getCurrentValue(character.presentLocation);
    bool characterIsAtLocation = currentLocationId == entity.id;
    bool characterIsActive =
        pointInTimeRepository.entityIsPresentlyActive(character);
    return characterIsAtLocation && characterIsActive;
  }
}
