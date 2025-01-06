import '../../../../commands/command.dart';
import '../../utils/list_utils.dart';

class MoveAttributeDownCommand<T extends Object> extends Command {
  final T attribute;
  final List<T> list;

  MoveAttributeDownCommand(this.list, this.attribute);

  @override
  void execute() =>
      ListUtils.moveElementTowardsEndOfList(list, attribute);

  @override
  String get executeMessage => "Moved attribute $attribute down";

  @override
  void undo() =>
      ListUtils.moveElementTowardsFrontOfList(list, attribute);

  @override
  String get undoMessage => "Moved attribute $attribute back up";
}
