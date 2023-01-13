import 'package:ceal_chronicler_f/utils/readable_uuid.dart';

class CharacterId {
  var id = ReadableUuid();

  CharacterId();

  CharacterId.from(this.id);

  CharacterId copy() {
    return CharacterId.from(id.copy());
  }

  @override
  String toString() {
    return id.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CharacterId && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
