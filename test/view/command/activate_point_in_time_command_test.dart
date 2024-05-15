import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/activate_point_in_time_command.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository repository;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
  });

  test(
    "Execute should activate corresponding point in time",
    () {
      var newPoint = PointInTime("test");
      repository.addAtIndex(0, newPoint);
      var command = ActivatePointInTimeCommand(newPoint.id);

      command.execute();

      expect(repository.activePointInTime, equals(newPoint));
    },
  );

  test(
    "isValid should be true if point exists in repository",
        () {
      var newPoint = PointInTime("test");
      repository.addAtIndex(0, newPoint);
      var command = ActivatePointInTimeCommand(newPoint.id);

      var isValid = command.isValid;

      expect(isValid, isTrue);
    },
  );

  test(
    "isValid should be false if point does not exist in repository",
        () {
      var command = ActivatePointInTimeCommand(PointInTimeId());

      var isValid = command.isValid;

      expect(isValid, isFalse);
    },
  );
}
