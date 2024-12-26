import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/edit_parent_location_button_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
  });

  test(
    "validLocations should return valid parent locations",
    () {
      Location thisLocation =
          createLocationAndAddToRepository(locationLevel: LocationLevel.locale);
      var firstValidLocation =
          Location(pointInTimeRepository.activePointInTime.id);
      var secondValidLocation =
          Location(pointInTimeRepository.activePointInTime.id);
      locationRepository.add(firstValidLocation);
      locationRepository.add(secondValidLocation);
      var controller = EditParentLocationButtonController(thisLocation);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validLocations;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        unorderedEquals([firstValidLocation.id, secondValidLocation.id]),
      );
    },
  );

  test(
    "validLocations should return not return location in future",
    () {
      Location thisLocation =
          createLocationAndAddToRepository(locationLevel: LocationLevel.locale);
      PointInTime futurePointInTime = PointInTime("Future Point in Time");
      pointInTimeRepository.addAtIndex(1, futurePointInTime);
      var futureLocation = Location(futurePointInTime.id);
      locationRepository.add(futureLocation);
      var controller = EditParentLocationButtonController(thisLocation);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validLocations;

      expect(validEntries, isEmpty);
    },
  );

  test(
    "validLocations should return not return locations that no longer exist",
    () {
      Location thisLocation =
          createLocationAndAddToRepository(locationLevel: LocationLevel.locale);
      PointInTime pastPointInTime = PointInTime("Past Point in Time");
      pointInTimeRepository.addAtIndex(0, pastPointInTime);
      var pastLocation = Location(pastPointInTime.id);
      pastLocation.lastAppearance = pastPointInTime.id;
      locationRepository.add(pastLocation);
      var controller = EditParentLocationButtonController(thisLocation);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validLocations;

      expect(validEntries, isEmpty);
    },
  );

  test(
    "validLocations should return only locations with a higher location level",
    () {
      Location thisLocation =
          createLocationAndAddToRepository(locationLevel: LocationLevel.region);
      Location higherLevelLocation = createLocationAndAddToRepository(
          locationLevel: LocationLevel.continent);
      createLocationAndAddToRepository(locationLevel: LocationLevel.locale);
      createLocationAndAddToRepository(locationLevel: LocationLevel.region);
      var controller = EditParentLocationButtonController(thisLocation);

      List<DropdownMenuEntry<LocationId>> validEntries =
          controller.validLocations;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        unorderedEquals([higherLevelLocation.id]),
      );
    },
  );
}

Location createLocationAndAddToRepository({
  required LocationLevel locationLevel,
  PointInTimeId? pointInTimeId,
}) {
  var pointInTimeRepository = getIt.get<PointInTimeRepository>();
  var locationRepository = getIt.get<LocationRepository>();
  var location =
      Location(pointInTimeId ?? pointInTimeRepository.activePointInTime.id);
  location.locationLevel = locationLevel;
  locationRepository.add(location);
  return location;
}
