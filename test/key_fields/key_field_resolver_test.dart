import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/key_fields/string_key_field.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

late PointInTimeRepository repository;

main() {
  late KeyFieldResolver resolver;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    resolver = KeyFieldResolver();
  });

  test(
    "getCurrentValue should return initial value at first",
    () {
      var initialValue = "Test";
      var keyField = StringKeyField(initialValue);

      expect(resolver.getCurrentValue(keyField), equals(initialValue));
    },
  );

  test(
    "After adding value at current point in time, currentValue should return that value",
    () {
      var keyField = StringKeyField("Test");

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      var newValue = "Test 2";
      keyField.addOrUpdateKeyAtTime(newValue, currentPointInTime);

      expect(resolver.getCurrentValue(keyField), equals(newValue));
    },
  );

  test(
    "If no key exists at current point in time, currentValue should return value of last key before that",
    () {
      var keyField = StringKeyField("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      var newValue = "Test 2";
      keyField.addOrUpdateKeyAtTime(newValue, currentPointInTime);
      repository.activePointInTime = futurePointInTime;

      expect(resolver.getCurrentValue(keyField), equals(newValue));
    },
  );

  test(
    "currentValue should return initial value if active point in time is before any keys",
    () {
      var initialValue = "Test";
      var keyField = StringKeyField(initialValue);
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Test 2", futurePointInTime.id);

      expect(resolver.getCurrentValue(keyField), equals(initialValue));
    },
  );

  test(
    "addOrUpdateKeyAtTime should update value of existing key",
    () {
      var keyField = StringKeyField("Test");

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      keyField.addOrUpdateKeyAtTime("Test 2", currentPointInTime);
      var updatedValue = "Test 3";
      keyField.addOrUpdateKeyAtTime(updatedValue, currentPointInTime);

      expect(resolver.getCurrentValue(keyField), equals(updatedValue));
    },
  );

  test(
    "After deleting key, initial value should be returned as currentValue again",
    () {
      var initialValue = "Test";
      var keyField = StringKeyField(initialValue);

      PointInTimeId currentPointInTime = repository.activePointInTime.id;
      keyField.addOrUpdateKeyAtTime("Test 2", currentPointInTime);
      keyField.deleteKeyAtTime(currentPointInTime);

      expect(resolver.getCurrentValue(keyField), equals(initialValue));
    },
  );

  test(
    "hasNext should return true if key exists after current point in time",
    () {
      var keyField = StringKeyField("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Future Key", futurePointInTime.id);

      expect(resolver.hasNext(keyField), isTrue);
    },
  );

  test(
    "hasNext should return false if no key exists after current point in time",
    () {
      var keyField = StringKeyField("Test");

      expect(resolver.hasNext(keyField), isFalse);
    },
  );

  test(
    "hasPrevious should return true if a previous key exists",
    () {
      PointInTime firstPointInTime = repository.activePointInTime;
      var secondPointInTime = PointInTime("Second Point in Time");
      repository.addAtIndex(1, secondPointInTime);
      repository.activePointInTime = secondPointInTime;
      var keyField = StringKeyField("Test");
      keyField.addOrUpdateKeyAtTime("First Key Value", firstPointInTime.id);
      keyField.addOrUpdateKeyAtTime("Second Key Value", secondPointInTime.id);

      expect(resolver.hasPrevious(keyField), isTrue);
    },
  );

  test(
    "hasPrevious should return false if no previous key exists",
    () {
      var keyField = StringKeyField("Test");

      expect(resolver.hasPrevious(keyField), isFalse);
    },
  );

  test(
    "nextPointInTimeId should return correct PointInTimeId",
    () {
      var keyField = StringKeyField("Test");
      var futurePointInTime = PointInTime("Future Point in Time");
      repository.addAtIndex(1, futurePointInTime);

      keyField.addOrUpdateKeyAtTime("Future Key", futurePointInTime.id);

      expect(
        resolver.getNextPointInTimeId(keyField),
        equals(futurePointInTime.id),
      );
    },
  );

  test(
    "getPreviousPointInTimeId should return correct PointInTimeId if a previous key exists",
    () {
      var keyField = StringKeyField("Test");
      var firstPointInTime = PointInTime("First Point in Time");
      var pastPointInTime = PointInTime("Past Point in Time");
      repository.addAtIndex(0, firstPointInTime);
      repository.addAtIndex(1, pastPointInTime);

      keyField.addOrUpdateKeyAtTime("Test 2", pastPointInTime.id);

      expect(
        resolver.getPreviousPointInTimeId(keyField),
        equals(pastPointInTime.id),
      );
    },
  );

  test(
    "getValueAt should return correct value",
    () {
      var keyField = StringKeyField("Test");
      var futurePoint = PointInTime("Future Point");
      repository.addAtIndex(1, futurePoint);
      var changedValue = "Changed";
      keyField.addOrUpdateKeyAtTime(changedValue, futurePoint.id);

      String? value = resolver.getValueAt(keyField, futurePoint.id);

      expect(value, equals(changedValue));
    },
  );
}
