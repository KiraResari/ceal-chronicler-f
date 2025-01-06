import 'package:ceal_chronicler_f/attributes/model/temporal_attribute.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Temporal Attribute to JSON and back should return equal object",
    () {
      var original = TemporalAttribute();

      String jsonString = original.toJsonString();
      var decoded = TemporalAttribute.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );

  test(
    "Parsing Temporal Attribute to JSON and back should preserve name",
        () {
      var original = TemporalAttribute();
      original.value.addOrUpdateKeyAtTime("New Value", PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = TemporalAttribute.fromJsonString(jsonString);

      expect(decoded.value, equals(original.value));
    },
  );

  test(
    "Parsing Temporal Attribute to JSON and back should preserve label",
        () {
      var original = TemporalAttribute();
      original.label = "Some label";

      String jsonString = original.toJsonString();
      var decoded = TemporalAttribute.fromJsonString(jsonString);

      expect(decoded.label, equals(original.label));
    },
  );
}
