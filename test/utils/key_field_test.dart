import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/model/key_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';

late PointInTimeRepository repository;

main() {
  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
  });

  test(
    "currentValue should return initial value at first",
    () {
      var initialValue = "Test";
      var keyField = KeyField<String>(initialValue);

      expect(keyField.currentValue, equals(initialValue));
    },
  );

  test(
    "After adding value at current point in time, currentValue should return that value",
    () {
      var keyField = KeyField<String>("Test");

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      var newValue = "Test 2";
      keyField.addOrUpdateKeyAtTime(newValue, currentPointInTime);

      expect(keyField.currentValue, equals(newValue));
    },
  );

  test(
    "If no key exists at current point in time, currentValue should return value of last key before that",
    () {
      var keyField = KeyField<String>("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      var newValue = "Test 2";
      keyField.addOrUpdateKeyAtTime(newValue, currentPointInTime);
      repository.activePointInTime = futurePointInTime;

      expect(keyField.currentValue, equals(newValue));
    },
  );

  test(
    "currentValue should return initial value if active point in time is before any keys",
    () {
      var initialValue = "Test";
      var keyField = KeyField<String>(initialValue);
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Test 2", futurePointInTime.id);

      expect(keyField.currentValue, equals(initialValue));
    },
  );

  test(
    "addOrUpdateKeyAtTime should update value of existing key",
    () {
      var keyField = KeyField<String>("Test");

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      keyField.addOrUpdateKeyAtTime("Test 2", currentPointInTime);
      var updatedValue = "Test 3";
      keyField.addOrUpdateKeyAtTime(updatedValue, currentPointInTime);

      expect(keyField.currentValue, equals(updatedValue));
    },
  );

  test(
    "After deleting key, initial value should be returned as currentValue again",
    () {
      var initialValue = "Test";
      var keyField = KeyField<String>(initialValue);

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      keyField.addOrUpdateKeyAtTime("Test 2", currentPointInTime);
      keyField.deleteKeyAtTime(currentPointInTime);

      expect(keyField.currentValue, equals(initialValue));
    },
  );

  test(
    "hasNext should return true if key exists after current point in time",
    () {
      var keyField = KeyField<String>("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Future Key", futurePointInTime.id);

      expect(keyField.hasNext, isTrue);
    },
  );

  test(
    "hasNext should return false if no key exists after current point in time",
    () {
      var keyField = KeyField<String>("Test");

      expect(keyField.hasNext, isFalse);
    },
  );

  test(
    "hasPrevious should return true if a previous key or initial value exists",
    () {
      var keyField = KeyField<String>("Test");
      var pointInTime = PointInTime("Current Point in Time");
      repository.addAtIndex(1, pointInTime);
      repository.activePointInTime = pointInTime;

      keyField.addOrUpdateKeyAtTime("Test 2", pointInTime.id);

      expect(keyField.hasPrevious, isTrue);
    },
  );

  test(
    "hasPrevious should return false if no previous key or initial value exists",
    () {
      var keyField = KeyField<String>("Test");

      expect(keyField.hasPrevious, isFalse);
    },
  );

  test(
    "nextPointInTimeId should return correct PointInTimeId",
    () {
      var keyField = KeyField<String>("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Future Key", futurePointInTime.id);

      expect(keyField.nextPointInTimeId, equals(futurePointInTime.id));
    },
  );

  test(
    "getPreviousPointInTimeId should return correct PointInTimeId if a previous key exists",
    () {
      var keyField = KeyField<String>("Test");
      var firstPointInTime = PointInTime("First Point in Time");
      var pastPointInTime = PointInTime("Past Point in Time");
      repository.addAtIndex(0, firstPointInTime);
      repository.addAtIndex(1, pastPointInTime);

      keyField.addOrUpdateKeyAtTime("Test 2", pastPointInTime.id);

      expect(
        keyField.getPreviousPointInTimeId(firstPointInTime.id),
        equals(pastPointInTime.id),
      );
    },
  );

  test(
    "getPreviousPointInTimeId should return PointInTimeId of earliestId if no previous key exists",
        () {
      var keyField = KeyField<String>("Test");
      var firstPointInTime = PointInTime("First Point in Time");
      repository.addAtIndex(0, firstPointInTime);

      expect(
        keyField.getPreviousPointInTimeId(firstPointInTime.id),
        equals(firstPointInTime.id),
      );
    },
  );
}
