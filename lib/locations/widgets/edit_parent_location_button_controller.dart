import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../commands/update_parent_location_command.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class EditParentLocationButtonController {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final _commandProcessor = getIt.get<CommandProcessor>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  List<DropdownMenuEntry<LocationId>> get validLocations {
    List<Location> allLocations = _locationRepository.content;
    List<Location> validLocations = allLocations
        .where((location) =>
            _pointInTimeRepository.entityIsPresentlyActive(location))
        .toList();
    return validLocations
        .map((location) => _mapLocationToDropdownMenuEntry(location))
        .toList();
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = _keyFieldResolver.getCurrentValue(location.name) ?? "";
    String icon = location.locationLevel.icon;
    return DropdownMenuEntry<LocationId>(
      value: location.id,
      label: icon + name,
    );
  }

  void updateParentLocation(
    Location locationBeingEdited,
    LocationId? newParentLocationId,
  ) {
    if (newParentLocationId != null) {
      _commandProcessor.process(UpdateParentLocationCommand(
          locationBeingEdited, newParentLocationId));
    }
  }
}
