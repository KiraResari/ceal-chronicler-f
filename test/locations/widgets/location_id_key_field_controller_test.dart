import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/location_id_key_field_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late LocationRepository locationRepository;
  late KeyFieldResolver keyFieldResolver;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<FileProcessor>(FileProcessorMockLite());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    characterRepository = CharacterRepository();
    locationRepository = LocationRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<LocationRepository>(locationRepository);
    keyFieldResolver = KeyFieldResolver();
  });

  test(
    "validLocationEntries should return all valid locations plus unknown",
        () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var location = Location(presentPointId);
      locationRepository.add(location);
      var controller = LocationIdKeyFieldController(character.presentLocation);

      List<DropdownMenuEntry<LocationId>> locationEntries =
          controller.validLocationEntries;

      expect(
          locationEntries.any((entry) => entry.value == location.id), isTrue);
      expect(
          locationEntries
              .any((entry) => entry == LocationIdKeyFieldController.unknownEntry),
          isTrue);
    },
  );

  test(
    "validLocationEntries should not return locations with a firstAppearance after the current point in time",
        () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var futurePoint = PointInTime("Future Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var character = Character(presentPointId);
      var location = Location(futurePoint.id);
      locationRepository.add(location);
      var controller = LocationIdKeyFieldController(character.presentLocation);

      List<DropdownMenuEntry<LocationId>> locationEntries =
          controller.validLocationEntries;

      expect(
          locationEntries.any((entry) => entry.value == location.id), isFalse);
    },
  );

  test(
    "updatePresentLocation should correctly update character's present location",
        () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var controller = LocationIdKeyFieldController(character.presentLocation);
      var newLocationId = LocationId();

      controller.updatePresentLocation(newLocationId);

      LocationId presentLocationId = controller.presentLocation;
      expect(presentLocationId, equals(newLocationId));
    },
  );

  test(
    "updatePresentLocation with unknownLocationId should remove character's present location",
        () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var locationId = LocationId();
      character.presentLocation
          .addOrUpdateKeyAtTime(locationId, presentPointId);
      var controller = LocationIdKeyFieldController(character.presentLocation);

      controller
          .updatePresentLocation(LocationIdKeyFieldController.unknownLocationId);

      LocationId? presentLocationId =
      keyFieldResolver.getCurrentValue(character.presentLocation);
      expect(presentLocationId, isNull);
    },
  );

  test(
    "updatePresentLocation with unknownLocationId should set character's present location to unknown, even if a previous key exists",
        () {
      var pastPoint = PointInTime("Past Point In Time");
      pointInTimeRepository.addAtIndex(0, pastPoint);
      var character = Character(pastPoint.id);
      var locationId = LocationId();
      character.presentLocation.addOrUpdateKeyAtTime(locationId, pastPoint.id);
      var controller = LocationIdKeyFieldController(character.presentLocation);

      controller
          .updatePresentLocation(LocationIdKeyFieldController.unknownLocationId);

      LocationId? presentLocationId =
      keyFieldResolver.getCurrentValue(character.presentLocation);
      expect(presentLocationId, isNull);
    },
  );
}
