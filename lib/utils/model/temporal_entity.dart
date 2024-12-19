import '../../key_fields/key_field_info.dart';
import '../../key_fields/string_key_field.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../utils/model/id_holder.dart';
import '../readable_uuid.dart';

abstract class TemporalEntity<T extends ReadableUuid> extends IdHolder<T> {
  static const String nameKey = "name";
  static const String firstApperanceKey = "firstAppearance";
  static const String lastApperanceKey = "lastAppearance";

  StringKeyField name;
  PointInTimeId firstAppearance;
  PointInTimeId? lastAppearance;

  TemporalEntity(String nameString, T id, this.firstAppearance)
      : name = StringKeyField(nameString),
        super(id);

  TemporalEntity.fromJson(Map<String, dynamic> json, T id)
      : name = StringKeyField.fromJson(json[nameKey]),
        firstAppearance = PointInTimeId.fromJson(json[firstApperanceKey]),
        lastAppearance = _determineLastAppearanceFromJson(json),
        super(id);

  static PointInTimeId? _determineLastAppearanceFromJson(
      Map<String, dynamic> json) {
    if (json[lastApperanceKey] == null) {
      return null;
    }
    return PointInTimeId.fromJson(json[lastApperanceKey]);
  }

  @override
  Map<String, dynamic> toJson() => {
        IdHolder.idKey: id.uuid,
        nameKey: name,
        firstApperanceKey: firstAppearance,
        lastApperanceKey: lastAppearance,
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
      keyFieldInfos.add(KeyFieldInfo<String>(nameKey, pointId, nameValue));
    }
    return keyFieldInfos;
  }
}
