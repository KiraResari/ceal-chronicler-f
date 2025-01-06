import 'package:ceal_chronicler_f/attributes/model/attribute.dart';

import '../../key_fields/key_field_info.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../readable_uuid.dart';

abstract class TemporalEntity<T extends ReadableUuid> extends IdHolder<T> {
  static const String _nameKey = "name";
  static const String _firstApperanceKey = "firstAppearance";
  static const String _lastApperanceKey = "lastAppearance";
  static const String _attributesKey = "attributes";

  final StringKeyField name;
  PointInTimeId firstAppearance;
  PointInTimeId? lastAppearance;
  final List<Attribute> attributes;

  TemporalEntity(String nameString, T id, this.firstAppearance)
      : name = StringKeyField(nameString),
        attributes = [],
        super(id);

  TemporalEntity.fromJson(Map<String, dynamic> json, T id)
      : name = StringKeyField.fromJson(json[_nameKey]),
        firstAppearance = PointInTimeId.fromJson(json[_firstApperanceKey]),
        lastAppearance = _determineLastAppearanceFromJson(json),
        attributes = _determineAttributesFromJson(json),
        super(id);

  static PointInTimeId? _determineLastAppearanceFromJson(
    Map<String, dynamic> json,
  ) {
    if (json[_lastApperanceKey] == null) {
      return null;
    }
    return PointInTimeId.fromJson(json[_lastApperanceKey]);
  }

  static List<Attribute> _determineAttributesFromJson(
    Map<String, dynamic> json,
  ) {
    var jsonAttributes = json[_attributesKey];
    if (jsonAttributes == null) {
      return [];
    }
    return jsonAttributes.map<Attribute>((e) => Attribute.fromJson(e)).toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        _nameKey: name,
        _firstApperanceKey: firstAppearance,
        _lastApperanceKey: lastAppearance,
        _attributesKey: attributes,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemporalEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  List<KeyFieldInfo> getKeyInfosAt(PointInTimeId pointId) {
    List<KeyFieldInfo> keyFieldInfos = [];
    var nameValue = name.keys[pointId];
    if (nameValue != null) {
      keyFieldInfos.add(KeyFieldInfo<String>(_nameKey, pointId, nameValue));
    }
    return keyFieldInfos;
  }
}
