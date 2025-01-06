import '../../../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/temporal_attribute.dart';

class DeleteTemporalAttributeCommand extends Command {
  final resolver = getIt.get<KeyFieldResolver>();

  final TemporalAttribute attribute;
  int? deletedIndex;
  final TemporalEntity entity;

  DeleteTemporalAttributeCommand(this.entity, this.attribute);

  @override
  void execute() {
    deletedIndex = entity.temporalAttributes.indexOf(attribute);
    entity.temporalAttributes.remove(attribute);
  }

  @override
  String get executeMessage => "Removed temporal attribute '$_currentName'";

  @override
  void undo() {
    deletedIndex == null
        ? entity.temporalAttributes.add(attribute)
        : entity.temporalAttributes.insert(deletedIndex!, attribute);
  }

  @override
  String get undoMessage =>
      "Restored deleted temporal attribute '$_currentName'";

  String? get _currentName => resolver.getCurrentValue(attribute.value);
}
