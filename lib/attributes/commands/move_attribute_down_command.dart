import '../../../../commands/command.dart';
import '../../utils/list_utils.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';

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
