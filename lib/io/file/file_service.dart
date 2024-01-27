import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../exceptions/operation_canceled_exception.dart';
import '../../get_it_context.dart';
import '../chronicle.dart';
import '../repository_service.dart';

class FileService {
  static const saveDialogText = "Save chronicle";
  static const loadDialogText = "Load chronicle";
  static const defaultFileName = "ceal";
  static const fileExtension = "chronicle";

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
      allowedExtensions: [fileExtension],
      type: FileType.custom,
      dialogTitle: saveDialogText,
      fileName: "$defaultFileName.$fileExtension",
    );
  }

  Future<String> get _mobileSavePath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return "${directory.path}$defaultFileName.$fileExtension";
  }

  Future<void> load() async {
    Chronicle chronicle = await _loadChronicle();
    _repositoryService.distributeChronicle(chronicle);
  }

  Future<Chronicle> _loadChronicle() async {
    String path = await _getLoadFilePath();
    File file = File(path);
    String content = await file.readAsString();
    return Chronicle.fromJsonString(content);
  }

  Future<String> _getLoadFilePath() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _mobileSavePath;
    }
    return await _getLoadFilePathFromFilePicker();
  }

  Future<String> _getLoadFilePathFromFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [fileExtension],
      type: FileType.custom,
      dialogTitle: loadDialogText,
    );
    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        return path;
      }
    }
    throw OperationCanceledException();
  }
}
