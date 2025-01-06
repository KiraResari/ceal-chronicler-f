import 'package:ceal_chronicler_f/attributes/model/attribute.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Attribute to JSON and back should return equal object",
    () {
      var original = Attribute();

      String jsonString = original.toJsonString();
      var decoded = Attribute.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );

  test(
    "Parsing Attribute to JSON and back should preserve name",
        () {
      var original = Attribute();
      original.name = "Some name";

      String jsonString = original.toJsonString();
      var decoded = Attribute.fromJsonString(jsonString);

      expect(decoded.name, equals(original.name));
    },
  );

  test(
    "Parsing Attribute to JSON and back should preserve label",
        () {
      var original = Attribute();
      original.label = "Some label";

      String jsonString = original.toJsonString();
      var decoded = Attribute.fromJsonString(jsonString);

      expect(decoded.label, equals(original.label));
    },
  );
}
