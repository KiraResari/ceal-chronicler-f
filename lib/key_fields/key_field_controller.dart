import '../../../commands/processor_listener.dart';
import '../../../get_it_context.dart';
import '../../../timeline/model/point_in_time_id.dart';
import 'key_field.dart';
import 'key_field_resolver.dart';

class KeyFieldController<T> extends ProcessorListener {
  final KeyField<T> keyField;

  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  KeyFieldController(this.keyField);

  T get currentValue => _keyFieldResolver.getCurrentValue(keyField);

  bool get hasNext => _keyFieldResolver.hasNext(keyField);

  bool get hasPrevious => _keyFieldResolver.hasPrevious(keyField);

  PointInTimeId? get nextPointInTimeId =>
      _keyFieldResolver.getNextPointInTimeId(keyField);

  PointInTimeId getPreviousPointInTimeId(PointInTimeId earliestId) =>
      _keyFieldResolver.getPreviousPointInTimeId(keyField, earliestId);
}
