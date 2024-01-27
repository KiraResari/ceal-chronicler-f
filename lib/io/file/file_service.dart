import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../exceptions/operation_canceled_exception.dart';
import '../../get_it_context.dart';
import '../chronicle.dart';
import '../repository_service.dart';

class FileService {
  static const saveDialogText = "Choose where to save the Chronicle";
  static const defaultFileName = "chronicle.json";

  final _repositoryService = getIt.get<RepositoryService>();

  Future<void> save() async {
    Chronicle chronicle = _repositoryService.assembleChronicle();
    await _saveChronicle(chronicle);
  }

  Future<void> _saveChronicle(Chronicle chronicle) async {
    String? targetFilePath = await _saveFilePath;
    if (targetFilePath == null) {
      throw OperationCanceledException();
    }
    File file = File(targetFilePath);
    await file.writeAsString(chronicle.toJsonString());
  }

  Future<String?> get _saveFilePath async {
    if (kIsWeb) {
      throw UnimplementedError("Saving is not implemented for web");
    } else if (Platform.isAndroid || Platform.isIOS) {
      return await _mobileSavePath;
    }
    return await FilePicker.platform.saveFile(
      dialogTitle: saveDialogText,
      fileName: defaultFileName,
    );
  }

  Future<String?> get _mobileSavePath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path + defaultFileName;
  }

  Future<void> load() async {}
}
