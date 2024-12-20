import 'package:ceal_chronicler_f/key_fields/location_id_key_field.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing LocationIdKeyField with null value should work",
    () {
      var original = LocationIdKeyField();
      original.addOrUpdateKeyAtTime(null, PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = LocationIdKeyField.fromJsonString(jsonString);

      expect(original, equals(decoded));
    },
  );
}
