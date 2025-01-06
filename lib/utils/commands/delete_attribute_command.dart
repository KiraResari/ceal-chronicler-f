import '../../commands/command.dart';
import '../model/attribute.dart';
import '../model/temporal_entity.dart';

class DeleteAttributeCommand extends Command {
  final Attribute attribute;
  int? deletedIndex;
  final TemporalEntity entity;

  DeleteAttributeCommand(this.entity, this.attribute);

  @override
  void execute() {
    deletedIndex = entity.attributes.indexOf(attribute);
    entity.attributes.remove(attribute);
  }

  @override
  String get executeMessage => "Removed attribute '${attribute.name}'";

  @override
  void undo() {
    deletedIndex == null
        ? entity.attributes.add(attribute)
        : entity.attributes.insert(deletedIndex!, attribute);
  }

  @override
  String get undoMessage => "Restored deleted attribute '${attribute.name}'";
}
