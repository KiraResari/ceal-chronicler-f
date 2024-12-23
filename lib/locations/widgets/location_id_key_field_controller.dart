import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/widgets/key_field_controller.dart';
import '../model/location.dart';
import '../model/location_id.dart';
import '../model/location_repository.dart';

class LocationIdKeyFieldController extends KeyFieldController<LocationId?> {
  LocationIdKeyFieldController(super.keyField);

  static final unknownLocationId = LocationId();
  static final DropdownMenuEntry<LocationId> unknownEntry =
      DropdownMenuEntry<LocationId>(value: unknownLocationId, label: "unknown");
  final _locationRepository = getIt.get<LocationRepository>();

  Location? get presentLocation {
    if (currentValue != null) {
      return _locationRepository.getContentElementById(currentValue!);
    }
    return null;
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
            pointInTimeRepository.entityIsPresentlyActive(location))
        .toList();
  }

  bool get presentLocationIsActive {
    if (presentLocation != null) {
      return pointInTimeRepository.entityIsPresentlyActive(presentLocation!);
    }
    return false;
  }

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    return DropdownMenuEntry<LocationId>(value: location.id, label: name);
  }

  void updatePresentLocation(LocationId? locationId) {
    if (locationId != null) {
      if (locationId == unknownLocationId) {
        updateKey(null);
      } else {
        updateKey(locationId);
      }
    }
  }
}
