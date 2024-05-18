import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/toolBar/tool_bar_controller.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/file_adapter_mock.dart';

main() {
  late ViewProcessor viewProcessor;
  late CommandProcessor commandProcessor;
  late PointInTimeRepository repository;
  late FileProcessor fileProcessor;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<CharacterRepository>(CharacterRepository());
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
  });

  test("Process should correctly process command", () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);

    viewProcessor.process(command);

    expect(repository.activePointInTime, equals(newPoint));
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
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isTrue);
  });

  test(
      "Navigating back should not be possible if all previous commands are invalid",
      () {
    var originalPoint = repository.first;
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    repository.remove(originalPoint);

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isFalse);
  });

  test("Navigating back should restore last view", () {
    var originalPoint = repository.first;
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    viewProcessor.navigateBack();

    expect(repository.activePointInTime, equals(originalPoint));
  });

  test("Navigating back should skip invalid commands", () {
    var originalPoint = repository.first;
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    repository.addAtIndex(0, firstNewPoint);
    repository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);
    repository.remove(firstNewPoint);

    viewProcessor.navigateBack();

    expect(repository.activePointInTime, equals(originalPoint));
  });

  test(
      "Navigating forward should not be possible if no commands have been processed",
      () {
    expect(viewProcessor.isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should be possible if a valid target command exists",
      () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
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
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    viewProcessor.navigateBack();
    repository.remove(newPoint);

    var isNavigatingForwardPossible = viewProcessor.isNavigatingForwardPossible;

    expect(isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should work if a valid target command exists", () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);
    viewProcessor.navigateBack();

    viewProcessor.navigateForward();

    expect(repository.activePointInTime, equals(newPoint));
  });

  test("Navigating forward should skip invalid commands", () {
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    repository.addAtIndex(0, firstNewPoint);
    repository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);

    viewProcessor.navigateBack();
    viewProcessor.navigateBack();
    repository.remove(firstNewPoint);
    viewProcessor.navigateForward();

    expect(repository.activePointInTime, equals(secondNewPoint));
  });

  test("Navigating backward should not be possible after loading", () async {
    ToolBarController controller = ToolBarController();
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
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
    repository.addAtIndex(0, firstNewPoint);
    repository.addAtIndex(0, secondNewPoint);

    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    viewProcessor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    viewProcessor.process(command2);
    repository.remove(firstNewPoint);
    viewProcessor.navigateBack();
    viewProcessor.navigateForward();
    repository.addAtIndex(0, firstNewPoint);
    viewProcessor.navigateBack();

    expect(repository.activePointInTime, equals(firstNewPoint));
  });
}
