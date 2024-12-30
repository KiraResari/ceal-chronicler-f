import 'package:ceal_chronicler_f/key_fields/party_id_key_field.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing PartyIdKeyField with null value should work",
    () {
      var original = PartyIdKeyField();
      original.addOrUpdateKeyAtTime(null, PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = PartyIdKeyField.fromJsonString(jsonString);

      expect(original, equals(decoded));
    },
  );
}
