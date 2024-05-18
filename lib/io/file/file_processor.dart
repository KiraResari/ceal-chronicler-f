import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:flutter/cupertino.dart';

import '../../exceptions/operation_canceled_exception.dart';
import '../../get_it_context.dart';
import '../../message_bar/message_bar_state.dart';
import '../chronicle.dart';
import '../chronicle_codec.dart';
import 'file_adapter.dart';

class FileProcessor extends ChangeNotifier  {
  static const String saveCancelledMessage = "Saving cancelled";
  static const String saveCompletedMessage = "Chronicle saved!";
  static const String loadCancelledMessage = "Loading cancelled";
  static const String loadCompletedMessage = "Loaded chronicle";

  final _chronicleCodec = getIt.get<ChronicleCodec>();
  final _fileAdapter = getIt.get<FileAdapter>();
  final _commandHistory = getIt.get<CommandHistory>();
  final _messageBarState = getIt.get<MessageBarState>();

  Future<void> save() async {
    try {
      Chronicle chronicle = _chronicleCodec.assembleFromRepositories();
      await _fileAdapter.saveChronicle(chronicle);
      _commandHistory.setSavedAtIndexToCurrentIndex();
      _updateStatusMessageAndNotifyListeners(saveCompletedMessage);
    } on OperationCanceledException {
      _updateStatusMessageAndNotifyListeners(saveCancelledMessage);
    }
  }

  Future<void> load() async {
    try {
      Chronicle chronicle = await _fileAdapter.loadChronicle();
      _chronicleCodec.distributeToRepositories(chronicle);
      _commandHistory.resetHistoryAndIndexes();
      _updateStatusMessageAndNotifyListeners(loadCompletedMessage);
    } on OperationCanceledException {
      _updateStatusMessageAndNotifyListeners(loadCancelledMessage);
      throw OperationCanceledException();
    }
  }

  bool get isSavingNecessary => _commandHistory.isSavingNecessary;

  void _updateStatusMessageAndNotifyListeners(String message) {
    _messageBarState.statusMessage = message;
    notifyListeners();
  }
}
