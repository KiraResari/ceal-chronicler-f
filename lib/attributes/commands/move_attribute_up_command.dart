import '../../../../commands/command.dart';
import '../../utils/list_utils.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';

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
