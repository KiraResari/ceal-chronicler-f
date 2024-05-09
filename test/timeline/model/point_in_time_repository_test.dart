import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository repository;
  setUp(() {
    repository = PointInTimeRepository();
  });

  test("Newly created repository should contain one point in time", () {
    expect(repository.pointsInTime.length, equals(1));
  });

  test("Adding a point in time before the default one should work", () {
    repository.createNewAtIndex(0);

    expect(repository.pointsInTime.length, equals(2));
    String secondPointName =
        "${PointInTimeRepository.defaultPointInTimeName}${PointInTimeRepository.startingRunningNumber}";
    expect(repository.first.name, equals(secondPointName));
  });

  test("Adding a point in time after the default one should work", () {
    repository.createNewAtIndex(1);

    expect(repository.pointsInTime.length, equals(2));
    String secondPointName = PointInTimeRepository.defaultPointInTimeName;
    expect(repository.first.name, equals(secondPointName));
  });

  test("Points in time should have unique names", () {
    repository.createNewAtIndex(0);

    List<String> names = repository.existingNames;
    Set<String> uniqueNames = Set<String>.from(names);
    for (String uniqueName in uniqueNames) {
      names.remove(uniqueName);
    }
    expect(names, isEmpty, reason: 'Duplicate names found: $names');
  });

  test("Removing point in time should work", () {
    repository.createNewAtIndex(0);
    PointInTime pointToBeRemoved = repository.first;

    repository.remove(pointToBeRemoved);

    expect(repository.pointsInTime.length, equals(1));
    expect(repository.pointsInTime, isNot(contains(pointToBeRemoved)));
  });

  test("Attempting to remove final point in time should cause exception", () {
    PointInTime pointToBeRemoved = repository.first;

    expect(() {
      repository.remove(pointToBeRemoved);
    }, throwsA(isA<InvalidOperationException>()));
  });

  test("Renaming point in time should work", () {
    PointInTime pointToBeRenamed = repository.first;
    String newName = "New Name";

    repository.rename(pointToBeRenamed, newName);

    expect(repository.existingNames, contains(newName));
  });

  test(
      "Attempting to rename point in time to the name of another point in time should cause exception",
      () {
    repository.createNewAtIndex(1);
    PointInTime firstPoint = repository.first;
    PointInTime secondPoint = repository.pointsInTime[1];

    expect(() {
      repository.rename(firstPoint, secondPoint.name);
    }, throwsA(isA<InvalidOperationException>()));
  });

  test("Renaming point in time to its current name should not cause exception",
      () {
    PointInTime pointToBeRenamed = repository.first;
    String newName = pointToBeRenamed.name;

    repository.rename(pointToBeRenamed, pointToBeRenamed.name);

    expect(repository.existingNames, contains(newName));
  });

  test(
      "activePointInTimeIsNotBefore should return false if checked against later point",
      () {
    PointInTime laterPoint = repository.createNewAtIndex(1);

    bool result = repository.activePointInTimeIsNotBefore(laterPoint.id);

    expect(result, isFalse);
  });

  test(
      "activePointInTimeIsNotBefore should return true if checked against earlier point",
      () {
    PointInTime earlierPoint = repository.createNewAtIndex(0);

    bool result = repository.activePointInTimeIsNotBefore(earlierPoint.id);

    expect(result, isTrue);
  });

  test(
      "activePointInTimeIsNotBefore should return true if checked against active point",
      () {
    PointInTime activePoint = repository.activePointInTime;

    bool result = repository.activePointInTimeIsNotBefore(activePoint.id);

    expect(result, isTrue);
  });
}
