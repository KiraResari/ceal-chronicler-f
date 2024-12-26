import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../model/location.dart';
import '../model/location_level.dart';

class EditLocationLevelButtonController {
  final _commandProcessor = getIt.get<CommandProcessor>();

  List<DropdownMenuEntry<LocationLevel>> get validEntries {
    List<LocationLevel> allLocationLevels = LocationLevel.values;
    return allLocationLevels
        .map((level) => _mapToDropdownMenuEntry(level))
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
    Location locationBeingEdited,
      LocationLevel? newLocationLevel
  ) {
    //TODO: Add command here
  }
}
