import '../../commands/processor_listener.dart';

class ReorderableListController<T extends Object> extends ProcessorListener {
  final T attribute;
  final List<T> list;

  ReorderableListController(this.list, this.attribute);

  bool get canAttributeBeMovedUp =>
      list.contains(attribute) && list.first != attribute;

  bool get canAttributeBeMovedDown =>
      list.contains(attribute) && list.last != attribute;
}
