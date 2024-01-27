import 'package:ceal_chronicler_f/exceptions/invalid_operation_exception.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/chronicle.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';

class FileServiceMock implements FileService {
  final _repositoryService = getIt.get<RepositoryService>();

  Chronicle? savedChronicle;

  @override
  Future<void> save() async {
    savedChronicle = _repositoryService.assembleChronicle();
  }

  @override
  Future<void> load() async {
    if (savedChronicle != null) {
      _repositoryService.distributeChronicle(savedChronicle!);
    } else {
      throw InvalidOperationException(
          "<FileServiceMock.load> loading is possible only after something has been saved to this mock");
    }
  }
}
