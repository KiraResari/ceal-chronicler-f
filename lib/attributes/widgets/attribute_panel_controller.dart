import '../../commands/processor_listener.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';

class AttributePanelController extends ProcessorListener {
  final Attribute attribute;
  final TemporalEntity entity;

  AttributePanelController(this.entity, this.attribute);

  bool get canAttributeBeMovedUp =>
      entity.attributes.contains(attribute) &&
      entity.attributes.first != attribute;

  bool get canAttributeBeMovedDown {
    return entity.attributes.contains(attribute) &&
        entity.attributes.last != attribute;
  }
}
