import 'dart:async';

import 'package:dio/dio.dart';

class ModelDownloader {
  ModelDownloader() {
    _dio = Dio();
  }

  late final Dio _dio;

  Stream<double> downloadModel(String modelPath) {
    final controller = StreamController<double>();
    _dio
        .download(
          'https://github.com/bmsrangel/financial_control/releases/download/v1.0.0-model/gemma3-1B-it-int4.task',
          modelPath,
          onReceiveProgress: (count, total) {
            if (total != -1) {
              controller.add(count / total * 100);
            }
          },
        )
        .then((_) {
          controller.close();
        })
        .catchError((e) {
          controller.addError(e);
          controller.close();
        });
    return controller.stream;
  }
}
