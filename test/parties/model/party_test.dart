import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Party to JSON and back should return equal object",
    () {
      var original = Party(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve first appearance",
    () {
      var original = Party(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.firstAppearance, equals(original.firstAppearance));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve name",
    () {
      var original = Party(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.name, equals(original.name));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve last appearance if not set",
    () {
      var original = Party(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve last appearance if set",
    () {
      var original = Party(PointInTimeId());
      original.lastAppearance = PointInTimeId();

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve present location if not set",
        () {
      var original = Party(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.presentLocation, equals(original.presentLocation));
    },
  );

  test(
    "Parsing Party to JSON and back should preserve present location if set",
        () {
      var original = Party(PointInTimeId());
      original.presentLocation
          .addOrUpdateKeyAtTime(LocationId(), PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Party.fromJsonString(jsonString);

      expect(decoded.presentLocation, equals(original.presentLocation));
    },
  );
}
