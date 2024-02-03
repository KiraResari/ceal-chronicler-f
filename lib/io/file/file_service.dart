import '../../get_it_context.dart';
import '../chronicle.dart';
import '../repository_service.dart';
import 'file_adapter.dart';

class FileService {

  final _repositoryService = getIt.get<RepositoryService>();
  final _fileAdapter = getIt.get<FileAdapter>();

  Future<void> save() async {
    Chronicle chronicle = _repositoryService.assembleChronicle();
    await _fileAdapter.saveChronicle(chronicle);
  }

  Future<void> load() async {
    Chronicle chronicle = await _fileAdapter.loadChronicle();
    _repositoryService.distributeChronicle(chronicle);
  }
}
