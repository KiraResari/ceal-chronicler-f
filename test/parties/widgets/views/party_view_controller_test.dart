import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
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
import 'package:ceal_chronicler_f/parties/widgets/view/party_view_controller.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late PartyRepository partyRepository;
  late CharacterRepository characterRepository;
  late LocationRepository locationRepository;

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
    partyRepository = PartyRepository();
    getIt.registerSingleton<PartyRepository>(partyRepository);
    characterRepository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
  });

  test(
    "validFirstAppearances should not return points in time after any keys",
    () {
      PointInTime firstPointInTime = pointInTimeRepository.activePointInTime;
      var secondPointInTime = PointInTime("Second Point In Time");
      var thirdPointInTime = PointInTime("Third Point In Time");
      pointInTimeRepository.addAtIndex(1, secondPointInTime);
      pointInTimeRepository.addAtIndex(2, thirdPointInTime);
      var party = Party(secondPointInTime.id);
      partyRepository.add(party);
      party.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = PartyViewController(party);

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
      var party = Party(secondPointInTime.id);
      partyRepository.add(party);
      party.name.addOrUpdateKeyAtTime("New Name", secondPointInTime.id);
      var controller = PartyViewController(party);

      List<PointInTime> validLastAppearances = controller.validLastAppearances;

      expect(validLastAppearances,
          containsAll([secondPointInTime, thirdPointInTime]));
      expect(validLastAppearances, isNot(contains(firstPointInTime)));
    },
  );

  test(
    "get activeCharacters should return active characters in party",
    () {
      PointInTimeId pointId = pointInTimeRepository.activePointInTime.id;
      var party = Party(pointId);
      var character = Character(pointId);
      characterRepository.add(character);
      character.party.addOrUpdateKeyAtTime(party.id, pointId);
      var controller = PartyViewController(party);

      List<Character> activeCharacters = controller.activeCharacters;

      expect(activeCharacters, contains(character));
    },
  );

  test(
    "get activeCharacters should not return characters that are not in party",
    () {
      PointInTimeId pointId = pointInTimeRepository.activePointInTime.id;
      var party = Party(pointId);
      var character = Character(pointId);
      characterRepository.add(character);
      var controller = PartyViewController(party);

      List<Character> activeCharacters = controller.activeCharacters;

      expect(activeCharacters, isNot(contains(character)));
    },
  );

  test(
    "get activeCharacters should not return characters that are in party but not active",
    () {
      PointInTimeId presentPoint = pointInTimeRepository.activePointInTime.id;
      var futurePoint = PointInTime("Second Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var party = Party(presentPoint);
      var character = Character(futurePoint.id);
      characterRepository.add(character);
      var controller = PartyViewController(party);

      List<Character> activeCharacters = controller.activeCharacters;

      expect(activeCharacters, isNot(contains(character)));
    },
  );
}
