import 'package:ceal_chronicler_f/locations/commands/update_location_level_command.dart';
import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../model/location.dart';
import '../model/location_level.dart';
import '../model/location_repository.dart';

class EditLocationLevelButtonController {
  final _commandProcessor = getIt.get<CommandProcessor>();
  final _locationRepository = getIt.get<LocationRepository>();

  final Location presentLocation;

  EditLocationLevelButtonController(this.presentLocation);

  List<DropdownMenuEntry<LocationLevel>> get validEntries {
    List<LocationLevel> allLocationLevels = LocationLevel.values;
    List<LocationLevel> validLocationLevels = allLocationLevels
        .where((locationLevel) => _isValid(locationLevel))
        .toList();
    return validLocationLevels
        .map((level) => _mapToDropdownMenuEntry(level))
        .toList();
  }

  bool _isValid(LocationLevel locationLevel) {
    for (Location childLocation in _childLocations) {
      if (!childLocation.locationLevel.isBelow(locationLevel)) {
        return false;
      }
    }
    return true;
  }

  List<Location> get _childLocations {
    List<Location> allLocations = _locationRepository.content;
    return allLocations
        .where((location) => location.parentLocation == presentLocation.id)
        .toList();
  }

  DropdownMenuEntry<LocationLevel> _mapToDropdownMenuEntry(
    LocationLevel level,
  ) {
    return DropdownMenuEntry<LocationLevel>(
      value: level,
      label: level.iconAndName,
    );
  }

  void updateLocationLevel(
      Location locationBeingEdited, LocationLevel? newLocationLevel) {
    if (newLocationLevel != null) {
      _commandProcessor.process(
          UpdateLocationLevelCommand(locationBeingEdited, newLocationLevel));
    }
  }
}
