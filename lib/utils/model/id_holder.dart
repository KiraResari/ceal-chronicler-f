import 'package:ceal_chronicler_f/io/json_serializable.dart';

import '../readable_uuid.dart';

abstract class IdHolder<T extends ReadableUuid> extends JsonSerializable {
  static const String idKey = "id";

  final T id;

  IdHolder(this.id);

  String get identifier;

  String get identifierDescription;
}
