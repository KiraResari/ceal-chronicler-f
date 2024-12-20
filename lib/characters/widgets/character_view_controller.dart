import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';

import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  static final _unknownLocationId = LocationId();
  static final DropdownMenuEntry<LocationId> _unknownEntry =
      DropdownMenuEntry<LocationId>(
          value: _unknownLocationId, label: "unknown");
  final _locationRepository = getIt.get<LocationRepository>();

  LocationId get presentLocation {
    return keyFieldResolver.getCurrentValue(entity.presentLocation) ??
        _unknownLocationId;
  }

  List<DropdownMenuEntry<LocationId>> get getValidLocationEntries {
    List<Location> allLocations = _locationRepository.content;
    List<DropdownMenuEntry<LocationId>> locationEntries = allLocations
        .map((location) => _mapLocationToDropdownMenuEntry(location))
        .toList();
    locationEntries.add(_unknownEntry);
    return locationEntries;
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<LocationId>(value: location.id, label: name);
  }

  void updatePresentLocation(LocationId? locationId) {
    if (locationId != null && locationId != _unknownLocationId) {
      //TODO: Fire update location command here
    }
  }
}
