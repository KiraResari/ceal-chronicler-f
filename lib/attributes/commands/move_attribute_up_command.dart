import '../../../../commands/command.dart';
import '../../utils/list_utils.dart';

class MoveAttributeUpCommand<T extends Object> extends Command {
  final T attribute;
  final List<T> list;

  MoveAttributeUpCommand(this.list, this.attribute);

  @override
  void execute() =>
      ListUtils.moveElementTowardsFrontOfList(list, attribute);

  @override
  String get executeMessage => "Moved attribute $attribute up";

  @override
  void undo() =>
      ListUtils.moveElementTowardsEndOfList(list, attribute);

  @override
  String get undoMessage => "Moved attribute $attribute back down";
}
