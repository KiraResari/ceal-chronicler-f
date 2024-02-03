import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/time_processor.dart';
import 'package:ceal_chronicler_f/timeline/widgets/point_in_time_button_controller.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository repository;
  late TimeProcessor timeProcessor;

  setUp(() {
    getIt.reset();
    repository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(repository);
    timeProcessor = TimeProcessor();
    getIt.registerSingleton<TimeProcessor>(timeProcessor);
  });

  test("Button of initially created PointInTime should be disabled", () {
    PointInTime point = repository.first;

    var controller = PointInTimeButtonController(point);

    expect(controller.isEnabled, isFalse);
  });

  test("Button of additional PointInTime should be enabled", () {
    PointInTime point = repository.createNewAtIndex(0);

    var controller = PointInTimeButtonController(point);

    expect(controller.isEnabled, isTrue);
  });

  test("Pressing button of additional PointInTime should disable it", () {
    PointInTime point = repository.createNewAtIndex(0);

    var controller = PointInTimeButtonController(point);
    controller.activatePointInTime();

    expect(controller.isEnabled, isFalse);
  });

  test(
    "Pressing button of additional PointInTime should make that point the active point in time",
    () {
      PointInTime point = repository.createNewAtIndex(0);

      var controller = PointInTimeButtonController(point);
      controller.activatePointInTime();

      expect(timeProcessor.activePointInTime, equals(point));
    },
  );
}
