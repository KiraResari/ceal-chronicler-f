import '../../../commands/command.dart';
import '../../list_utils.dart';
import '../../model/attribute.dart';
import '../../model/temporal_entity.dart';

class MoveAttributeDownCommand extends Command {
  final Attribute attribute;
  final TemporalEntity entity;

  MoveAttributeDownCommand(this.entity, this.attribute);

  @override
  void execute() =>
      ListUtils.moveElementTowardsEndOfList(entity.attributes, attribute);

  @override
  String get executeMessage => "Moved attribute ${attribute.name} down";

  @override
  void undo() =>
      ListUtils.moveElementTowardsFrontOfList(entity.attributes, attribute);

  @override
  String get undoMessage => "Moved attribute ${attribute.name} back up";
}
