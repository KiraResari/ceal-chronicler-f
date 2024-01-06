import 'dart:convert';

abstract class JsonSerializable {

  JsonSerializable();

  JsonSerializable.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  //Name convention from dart:convert. Recommended to not change
  JsonSerializable.fromJson(Map<String, dynamic> jsonMap){
    decodeJson(jsonMap);
  }

  decodeJson(Map<String, dynamic> jsonMap);

  //Name mandated by dart:convert. Do NOT rename or `jsonEncode` will fail
  Map<String, dynamic> toJson();

  String toJsonString() => jsonEncode(toJson());
}
