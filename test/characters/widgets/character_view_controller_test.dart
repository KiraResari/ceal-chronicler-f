import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/characters/widgets/character_view_controller.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late LocationRepository locationRepository;
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
    characterRepository = CharacterRepository();
    locationRepository = LocationRepository();
    partyRepository = PartyRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<LocationRepository>(locationRepository);
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
      var character = Character(secondPointInTime.id);
      characterRepository.add(character);
      character.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = CharacterViewController(character);

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
      var character = Character(secondPointInTime.id);
      characterRepository.add(character);
      character.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = CharacterViewController(character);

      List<PointInTime> validLastAppearances = controller.validLastAppearances;

      expect(validLastAppearances,
          containsAll([secondPointInTime, thirdPointInTime]));
      expect(validLastAppearances, isNot(contains(firstPointInTime)));
    },
  );

  test(
    "isPresentlyInParty should return true if character is presently in party",
        () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var character = Character(present.id);
      characterRepository.add(character);
      var party = Party(present.id);
      character.party.addOrUpdateKeyAtTime(party.id, present.id);
      var controller = CharacterViewController(character);

      bool isPresentlyInParty = controller.isPresentlyInParty;

      expect(isPresentlyInParty, isTrue);
    },
  );

  test(
    "isPresentlyInParty should return false if character is not in any party",
        () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var character = Character(present.id);
      characterRepository.add(character);
      var controller = CharacterViewController(character);

      bool isPresentlyInParty = controller.isPresentlyInParty;

      expect(isPresentlyInParty, isFalse);
    },
  );

  test(
    "isPresentlyInParty should return false if character is in party, but not at the present point in time",
        () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var future = PointInTime("Second Point In Time");
      pointInTimeRepository.addAtIndex(1, future);
      var character = Character(present.id);
      characterRepository.add(character);
      var party = Party(present.id);
      character.party.addOrUpdateKeyAtTime(party.id, future.id);
      var controller = CharacterViewController(character);

      bool isPresentlyInParty = controller.isPresentlyInParty;

      expect(isPresentlyInParty, isFalse);
    },
  );

  test(
    "getPartyLocation should return party's current location",
        () {
      PointInTime present = pointInTimeRepository.activePointInTime;
      var party = Party(present.id);
      partyRepository.add(party);
      var character = Character(present.id);
      characterRepository.add(character);
      character.party.addOrUpdateKeyAtTime(party.id, present.id);
      var location = Location(present.id);
      locationRepository.add(location);
      party.presentLocation.addOrUpdateKeyAtTime(location.id, present.id);
      var controller = CharacterViewController(character);

      Location? partyLocation = controller.partyLocation;

      expect(partyLocation, equals(location));
    },
  );
}
