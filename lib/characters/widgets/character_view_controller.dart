import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/commands/add_or_update_key_command.dart';
import '../../locations/model/location.dart';
import '../../locations/model/location_id.dart';
import '../../locations/model/location_repository.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  static final unknownLocationId = LocationId();
  static final DropdownMenuEntry<LocationId> unknownEntry =
      DropdownMenuEntry<LocationId>(value: unknownLocationId, label: "unknown");
  final _locationRepository = getIt.get<LocationRepository>();

  LocationId get presentLocation {
    return keyFieldResolver.getCurrentValue(entity.presentLocation) ??
        unknownLocationId;
  }

  List<DropdownMenuEntry<LocationId>> get validLocationEntries {
    List<Location> validLocations = _validLocations;

    List<DropdownMenuEntry<LocationId>> locationEntries = validLocations
        .map((location) => _mapLocationToDropdownMenuEntry(location))
        .toList();
    locationEntries.add(unknownEntry);
    return locationEntries;
  }

  List<Location> get _validLocations {
    return _locationRepository.content
        .where((location) =>
            !pointInTimeRepository.pointIsInTheFuture(location.firstAppearance))
        .toList();
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<LocationId>(value: location.id, label: name);
  }

  void updatePresentLocation(LocationId? locationId) {
    if (locationId != null) {
      var command = AddOrUpdateKeyCommand(
        entity.presentLocation,
        pointInTimeRepository.activePointInTime.id,
        locationId == unknownLocationId ? null : locationId,
      );
      commandProcessor.process(command);
    }
  }
}
