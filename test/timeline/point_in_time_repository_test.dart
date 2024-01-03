import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("Newly created repository should contain one point in time", () {
    var repository = PointInTimeRepository();

    expect(repository.all.length, equals(1));
  });

  test("Adding a point in time before the default one should work", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(0);

    expect(repository.all.length, equals(2));
    String secondPointName =
        "${PointInTimeRepository.defaultPointInTimeName}${PointInTimeRepository.startingRunningNumber}";
    expect(repository.first.name, equals(secondPointName));
  });

  test("Adding a point in time after the default one should work", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(1);

    expect(repository.all.length, equals(2));
    String secondPointName = PointInTimeRepository.defaultPointInTimeName;
    expect(repository.first.name, equals(secondPointName));
  });

  test("Points in time should have unique names", () {
    var repository = PointInTimeRepository();

    repository.createNewAtIndex(0);

    List<PointInTime> points = repository.all;
    List<String> names = points.map((point) => point.name).toList();
    Set<String> uniqueNames = Set<String>.from(names);
    for (String uniqueName in uniqueNames) {
      names.remove(uniqueName);
    }
    expect(names, isEmpty, reason: 'Duplicate names found: $names');
  });
}
