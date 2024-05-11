import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late ViewProcessor processor;
  late PointInTimeRepository repository;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    processor = ViewProcessor();
  });

  test("Process should correctly process command", () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);

    processor.process(command);

    expect(repository.activePointInTime, equals(newPoint));
  });

  test(
      "Navigating back should not be possible if no commands have been processed",
      () {
    expect(processor.isNavigatingBackPossible, isFalse);
  });

  test(
      "Navigating back should be possible if a command has been processed, and that command is still valid",
      () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);

    var isNavigatingBackPossible = processor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isTrue);
  });

  test(
      "Navigating back should not be possible if all previous commands are invalid",
      () {
    var originalPoint = repository.first;
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);
    repository.remove(originalPoint);

    var isNavigatingBackPossible = processor.isNavigatingBackPossible;

    expect(isNavigatingBackPossible, isFalse);
  });

  test("Navigating back should restore last view", () {
    var originalPoint = repository.first;
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);

    processor.navigateBack();

    expect(repository.activePointInTime, equals(originalPoint));
  });

  test("Navigating back should skip invalid commands", () {
    var originalPoint = repository.first;
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    repository.addAtIndex(0, firstNewPoint);
    repository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    processor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    processor.process(command2);
    repository.remove(firstNewPoint);

    processor.navigateBack();

    expect(repository.activePointInTime, equals(originalPoint));
  });

  test(
      "Navigating forward should not be possible if no commands have been processed",
      () {
    expect(processor.isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should be possible if a valid target command exists",
      () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);
    processor.navigateBack();

    var isNavigatingForwardPossible = processor.isNavigatingForwardPossible;

    expect(isNavigatingForwardPossible, isTrue);
  });

  test(
      "Navigating forward should not be possible if all forward targets are invalid",
      () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);
    processor.navigateBack();
    repository.remove(newPoint);

    var isNavigatingForwardPossible = processor.isNavigatingForwardPossible;

    expect(isNavigatingForwardPossible, isFalse);
  });

  test("Navigating forward should work if a valid target command exists", () {
    var newPoint = PointInTime("test");
    repository.addAtIndex(0, newPoint);
    var command = ActivatePointInTimeCommand(newPoint.id);
    processor.process(command);
    processor.navigateBack();

    processor.navigateForward();

    expect(repository.activePointInTime, equals(newPoint));
  });

  test("Navigating forward should skip invalid commands", () {
    var firstNewPoint = PointInTime("test");
    var secondNewPoint = PointInTime("test2");
    repository.addAtIndex(0, firstNewPoint);
    repository.addAtIndex(0, secondNewPoint);
    var command = ActivatePointInTimeCommand(firstNewPoint.id);
    processor.process(command);
    var command2 = ActivatePointInTimeCommand(secondNewPoint.id);
    processor.process(command2);

    processor.navigateBack();
    processor.navigateBack();
    repository.remove(firstNewPoint);
    processor.navigateForward();

    expect(repository.activePointInTime, equals(secondNewPoint));
  });
}
