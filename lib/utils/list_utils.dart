import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';

class ListUtils {
  static bool containEqualElementsInSameOrder(List firstList, List secondList) {
    if (firstList.length != secondList.length) {
      return false;
    }
    for (int i = 0; i < firstList.length; i++) {
      if (firstList[i] != secondList[i]) {
        return false;
      }
    }
    return true;
  }

  static void moveElementTowardsEndOfList<T extends Object>(
    List<T> list,
    T elementToMove,
  ) {
    int currentIndex = _getIndexOrThrowException(list, elementToMove);
    int newIndex = currentIndex + 1;
    _assertElementIsNotAtEndOfList(newIndex, list);
    _repositionElement(list, elementToMove, newIndex);
  }

  static void moveElementTowardsFrontOfList<T extends Object>(
    List<T> list,
    T elementToMove,
  ) {
    int currentIndex = _getIndexOrThrowException(list, elementToMove);
    int newIndex = currentIndex - 1;
    _assertElementIsNotAtStartOfList(newIndex, list);
    _repositionElement(list, elementToMove, newIndex);
  }

  static int _getIndexOrThrowException(List<dynamic> list, elementToMove) {
    int currentIndex = list.indexOf(elementToMove);
    if (currentIndex == -1) {
      throw InvalidOperationException(
          "List did not contain element that should be moved!\n"
          "List: $list\n"
          "Element: $elementToMove");
    }
    return currentIndex;
  }

  static void _assertElementIsNotAtEndOfList(int newIndex, List<dynamic> list) {
    if (newIndex >= list.length) {
      throw InvalidOperationException(
          "Element can't be moved forwards because it is already at the end of the list!");
    }
  }

  static void _assertElementIsNotAtStartOfList(
    int newIndex,
    List<dynamic> list,
  ) {
    if (newIndex >= list.length) {
      throw InvalidOperationException(
          "Element can't be moved backwards because it is already at the start of the list!");
    }
  }

  static void _repositionElement<T extends Object>(
    List<T> list,
    T elementToMove,
    int newIndex,
  ) {
    list.remove(elementToMove);
    list.insert(newIndex, elementToMove);
  }
}
