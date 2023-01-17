import 'dart:convert';

abstract class JsonSerializable {

  Map<String, dynamic> toJson();
  String toJsonString() => jsonEncode(toJson());
}