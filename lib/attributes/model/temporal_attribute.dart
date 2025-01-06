import 'dart:convert';

import '../../key_fields/string_key_field.dart';
import '../../utils/model/id_holder.dart';
import 'temporal_attribute_id.dart';

class TemporalAttribute extends IdHolder<TemporalAttributeId> {
  static const String labelKey = "label";
  static const String valueKey = "name";

  String label = "Attribute";
  var value = StringKeyField("New attribute");

  TemporalAttribute() : super(TemporalAttributeId());

  TemporalAttribute.fromJsonString(String jsonString)
      : this.fromJson(jsonDecode(jsonString));

  TemporalAttribute.fromJson(Map<String, dynamic> json)
      : label = json[labelKey] ?? "",
        value = StringKeyField.fromJson(json[valueKey]),
        super(TemporalAttributeId.fromString(json[IdHolder.idKey]));

  String get identifierDescription => valueKey;

  @override
  String toString() => 'Temporal Attribute{id: $id, label: $label, name: $value}';

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        labelKey: label,
        valueKey: value,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemporalAttribute && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
