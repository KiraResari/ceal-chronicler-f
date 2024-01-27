import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("Newly created repository should contain one point in time", () {
    var repository = PointInTimeRepository();

    expect(repository.pointsInTime.length, equals(1));
  });

  test("Adding a point in time before the default one should work", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(0);

    expect(repository.pointsInTime.length, equals(2));
    String secondPointName =
        "${PointInTimeRepository.defaultPointInTimeName}${PointInTimeRepository.startingRunningNumber}";
    expect(repository.first.name, equals(secondPointName));
  });

  test("Adding a point in time after the default one should work", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(1);

    expect(repository.pointsInTime.length, equals(2));
    String secondPointName = PointInTimeRepository.defaultPointInTimeName;
    expect(repository.first.name, equals(secondPointName));
  });

  test("Points in time should have unique names", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(0);

    List<String> names = repository.existingNames;
    Set<String> uniqueNames = Set<String>.from(names);
    for (String uniqueName in uniqueNames) {
      names.remove(uniqueName);
    }
    expect(names, isEmpty, reason: 'Duplicate names found: $names');
  });

  test("Removing point in time should work", () {
    var repository = PointInTimeRepository();
    repository.createNewAtIndex(0);
    PointInTime pointToBeRemoved = repository.first;

    repository.remove(pointToBeRemoved);

    expect(repository.pointsInTime.length, equals(1));
    expect(repository.pointsInTime, isNot(contains(pointToBeRemoved)));
  });

  test("Attempting to remove final point in time should cause exception", () {
    var repository = PointInTimeRepository();
    PointInTime pointToBeRemoved = repository.first;

    expect(() {
      repository.remove(pointToBeRemoved);
    }, throwsA(isA<InvalidOperationException>()));
  });

  test("Renaming point in time should work", () {
    var repository = PointInTimeRepository();
    PointInTime pointToBeRenamed = repository.first;
    String newName = "New Name";

    repository.rename(pointToBeRenamed, newName);

    expect(repository.existingNames, contains(newName));
  });

  test(
      "Attempting to rename point in time to the name of another point in time should cause exception",
      () {
    var repository = PointInTimeRepository();
    repository.createNewAtIndex(1);
    PointInTime firstPoint = repository.first;
    PointInTime secondPoint = repository.pointsInTime[1];

    expect(() {
      repository.rename(firstPoint, secondPoint.name);
    }, throwsA(isA<InvalidOperationException>()));
  });

  test("Renaming point in time to its current name should not cause exception",
      () {
    var repository = PointInTimeRepository();
    PointInTime pointToBeRenamed = repository.first;
    String newName = pointToBeRenamed.name;

    repository.rename(pointToBeRenamed, pointToBeRenamed.name);

    expect(repository.existingNames, contains(newName));
  });
}
