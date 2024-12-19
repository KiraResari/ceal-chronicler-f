import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Location to JSON and back should return equal object",
    () {
      var original = Location(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Location.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );

  test(
    "Parsing Location to JSON and back should preserve first appearance",
        () {
      var original = Location(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Location.fromJsonString(jsonString);

      expect(decoded.firstAppearance, equals(original.firstAppearance));
    },
  );

  test(
    "Parsing Location to JSON and back should preserve name",
        () {
      var original = Location(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Location.fromJsonString(jsonString);

      expect(decoded.name, equals(original.name));
    },
  );

  test(
    "Parsing Location to JSON and back should preserve last appearance if not set",
        () {
      var original = Location(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Location.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );

  test(
    "Parsing Location to JSON and back should preserve last appearance if set",
        () {
      var original = Location(PointInTimeId());
      original.lastAppearance = PointInTimeId();

      String jsonString = original.toJsonString();
      var decoded = Location.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );
}
