import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/io/chronicle.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';

class FileAdapterMock implements FileAdapter {
  String? savedChronicle;

  @override
  Future<Chronicle> loadChronicle() async {
    if (savedChronicle != null) {
      return Chronicle.fromJsonString(savedChronicle!);
    }
    throw InvalidOperationException(
        "<FileAdaptorMock.loadChronicle> Loading is not possible because now chronicle was saved");
  }

  @override
  Future<void> saveChronicle(Chronicle chronicle) async {
    savedChronicle = chronicle.toJsonString();
  }
}
