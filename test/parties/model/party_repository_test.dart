import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PartyRepository repository;
  setUp(() {
    repository = PartyRepository();
  });

  test("Newly created repository should be empty", () {
    expect(repository.content.length, equals(0));
  });

  test("Adding new party should work", () {
    var entity = Party(PointInTimeId());
    repository.add(entity);

    expect(repository.content.length, equals(1));
  });

  test("Removing party should work", () {
    var entity = Party(PointInTimeId());
    repository.add(entity);
    var entityToBeRemoved = repository.content.first;

    repository.remove(entityToBeRemoved);

    expect(repository.content, isNot(contains(entityToBeRemoved)));
  });
}
