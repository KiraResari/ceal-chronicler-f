import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository repository;
  setUp(
    () {
      repository = PointInTimeRepository();
    },
  );

  test(
    "Newly created repository should contain one point in time",
    () {
      expect(repository.pointsInTime.length, equals(1));
    },
  );

  test(
    "Adding a point in time before the default one should work",
    () {
      repository.createNewAtIndex(0);

      expect(repository.pointsInTime.length, equals(2));
      String secondPointName =
          "${PointInTimeRepository.defaultPointInTimeName}${PointInTimeRepository.startingRunningNumber}";
      expect(repository.first.name, equals(secondPointName));
    },
  );

  test(
    "Adding a point in time after the default one should work",
    () {
      repository.createNewAtIndex(1);

      expect(repository.pointsInTime.length, equals(2));
      String secondPointName = PointInTimeRepository.defaultPointInTimeName;
      expect(repository.first.name, equals(secondPointName));
    },
  );

  test(
    "Points in time should have unique names",
    () {
      repository.createNewAtIndex(0);

      List<String> names = repository.existingNames;
      Set<String> uniqueNames = Set<String>.from(names);
      for (String uniqueName in uniqueNames) {
        names.remove(uniqueName);
      }
      expect(names, isEmpty, reason: 'Duplicate names found: $names');
    },
  );

  test(
    "Removing point in time should work",
    () {
      repository.createNewAtIndex(0);
      PointInTime pointToBeRemoved = repository.first;

      repository.remove(pointToBeRemoved);

      expect(repository.pointsInTime.length, equals(1));
      expect(repository.pointsInTime, isNot(contains(pointToBeRemoved)));
    },
  );

  test(
    "Attempting to remove final point in time should cause exception",
    () {
      PointInTime pointToBeRemoved = repository.first;

      expect(() {
        repository.remove(pointToBeRemoved);
      }, throwsA(isA<InvalidOperationException>()));
    },
  );

  test(
    "Renaming point in time should work",
    () {
      PointInTime pointToBeRenamed = repository.first;
      String newName = "New Name";

      repository.rename(pointToBeRenamed, newName);

      expect(repository.existingNames, contains(newName));
    },
  );

  test(
    "Attempting to rename point in time to the name of another point in time should cause exception",
    () {
      repository.createNewAtIndex(1);
      PointInTime firstPoint = repository.first;
      PointInTime secondPoint = repository.pointsInTime[1];

      expect(() {
        repository.rename(firstPoint, secondPoint.name);
      }, throwsA(isA<InvalidOperationException>()));
    },
  );

  test(
    "Renaming point in time to its current name should not cause exception",
    () {
      PointInTime pointToBeRenamed = repository.first;
      String newName = pointToBeRenamed.name;

      repository.rename(pointToBeRenamed, pointToBeRenamed.name);

      expect(repository.existingNames, contains(newName));
    },
  );

  test(
    "pointIsInTheFuture should return true if reference point is in the future",
    () {
      PointInTime referencePoint = PointInTime("Test");
      repository.addAtIndex(1, referencePoint);

      bool result = repository.pointIsInTheFuture(referencePoint.id);

      expect(result, isTrue);
    },
  );

  test(
    "pointIsInTheFuture should return false of point is in the past",
    () {
      PointInTime referencePoint = PointInTime("Test");
      repository.addAtIndex(0, referencePoint);

      bool result = repository.pointIsInTheFuture(referencePoint.id);

      expect(result, isFalse);
    },
  );

  test(
    "pointIsInTheFuture should return false of point is active point",
    () {
      PointInTime referencePoint = repository.activePointInTime;

      bool result = repository.pointIsInTheFuture(referencePoint.id);

      expect(result, isFalse);
    },
  );

  test(
    "pointIsInThePast should return false if reference point is in the future",
    () {
      PointInTime referencePoint = PointInTime("Test");
      repository.addAtIndex(1, referencePoint);

      bool result = repository.pointIsInThePast(referencePoint.id);

      expect(result, isFalse);
    },
  );

  test(
    "pointIsInThePast should return true of point is in the past",
    () {
      PointInTime referencePoint = PointInTime("Test");
      repository.addAtIndex(0, referencePoint);

      bool result = repository.pointIsInThePast(referencePoint.id);

      expect(result, isTrue);
    },
  );

  test(
    "pointIsInThePast should return false of point is active point",
    () {
      PointInTime referencePoint = repository.activePointInTime;

      bool result = repository.pointIsInThePast(referencePoint.id);

      expect(result, isFalse);
    },
  );

  test(
    "entityIsActiveAtPoint should return true if entity is active at reference point",
    () {
      PointInTime secondPoint = repository.createNewAtIndex(1);
      Character character = Character(secondPoint.id);
      character.lastAppearance = secondPoint.id;

      bool isActive =
          repository.entityIsActiveAtPoint(character, secondPoint.id);

      expect(isActive, isTrue);
    },
  );

  test(
    "entityIsActiveAtPoint should return false if reference point is before entity's first appearance",
    () {
      PointInTime firstPoint = repository.activePointInTime;
      PointInTime secondPoint = repository.createNewAtIndex(1);
      Character character = Character(secondPoint.id);

      bool isActive =
          repository.entityIsActiveAtPoint(character, firstPoint.id);

      expect(isActive, isFalse);
    },
  );

  test(
    "entityIsActiveAtPoint should return false if reference point is after entity's last appearance",
    () {
      PointInTime secondPoint = repository.createNewAtIndex(1);
      PointInTime thirdPoint = repository.createNewAtIndex(2);
      Character character = Character(secondPoint.id);
      character.lastAppearance = secondPoint.id;

      bool isActive =
          repository.entityIsActiveAtPoint(character, thirdPoint.id);

      expect(isActive, isFalse);
    },
  );

  test(
    "getPointsInTimeFromUntilInclusive should return correct points in time",
    () {
      PointInTime secondPoint = repository.createNewAtIndex(1);
      PointInTime thirdPoint = repository.createNewAtIndex(2);
      PointInTime fourthPoint = repository.createNewAtIndex(3);
      repository.createNewAtIndex(4);

      List<PointInTime> points = repository.getPointsInTimeFromUntilInclusive(
          secondPoint.id, fourthPoint.id);

      expect(points, equals([secondPoint, thirdPoint, fourthPoint]));
      },
  );
}
