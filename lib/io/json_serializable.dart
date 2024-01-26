import 'dart:convert';

abstract class JsonSerializable {

  JsonSerializable();

  Map<String, dynamic> toJson();

  String toJsonString() => jsonEncode(toJson());
}
