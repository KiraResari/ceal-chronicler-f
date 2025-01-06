import 'dart:convert';

import '../../utils/model/id_holder.dart';
import 'attribute_id.dart';

class Attribute extends IdHolder<AttributeId> {
  static const String labelKey = "label";
  static const String nameKey = "name";

  String label = "Attribute";
  String name = "New attribute";

  Attribute() : super(AttributeId());

  Attribute.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  Attribute.fromJson(Map<String, dynamic> json)
      : label = json[labelKey] ?? "",
        name = json[nameKey],
        super(AttributeId.fromString(json[IdHolder.idKey]));

  String get identifier => name;

  String get identifierDescription => nameKey;

  @override
  String toString() => 'Attribute{id: $id, label: $label, name: $name}';

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        labelKey: label,
        nameKey: name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attribute && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
