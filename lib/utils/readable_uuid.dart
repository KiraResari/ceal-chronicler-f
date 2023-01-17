import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'json_serializable.dart';

class ReadableUuid extends JsonSerializable {
  static const Uuid uuidGenerator = Uuid();
  String uuid = uuidGenerator.v4();

  static const String _uuidFieldName = "uuid";

  ReadableUuid();

  ReadableUuid.fromJson(Map<String, dynamic> json)
      : uuid = json[_uuidFieldName];

  ReadableUuid.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  @override
  Map<String, dynamic> toJson() => {
        _uuidFieldName: uuid,
      };

  static const List<String> _adjectives = [
    "Alert",
    "Bold",
    "Calm",
    "Dull",
    "Easy",
    "Funny",
    "Great",
    "Hot",
    "Ill",
    "Jolly",
    "Kinky",
    "Lazy",
    "Mad",
    "Nice",
    "Old",
    "Pale",
    "Quaint",
    "Red",
    "Sad",
    "Tame",
    "Ugly",
    "Vain",
    "Weak",
    "Xany",
    "Yummy",
    "Zesty"
  ];
  static const List<String> _animals = [
    "Ape",
    "Bear",
    "Cat",
    "Dog",
    "Eel",
    "Fox",
    "Goat",
    "Horse",
    "Ibex",
    "Jay",
    "Koala",
    "Lynx",
    "Mouse",
    "Newt",
    "Owl",
    "Pig",
    "Quail",
    "Rat",
    "Snake",
    "Tiger",
    "Unau",
    "Vole",
    "Whale",
    "Xerus",
    "Yak",
    "Zebra"
  ];
  static const List<String> _letters = [
    "Alpha",
    "Beta",
    "Gamma",
    "Delta",
    "Epsilon",
    "Zeta",
    "Eta",
    "Theta",
    "Iota",
    "Kappa",
    "Lambda",
    "Mu",
    "Nu",
    "Xi",
    "Omicron",
    "Pi",
    "Rho",
    "Sigma",
    "Tau",
    "Upsilon",
    "Phi",
    "Chi",
    "Psi",
    "Omega"
  ];

  String get readableString =>
      "${_determineAdjective()}_${_determineAnimal()}_${_determineLetter()}";

  String _determineAdjective() {
    return _adjectives[uuid.hashCode % _adjectives.length];
  }

  String _determineAnimal() {
    return _animals[(uuid.hashCode / 10).round() % _animals.length];
  }

  String _determineLetter() {
    return _letters[(uuid.hashCode / 100).round() % _letters.length];
  }

  ReadableUuid copy() {
    var copy = ReadableUuid();
    copy.uuid = uuid;
    return copy;
  }

  @override
  String toString() {
    return readableString;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReadableUuid && uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}
