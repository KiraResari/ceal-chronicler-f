import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileReaderWriter {
  final String _fileName;

  FileReaderWriter(this._fileName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/$_fileName");
  }

  write(String string) async {
    final file = await _localFile;
    file.writeAsString(string);
  }

  Future<String> read() async {
    final file = await _localFile;
    return file.readAsString();
  }
}
