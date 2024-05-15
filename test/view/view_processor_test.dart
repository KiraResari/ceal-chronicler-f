import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/toolBar/tool_bar_controller.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/file_service_mock.dart';

main() {
  late ViewProcessor viewProcessor;
  late CommandProcessor commandProcessor;
  late PointInTimeRepository repository;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<CharacterRepository>(CharacterRepository());
    getIt.registerSingleton<RepositoryService>(RepositoryService());
    getIt.registerSingleton<FileService>(FileServiceMock());
    viewProcessor = ViewProcessor();
    getIt.registerSingleton<ViewProcessor>(viewProcessor);
    commandProcessor = CommandProcessor();
    getIt.registerSingleton<CommandProcessor>(commandProcessor);
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
    await commandProcessor.save();
    var command = ActivatePointInTimeCommand(newPoint.id);
    viewProcessor.process(command);

    await controller.load();

    var isNavigatingBackPossible = viewProcessor.isNavigatingBackPossible;
    expect(isNavigatingBackPossible, isFalse);
  });
}
