import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/model/key_fields/string_key_field.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing StringKeyField to JSON and back should return equal object",
    () {
      var original = StringKeyField("Test");
      original.addOrUpdateKeyAtTime("Test 2", PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = StringKeyField.fromJsonString(jsonString);

      expect(original, equals(decoded));
    },
  );
}
