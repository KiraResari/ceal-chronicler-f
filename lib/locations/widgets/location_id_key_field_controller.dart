import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
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

  LocationId get presentLocation {
    return currentValue ?? unknownLocationId;
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
        .where((location) => _isValidLocation(location))
        .toList();
  }

  bool _isValidLocation(Location location) {
    bool firstAppearanceHasHappened =
        !pointInTimeRepository.pointIsInTheFuture(location.firstAppearance);
    PointInTimeId? lastAppearance = location.lastAppearance;
    bool lastAppearanceHasntHappened = lastAppearance == null
        ? true
        : !pointInTimeRepository.pointIsInThePast(lastAppearance);
    return firstAppearanceHasHappened && lastAppearanceHasntHappened;
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
