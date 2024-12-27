import 'package:ceal_chronicler_f/locations/model/location_connection.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late LocationConnectionRepository repository;
  setUp(() {
    repository = LocationConnectionRepository();
  });

  test("Newly created repository should be empty", () {
    expect(repository.content.length, equals(0));
  });

  test("Adding new location connection should work", () {
    var connection = LocationConnection(
      LocationId(),
      LocationConnectionDirection.northwest,
      LocationId(),
    );
    repository.add(connection);

    expect(repository.content.length, equals(1));
  });

  test("Removing location connection should work", () {
    var connection = LocationConnection(
      LocationId(),
      LocationConnectionDirection.northwest,
      LocationId(),
    );
    repository.add(connection);
    var itemToBeRemoved = repository.content.first;

    repository.remove(itemToBeRemoved);

    expect(repository.content, isNot(contains(itemToBeRemoved)));
  });
}
