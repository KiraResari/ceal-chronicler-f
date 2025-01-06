import '../../../commands/command.dart';
import '../../list_utils.dart';
import '../../model/attribute.dart';
import '../../model/temporal_entity.dart';

class MoveAttributeUpCommand extends Command {
  final Attribute attribute;
  final TemporalEntity entity;

  MoveAttributeUpCommand(this.entity, this.attribute);

  @override
  void execute() =>
      ListUtils.moveElementTowardsFrontOfList(entity.attributes, attribute);

  @override
  String get executeMessage => "Moved attribute ${attribute.name} up";

  @override
  void undo() =>
      ListUtils.moveElementTowardsEndOfList(entity.attributes, attribute);

  @override
  String get undoMessage => "Moved attribute ${attribute.name} back down";
}
