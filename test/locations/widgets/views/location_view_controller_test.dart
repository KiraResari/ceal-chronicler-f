import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/panels/connected_location_panel_template.dart';
import 'package:ceal_chronicler_f/locations/widgets/views/location_view_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;
  late LocationConnectionRepository locationConnectionRepository;
  late CharacterRepository characterRepository;
  late PartyRepository partyRepository;

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
    locationConnectionRepository = LocationConnectionRepository();
    characterRepository = CharacterRepository();
    partyRepository = PartyRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<LocationConnectionRepository>(
        locationConnectionRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<PartyRepository>(partyRepository);
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

  test(
    "getConnectedLocationsForDirection should return connection where this is start",
    () {
      var thisLocation = Location(pointInTimeRepository.activePointInTime.id);
      var otherLocation = Location(pointInTimeRepository.activePointInTime.id);
      locationRepository.add(thisLocation);
      locationRepository.add(otherLocation);
      var direction = LocationConnectionDirection.southwest;
      locationConnectionRepository.add(
          LocationConnection(thisLocation.id, direction, otherLocation.id));
      var controller = LocationViewController(thisLocation);

      List<ConnectedLocationPanelTemplate> connections =
          controller.getConnectedLocationsForDirection(direction);

      expect(
        connections.map((connection) => connection.location),
        contains(otherLocation),
      );
    },
  );

  test(
    "getConnectedLocationsForDirection should not return connection for other direction",
    () {
      var thisLocation = Location(pointInTimeRepository.activePointInTime.id);
      var otherLocation = Location(pointInTimeRepository.activePointInTime.id);
      locationRepository.add(thisLocation);
      locationRepository.add(otherLocation);
      locationConnectionRepository.add(LocationConnection(
          thisLocation.id, LocationConnectionDirection.east, otherLocation.id));
      var controller = LocationViewController(thisLocation);

      List<ConnectedLocationPanelTemplate> connections = controller
          .getConnectedLocationsForDirection(LocationConnectionDirection.north);

      expect(connections, isEmpty);
    },
  );

  test(
    "getConnectedLocationsForDirection should return connection where this is end",
    () {
      var thisLocation = Location(pointInTimeRepository.activePointInTime.id);
      var otherLocation = Location(pointInTimeRepository.activePointInTime.id);
      locationRepository.add(thisLocation);
      locationRepository.add(otherLocation);
      var direction = LocationConnectionDirection.southwest;
      locationConnectionRepository.add(
          LocationConnection(otherLocation.id, direction, thisLocation.id));
      var controller = LocationViewController(thisLocation);

      List<ConnectedLocationPanelTemplate> connections =
          controller.getConnectedLocationsForDirection(direction.opposite);

      expect(
        connections.map((connection) => connection.location),
        contains(otherLocation),
      );
    },
  );

  test(
    "get getConnectedLocationsForDirection should not return connection to point in time that is not currently active",
    () {
      var thisLocation = Location(pointInTimeRepository.activePointInTime.id);
      var futurePoint = PointInTime("Future Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var otherLocation = Location(futurePoint.id);
      locationRepository.add(thisLocation);
      locationRepository.add(otherLocation);
      var direction = LocationConnectionDirection.southwest;
      locationConnectionRepository.add(
          LocationConnection(otherLocation.id, direction, thisLocation.id));
      var controller = LocationViewController(thisLocation);

      List<ConnectedLocationPanelTemplate> connections =
          controller.getConnectedLocationsForDirection(direction.opposite);

      expect(connections, isEmpty);
    },
  );

  test(
    "get charactersPresentAtLocation should return character that is in party at location",
    () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var location = Location(present.id);
      var character = Character(present.id);
      characterRepository.add(character);
      var party = Party(present.id);
      partyRepository.add(party);
      character.party.addOrUpdateKeyAtTime(party.id, present.id);
      party.presentLocation.addOrUpdateKeyAtTime(location.id, present.id);
      var controller = LocationViewController(location);

      List<Character> charactersAtLocation =
          controller.charactersPresentAtLocation;

      expect(charactersAtLocation, contains(character));
    },
  );

  test(
    "get charactersPresentAtLocation should not return character that is at location, but is in party that is not at location",
    () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var location = Location(present.id);
      var character = Character(present.id);
      characterRepository.add(character);
      var party = Party(present.id);
      partyRepository.add(party);
      character.party.addOrUpdateKeyAtTime(party.id, present.id);
      character.presentLocation.addOrUpdateKeyAtTime(location.id, present.id);
      var controller = LocationViewController(location);

      List<Character> charactersAtLocation =
          controller.charactersPresentAtLocation;

      expect(charactersAtLocation, isNot(contains(character)));
    },
  );
}
