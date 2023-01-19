import 'dart:convert';

abstract class JsonSerializable {

  JsonSerializable();

  JsonSerializable.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  JsonSerializable.fromJson(Map<String, dynamic> jsonMap){
    decodeJson(jsonMap);
  }

  decodeJson(Map<String, dynamic> jsonMap);

  Map<String, dynamic> toJson();

  String toJsonString() => jsonEncode(toJson());
}
