import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/characters/widgets/character_view_controller.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
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
    characterRepository = CharacterRepository();
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

      List<PointInTime> validLastAppearances =
          controller.validLastAppearances;

      expect(validLastAppearances,
          containsAll([secondPointInTime, thirdPointInTime]));
      expect(validLastAppearances, isNot(contains(firstPointInTime)));
    },
  );
}
