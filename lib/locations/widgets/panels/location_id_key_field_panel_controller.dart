import 'package:flutter/material.dart';

import '../../../get_it_context.dart';
import '../../../key_fields/widgets/key_field_controller.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import '../../model/location_repository.dart';
import '../../model/location_sorter.dart';

class LocationIdKeyFieldPanelController extends KeyFieldController<LocationId?> {
  LocationIdKeyFieldPanelController(super.keyField);

  static final unknownLocationId = LocationId();
  static final DropdownMenuEntry<LocationId> unknownEntry =
      DropdownMenuEntry<LocationId>(value: unknownLocationId, label: "unknown");
  final _locationRepository = getIt.get<LocationRepository>();
  final _sorter = getIt.get<LocationSorter>();

  Location? get presentLocation {
    if (currentValue != null) {
      return _locationRepository.getContentElementById(currentValue!);
    }
    return null;
  }

  List<DropdownMenuEntry<LocationId>> get validLocationEntries {
    List<Location> validLocations = _validLocations;
    validLocations.sort(_sorter.sort);
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

  DropdownMenuEntry<LocationId> _mapLocationToDropdownMenuEntry(
    Location location,
  ) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "";
    String icon = location.locationLevel.icon;
    return DropdownMenuEntry<LocationId>(
        value: location.id, label: icon + name);
  }

  @override
  void updateKey(LocationId? newValue) {
    if (newValue != null) {
      if (newValue == unknownLocationId) {
        super.updateKey(null);
      } else {
        super.updateKey(newValue);
      }
    }
  }
}
