import 'dart:ui';

import 'package:ceal_chronicler_f/io/file/file_processor.dart';

class FileProcessorMockLite implements FileProcessor {
  @override
  Future<void> save() async {
    //do nothing
  }

  @override
  Future<void> load() async {
    //do nothing
  }

  @override
  void addListener(VoidCallback listener) {
    //do nothing
  }

  @override
  void dispose() {
    //do nothing
  }

  @override
  bool get hasListeners => false;

  @override
  bool get isSavingNecessary => false;

  @override
  void notifyListeners() {
    //do nothing
  }

  @override
  void removeListener(VoidCallback listener) {
    //do nothing
  }
}
