import 'package:ceal_chronicler_f/utils/readable_uuid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Two new ReadableUuid should not be equal", () {
    var firstId = ReadableUuid();
    var secondId = ReadableUuid();

    expect(firstId, isNot(secondId));
  });

  test("ReadableUuid can be serialized and deserialized", () {
    var originalId = ReadableUuid();

    String uuidString = originalId.uuid;
    var decodedId = ReadableUuid.fromString(uuidString);

    expect(originalId, decodedId);
  });
}