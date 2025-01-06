import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/parties/model/party_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/utils/model/attribute.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Parsing Character to JSON and back should return equal object",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded, equals(original));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve first appearance",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.firstAppearance, equals(original.firstAppearance));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve name",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.name, equals(original.name));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve last appearance if not set",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve last appearance if set",
    () {
      var original = Character(PointInTimeId());
      original.lastAppearance = PointInTimeId();

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.lastAppearance, equals(original.lastAppearance));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve present location if not set",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.presentLocation, equals(original.presentLocation));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve present location if set",
    () {
      var original = Character(PointInTimeId());
      original.presentLocation
          .addOrUpdateKeyAtTime(LocationId(), PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.presentLocation, equals(original.presentLocation));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve party if not set",
    () {
      var original = Character(PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.party, equals(original.party));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve party if set",
    () {
      var original = Character(PointInTimeId());
      original.party.addOrUpdateKeyAtTime(PartyId(), PointInTimeId());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.party, equals(original.party));
    },
  );

  test(
    "Parsing Character to JSON and back should preserve attributes",
    () {
      var original = Character(PointInTimeId());
      original.attributes.add(Attribute());

      String jsonString = original.toJsonString();
      var decoded = Character.fromJsonString(jsonString);

      expect(decoded.attributes.length, equals(1));
    },
  );
}
