import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class EditParentLocationButtonController {
  final _locationRepository = getIt.get<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  List<DropdownMenuEntry<LocationId>> get validLocations {
    List<Location> allLocations = _locationRepository.content;
    return allLocations
        .map((location) => _mapLocationToDropdownMenuEntry(location))
        .toList();
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = _keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<LocationId>(value: location.id, label: name);
  }

  void updateParentLocation(LocationId? locationId) {
    //TODO: fire UpdateParentLocationCommand here
  }
}
