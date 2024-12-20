import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/commands/add_or_update_key_command.dart';
import 'package:ceal_chronicler_f/key_fields/commands/delete_key_command.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';

import '../../commands/command.dart';
import '../../utils/widgets/temporal_entity_view_controller.dart';
import '../model/character.dart';

class CharacterViewController extends TemporalEntityViewController<Character> {
  CharacterViewController(Character character) : super(character);

  static final unknownLocationId = LocationId();
  static final DropdownMenuEntry<LocationId> unknownEntry =
      DropdownMenuEntry<LocationId>(
          value: unknownLocationId, label: "unknown");
  final _locationRepository = getIt.get<LocationRepository>();

  LocationId get presentLocation {
    return keyFieldResolver.getCurrentValue(entity.presentLocation) ??
        unknownLocationId;
  }

  List<DropdownMenuEntry<LocationId>> get validLocationEntries {
    List<Location> allLocations = _locationRepository.content;
    List<DropdownMenuEntry<LocationId>> locationEntries = allLocations
        .map((location) => _mapLocationToDropdownMenuEntry(location))
        .toList();
    locationEntries.add(unknownEntry);
    return locationEntries;
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<LocationId>(value: location.id, label: name);
  }

  void updatePresentLocation(LocationId? locationId) {
    if (locationId != null) {
      Command command = _buildUpdatePresentLocationCommand(locationId);
      commandProcessor.process(command);
    }
  }

  Command _buildUpdatePresentLocationCommand(LocationId locationId) {
    if (locationId == unknownLocationId) {
      return DeleteKeyCommand(
          entity.presentLocation, pointInTimeRepository.activePointInTime.id);
    }
    return AddOrUpdateKeyCommand(
      entity.presentLocation,
      pointInTimeRepository.activePointInTime.id,
      locationId,
    );
  }
}
