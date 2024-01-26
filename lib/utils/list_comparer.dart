class ListComparer {
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
}
