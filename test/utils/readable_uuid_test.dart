import 'package:ceal_chronicler_f/utils/readable_uuid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Two new ReadableUuid should not be equal", () {
    var firstId = ReadableUuid();
    var secondId = ReadableUuid();

    expect(firstId, isNot(secondId));
  });
}