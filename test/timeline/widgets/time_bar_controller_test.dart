import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_id.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_controller.dart';
import 'package:ceal_chronicler_f/view/templates/character_view_template.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late ViewRepository viewRepository;
  late TimeBarController controller;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    characterRepository = CharacterRepository();
    viewRepository = ViewRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<ViewRepository>(viewRepository);
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<FileProcessor>(FileProcessorMockLite());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    controller = TimeBarController();
  });

  test("Point with incidents should not be deletable", () {
    PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);

    newPoint.incidentReferences.add(IncidentId());

    expect(controller.canPointBeDeleted(newPoint), isFalse);
  });

  test("Point without incidents should be deletable", () {
    PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);

    expect(controller.canPointBeDeleted(newPoint), isTrue);
  });

  test("Last point should not be deletable", () {
    PointInTime onlyPoint = pointInTimeRepository.first;

    expect(controller.canPointBeDeleted(onlyPoint), isFalse);
  });

  test("Point that is first appearance of character should not be deletable",
      () {
    PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);
    characterRepository.add(Character(newPoint.id));

    expect(controller.canPointBeDeleted(newPoint), isFalse);
  });

  test("Point where character name changed should not be deletable", () {
    PointInTime originalPoint = pointInTimeRepository.activePointInTime;
    PointInTime laterPoint = pointInTimeRepository.createNewAtIndex(1);
    var character = Character(originalPoint.id);
    character.name.keys[laterPoint.id] = "ChangedName";
    characterRepository.add(character);

    expect(controller.canPointBeDeleted(laterPoint), isFalse);
  });

  test(
    "When character view is open, point before character's first appearance should not be selectable",
    () {
      PointInTime secondPoint = pointInTimeRepository.createNewAtIndex(1);
      PointInTime thirdPoint = pointInTimeRepository.createNewAtIndex(2);
      var character = Character(thirdPoint.id);
      var characterViewTemplate = CharacterViewTemplate(character);
      viewRepository.mainViewTemplate = characterViewTemplate;

      expect(controller.isButtonEnabled(secondPoint), isFalse);
    },
  );

  test(
    "When character view is open, point of character's first appearance should be selectable",
        () {
      PointInTime secondPoint = pointInTimeRepository.createNewAtIndex(1);
      var character = Character(secondPoint.id);
      var characterViewTemplate = CharacterViewTemplate(character);
      viewRepository.mainViewTemplate = characterViewTemplate;

      expect(controller.isButtonEnabled(secondPoint), isTrue);
    },
  );
}
