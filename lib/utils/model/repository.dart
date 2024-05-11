import 'package:ceal_chronicler_f/utils/model/id_holder.dart';

import '../../exceptions/invalid_operation_exception.dart';
import '../readable_uuid.dart';

abstract class Repository<T extends ReadableUuid, U extends IdHolder<T>> {
  Map<T, U> _content = {};

  List<U> get content => _content.values.toList();

  set content(List<U> contentElements) {
    _content = {};
    for (U contentElement in contentElements) {
      add(contentElement);
    }
  }

  void add(U contentElement) {
    _content[contentElement.id] = contentElement;
  }

  void remove(U contentElement) {
    _assertExistsInRepository(contentElement);
    _content.remove(contentElement.id);
  }

  void _assertExistsInRepository(U contentElement) {
    if (!content.contains(contentElement)) {
      throw InvalidOperationException(
          "Repository does not contain content element with ${contentElement.identifierDescription} ${contentElement.identifier}");
    }
  }

  List<U> getContentElementsById(List<T> ids) {
    List<U> contentElements = [];
    for (T id in ids) {
      U? contentElement = _content[id];
      if (contentElement != null) {
        contentElements.add(contentElement);
      }
    }
    return contentElements;
  }

  U? getContentElementById(T id) => _content[id];
}
