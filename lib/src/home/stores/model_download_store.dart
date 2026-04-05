import 'dart:async';
import 'dart:io';

import 'package:finance_control/src/core/utils/constants.dart';
import 'package:finance_control/src/home/services/model_download_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ModelDownloadStore extends ChangeNotifier {
  ModelDownloadStore(this._modelDownloader);

  final ModelDownloadService _modelDownloader;

  bool isModelDownloaded = false;
  bool isDownloadInProgress = false;
  bool isLoading = false;
  double progress = 0;
  StreamSubscription<double>? progressStream;
  String? error;

  // TODO: implement resume logic, in case download is interrupted by internet connection or app is closed
  Future<void> downloadModel() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final modelDirectory = await getApplicationSupportDirectory();
    final modelDirectoryPath = modelDirectory.path;
    final modelPath = join(modelDirectoryPath, modelName);
    isLoading = false;
    notifyListeners();
    final doesModelExist = await File(modelPath).exists();
    if (doesModelExist) {
      isModelDownloaded = true;
      notifyListeners();
    } else {
      isDownloadInProgress = true;
      notifyListeners();
      progressStream = _modelDownloader
          .downloadModel(modelPath)
          .listen(
            (data) {
              progress = data;
              notifyListeners();
            },
            onError: (e) {
              error = 'Failed to download model: ${e.toString()}';
              isDownloadInProgress = false;
              notifyListeners();
            },
            onDone: () {
              if (error != null) {
                isModelDownloaded = true;
              }
              progressStream = null;
              isDownloadInProgress = false;
              notifyListeners();
            },
          );
    }
  }
}
