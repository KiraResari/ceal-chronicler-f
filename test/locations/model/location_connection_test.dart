import 'package:ceal_chronicler_f/locations/model/location_connection.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_direction.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing LocationConnection to JSON and back should return equal object",
    () {
      var original = LocationConnection(
        LocationId(),
        LocationConnectionDirection.northwest,
        LocationId(),
      );

      String jsonString = original.toJsonString();
      var decoded = LocationConnection.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );
}
