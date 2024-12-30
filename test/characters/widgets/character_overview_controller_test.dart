import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/characters/widgets/character_overview_controller.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_adapter_mock.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late CharacterOverviewController controller;
  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    characterRepository = CharacterRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<LocationRepository>(LocationRepository());
    getIt.registerSingleton<LocationConnectionRepository>(
        LocationConnectionRepository());
    getIt.registerSingleton<PartyRepository>(PartyRepository());
    getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
    getIt.registerSingleton<FileAdapter>(FileAdapterMock());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    getIt.registerSingleton<FileProcessor>(FileProcessor());
    controller = CharacterOverviewController();
  });

  test(
    "Character should be displayed if active point in time is between first and last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var character = Character(activePointInTime.id);
      characterRepository.add(character);

      List<Character> characters = controller.entitiesAtActivePointInTime;

      expect(characters, contains(character));
    },
  );

  test(
    "Character should not be displayed if active point in time is before its first appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var character = Character(activePointInTime.id);
      characterRepository.add(character);

      PointInTime pointBeforeCharacterFirstAppearance = PointInTime("Before");
      pointInTimeRepository.addAtIndex(0, pointBeforeCharacterFirstAppearance);
      pointInTimeRepository.activePointInTime =
          pointBeforeCharacterFirstAppearance;
      List<Character> characters = controller.entitiesAtActivePointInTime;

      expect(characters, isNot(contains(character)));
    },
  );

  test(
    "Character should not be displayed if active point in time is after its last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var character = Character(activePointInTime.id);
      character.lastAppearance = activePointInTime.id;
      characterRepository.add(character);

      PointInTime pointAfterCharacterLastAppearance = PointInTime("After");
      pointInTimeRepository.addAtIndex(1, pointAfterCharacterLastAppearance);
      pointInTimeRepository.activePointInTime =
          pointAfterCharacterLastAppearance;
      List<Character> characters = controller.entitiesAtActivePointInTime;

      expect(characters, isNot(contains(character)));
    },
  );
}
