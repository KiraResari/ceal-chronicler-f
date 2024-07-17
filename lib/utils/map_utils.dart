class MapUtils {
  static bool areEqual(Map firstMap, Map secondMap) {
    if (firstMap.length != secondMap.length ||
        firstMap.runtimeType != secondMap.runtimeType) {
      return false;
    }

    for (var key in firstMap.keys) {
      if (!secondMap.containsKey(key) || firstMap[key] != secondMap[key]) {
        return false;
      }
    }

    return true;
  }
}
