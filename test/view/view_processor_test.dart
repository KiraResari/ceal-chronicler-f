import 'package:ceal_chronicler_f/characters/commands/create_character_command.dart';
import 'package:ceal_chronicler_f/characters/commands/update_first_appearance_command.dart';
import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/commands/create_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/toolBar/tool_bar_controller.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:ceal_chronicler_f/view/commands/open_character_view_command.dart';
import 'package:ceal_chronicler_f/view/commands/open_overview_view_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/file_adapter_mock.dart';

main() {
  late ViewProcessor viewProcessor;
  late CommandProcessor commandProcessor;
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late FileProcessor fileProcessor;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    characterRepository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
    viewProcessor = ViewProcessor();
    getIt.registerSingleton<ViewProcessor>(viewProcessor);
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    commandProcessor = CommandProcessor();
    getIt.registerSingleton<CommandProcessor>(commandProcessor);
    getIt.registerSingleton<FileAdapter>(FileAdapterMock());
    fileProcessor = FileProcessor();
    getIt.registerSingleton<FileProcessor>(fileProcessor);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
  });

  test("Process should correctly process command", () {
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);

    viewProcessor.process(command);

    expect(pointInTimeRepository.activePointInTime, equals(newPoint));
  });

  test(
      "Navigating back should not be possible if no commands have been processed",
      () {
    expect(viewProcessor.isNavigatingBackPossible, isFalse);
  });

  test(
      "Navigating back should be possible if a command has been processed, and that command is still valid",
      () {
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isTrue);
  });

  test(
      "Navigating back should not be possible if all previous commands are invalid",
      () {
    var originalPoint = pointInTimeRepository.first;
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    pointInTimeRepository.remove(originalPoint);

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isFalse);
  });

  test("Navigating back should restore last view", () {
    var originalPoint = pointInTimeRepository.first;
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    viewProcessor.navigateBack();

    expect(pointInTimeRepository.activePointInTime, equals(originalPoint));
  });

  test("Navigating back should skip invalid commands", () {
    var originalPoint = pointInTimeRepository.first;
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    pointInTimeRepository.addAtIndex(0, firstNewPoint);
    pointInTimeRepository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);
    pointInTimeRepository.remove(firstNewPoint);

    viewProcessor.navigateBack();

    expect(pointInTimeRepository.activePointInTime, equals(originalPoint));
  });

  test(
      "Navigating forward should not be possible if no commands have been processed",
      () {
    expect(viewProcessor.isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should be possible if a valid target command exists",
      () {
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    viewProcessor.navigateBack();

    var isNavigatingForwardPossible = viewProcessor.isNavigatingForwardPossible;

    expect(isNavigatingForwardPossible, isTrue);
  });

  test(
      "Navigating forward should not be possible if all forward targets are invalid",
      () {
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    viewProcessor.navigateBack();
    pointInTimeRepository.remove(newPoint);

    var isNavigatingForwardPossible = viewProcessor.isNavigatingForwardPossible;

    expect(isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should work if a valid target command exists", () {
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    viewProcessor.navigateBack();

    viewProcessor.navigateForward();

    expect(pointInTimeRepository.activePointInTime, equals(newPoint));
  });

  test("Navigating forward should skip invalid commands", () {
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    pointInTimeRepository.addAtIndex(0, firstNewPoint);
    pointInTimeRepository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);

    viewProcessor.navigateBack();
    viewProcessor.navigateBack();
    pointInTimeRepository.remove(firstNewPoint);
    viewProcessor.navigateForward();

    expect(pointInTimeRepository.activePointInTime, equals(secondNewPoint));
  });

  test("Navigating backward should not be possible after loading", () async {
    ToolBarController controller = ToolBarController();
    var newPoint = PointInTime("test");
    pointInTimeRepository.addAtIndex(0, newPoint);
    await fileProcessor.save();
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    await controller.load();

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;
    expect(isNavigatingBackPossible, isFalse);
  });

  //This happened because "execute()" was used instead of "redo()"
  test("Skipping elements while navigating forward should not break history",
      () {
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    pointInTimeRepository.addAtIndex(0, firstNewPoint);
    pointInTimeRepository.addAtIndex(0, secondNewPoint);

    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);
    pointInTimeRepository.remove(firstNewPoint);
    viewProcessor.navigateBack();
    viewProcessor.navigateForward();
    pointInTimeRepository.addAtIndex(0, firstNewPoint);
    viewProcessor.navigateBack();

    expect(pointInTimeRepository.activePointInTime, equals(firstNewPoint));
  });

  test(
      "Navigating back should not be possible if only valid commands navigate to currently active view",
      () {
    commandProcessor.process(CreateCharacterCommand(PointInTimeId()));
    Character character = characterRepository.content.first;
    viewProcessor.process(OpenCharacterViewCommand(character));
    viewProcessor.process(OpenOverviewViewCommand());
    commandProcessor.undo();

    expect(viewProcessor.isNavigatingBackPossible, isFalse);
  });

  test(
      "Navigating forward should not be possible if only valid commands navigate to currently active view",
      () {
    commandProcessor.process(CreateCharacterCommand(PointInTimeId()));
    Character character = characterRepository.content.first;
    viewProcessor.process(OpenCharacterViewCommand(character));
    viewProcessor.process(OpenOverviewViewCommand());
    viewProcessor.navigateBack();
    viewProcessor.navigateBack();
    commandProcessor.undo();

    expect(viewProcessor.isNavigatingForwardPossible, isFalse);
  });

  test(
      "Navigating back should not be possible if only valid commands navigate to currently point in time",
      () {
    commandProcessor.process(CreatePointInTimeCommand(0));
    PointInTimeId newPointId = pointInTimeRepository.pointsInTime.first.id;
    PointInTimeId originalPointId = pointInTimeRepository.pointsInTime.last.id;
    viewProcessor.process(ActivatePointInTimeCommand(newPointId));
    viewProcessor.process(ActivatePointInTimeCommand(originalPointId));
    commandProcessor.undo();

    expect(viewProcessor.isNavigatingBackPossible, isFalse);
  });

  test(
      "Navigating forward should not be possible if only valid commands navigate to currently point in time",
      () {
    commandProcessor.process(CreatePointInTimeCommand(0));
    PointInTimeId newPointId = pointInTimeRepository.pointsInTime.first.id;
    PointInTimeId originalPointId = pointInTimeRepository.pointsInTime.last.id;
    viewProcessor.process(ActivatePointInTimeCommand(newPointId));
    viewProcessor.process(ActivatePointInTimeCommand(originalPointId));
    viewProcessor.navigateBack();
    viewProcessor.navigateBack();
    commandProcessor.undo();

    expect(viewProcessor.isNavigatingForwardPossible, isFalse);
  });

  test(
    "If a character's first appearance was forwarded, then navigating back should not navigate back to the old point in time",
    () {
      commandProcessor.process(
          CreateCharacterCommand(pointInTimeRepository.activePointInTime.id));
      Character character = characterRepository.content.first;
      viewProcessor.process(OpenCharacterViewCommand(character));
      commandProcessor.process(CreatePointInTimeCommand(1));
      PointInTime secondPoint = pointInTimeRepository.pointsInTime.last;
      viewProcessor.process(ActivatePointInTimeCommand(secondPoint.id));
      commandProcessor
          .process(UpdateFirstAppearanceCommand(character, secondPoint.id));
      viewProcessor.navigateBack();

      expect(pointInTimeRepository.activePointInTime, equals(secondPoint));
    },
  );
}
