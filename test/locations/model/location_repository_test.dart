import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late LocationRepository repository;
  setUp(() {
    repository = LocationRepository();
  });

  test("Newly created repository should be empty", () {
    expect(repository.content.length, equals(0));
  });

  test("Adding new location should work", () {
    var location = Location(PointInTimeId());
    repository.add(location);

    expect(repository.content.length, equals(1));
  });

  test("Removing location should work", () {
    var location = Location(PointInTimeId());
    repository.add(location);
    var characterToBeRemoved = repository.content.first;

    repository.remove(characterToBeRemoved);

    expect(repository.content, isNot(contains(characterToBeRemoved)));
  });
}
