import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Point in Time to JSON and back should return equal object",
    () {
      var originalPoint = PointInTime("Test");

      String jsonString = originalPoint.toJsonString();
      var decodedPoint = PointInTime.fromJsonString(jsonString);

      expect(decodedPoint, equals(originalPoint));
    },
  );
}
