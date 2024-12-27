import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/views/location_view_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;
  late CharacterRepository characterRepository;

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
    locationRepository = LocationRepository();
    characterRepository = CharacterRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
  });

  test(
    "validFirstAppearances should not return points in time after any keys",
    () {
      PointInTime firstPointInTime = pointInTimeRepository.activePointInTime;
      var secondPointInTime = PointInTime("Second Point In Time");
      var thirdPointInTime = PointInTime("Third Point In Time");
      pointInTimeRepository.addAtIndex(1, secondPointInTime);
      pointInTimeRepository.addAtIndex(2, thirdPointInTime);
      var location = Location(secondPointInTime.id);
      locationRepository.add(location);
      location.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = LocationViewController(location);

      List<PointInTime> validFirstAppearances =
          controller.validFirstAppearances;

      expect(validFirstAppearances,
          containsAll([firstPointInTime, secondPointInTime]));
      expect(validFirstAppearances, isNot(contains(thirdPointInTime)));
    },
  );

  test(
    "validLastAppearances should not return points in time before any keys",
    () {
      PointInTime firstPointInTime = pointInTimeRepository.activePointInTime;
      var secondPointInTime = PointInTime("Second Point In Time");
      var thirdPointInTime = PointInTime("Third Point In Time");
      pointInTimeRepository.addAtIndex(1, secondPointInTime);
      pointInTimeRepository.addAtIndex(2, thirdPointInTime);
      var location = Location(secondPointInTime.id);
      locationRepository.add(location);
      location.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = LocationViewController(location);

      List<PointInTime> validLastAppearances = controller.validLastAppearances;

      expect(validLastAppearances,
          containsAll([secondPointInTime, thirdPointInTime]));
      expect(validLastAppearances, isNot(contains(firstPointInTime)));
    },
  );

  test(
    "get charactersPresentAtLocation should return character at location",
    () {
      PointInTimeId pointId = pointInTimeRepository.activePointInTime.id;
      var location = Location(pointId);
      var character = Character(pointId);
      characterRepository.add(character);
      character.presentLocation.addOrUpdateKeyAtTime(location.id, pointId);
      var controller = LocationViewController(location);

      List<Character> charactersAtLocation =
          controller.charactersPresentAtLocation;

      expect(charactersAtLocation, contains(character));
    },
  );

  test(
    "get charactersPresentAtLocation should not return character that is not at location",
    () {
      PointInTimeId pointId = pointInTimeRepository.activePointInTime.id;
      var location = Location(pointId);
      var character = Character(pointId);
      characterRepository.add(character);
      var controller = LocationViewController(location);

      List<Character> charactersAtLocation =
          controller.charactersPresentAtLocation;

      expect(charactersAtLocation, isNot(contains(character)));
    },
  );

  test(
    "get charactersPresentAtLocation should not return character that at location if that characters is not active",
    () {
      PointInTime presentPoint = pointInTimeRepository.activePointInTime;
      var futurePoint = PointInTime("Second Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var location = Location(presentPoint.id);
      var character = Character(futurePoint.id);
      characterRepository.add(character);
      character.presentLocation
          .addOrUpdateKeyAtTime(location.id, presentPoint.id);
      var controller = LocationViewController(location);

      List<Character> charactersAtLocation =
          controller.charactersPresentAtLocation;

      expect(charactersAtLocation, isNot(contains(character)));
    },
  );

  test(
    "get childLocations should return all child locations if they are active",
    () {
      var parentLocation = Location(pointInTimeRepository.activePointInTime.id);
      var firstChildLocation =
          Location(pointInTimeRepository.activePointInTime.id);
      var secondChildLocation =
          Location(pointInTimeRepository.activePointInTime.id);
      locationRepository.add(parentLocation);
      locationRepository.add(firstChildLocation);
      locationRepository.add(secondChildLocation);
      firstChildLocation.parentLocation = parentLocation.id;
      secondChildLocation.parentLocation = parentLocation.id;
      var controller = LocationViewController(parentLocation);

      List<Location> childLocations = controller.childLocations;

      expect(childLocations,
          containsAll([firstChildLocation, secondChildLocation]));
    },
  );

  test(
    "get childLocations should not return future child locations",
    () {
      var parentLocation = Location(pointInTimeRepository.activePointInTime.id);
      var futurePoint = PointInTime("Future Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var childLocation = Location(futurePoint.id);
      locationRepository.add(parentLocation);
      locationRepository.add(childLocation);
      childLocation.parentLocation = parentLocation.id;
      var controller = LocationViewController(parentLocation);

      List<Location> childLocations = controller.childLocations;

      expect(childLocations, isEmpty);
    },
  );

  test(
    "get childLocations should not return past child locations",
    () {
      var parentLocation = Location(pointInTimeRepository.activePointInTime.id);
      var pastPoint = PointInTime("Past Point in Time");
      pointInTimeRepository.addAtIndex(0, pastPoint);
      var childLocation = Location(pastPoint.id);
      childLocation.lastAppearance = pastPoint.id;
      locationRepository.add(parentLocation);
      locationRepository.add(childLocation);
      childLocation.parentLocation = parentLocation.id;
      var controller = LocationViewController(parentLocation);

      List<Location> childLocations = controller.childLocations;

      expect(childLocations, isEmpty);
    },
  );
}
