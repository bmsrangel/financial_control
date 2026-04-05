import 'dart:convert';

import 'package:flutter/material.dart';

import 'services/image_picker_service.dart';
import 'stores/ai_store.dart';
import 'stores/google_sheets_store.dart';
import 'stores/model_download_store.dart';
import 'stores/ocr_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
    required this.imagePickerService,
    required this.aiStore,
    required this.downloadStore,
    required this.ocrStore,
    required this.googleSheetsStore,
  });

  final String title;
  final ImagePickerService imagePickerService;
  final AiStore aiStore;
  final ModelDownloadStore downloadStore;
  final OcrStore ocrStore;
  final GoogleSheetsStore googleSheetsStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AiStore get _aiStore => widget.aiStore;
  ModelDownloadStore get _downloadStore => widget.downloadStore;
  OcrStore get _ocrStore => widget.ocrStore;
  GoogleSheetsStore get _googleSheetsStore => widget.googleSheetsStore;

  @override
  void initState() {
    super.initState();
    _downloadStore.addListener(isModelDownloadedListener);
    _downloadStore.downloadModel();
  }

  @override
  void dispose() {
    _downloadStore.removeListener(isModelDownloadedListener);
    _aiStore.closeAi();
    super.dispose();
  }

  void isModelDownloadedListener() {
    if (_downloadStore.isModelDownloaded) {
      _aiStore.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _downloadStore,
          builder: (_, _) {
            if (_downloadStore.isLoading) {
              return CircularProgressIndicator();
            } else {
              if (_downloadStore.isModelDownloaded) {
                return Column(
                  mainAxisAlignment: .center,
                  children: [
                    AnimatedBuilder(
                      animation: _aiStore,
                      builder: (_, _) {
                        if (_aiStore.isLoading) {
                          return CircularProgressIndicator();
                        } else {
                          return Text(jsonEncode(_aiStore.responseMap));
                          // return Text(jsonEncode(_aiStore.responseMap));
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Text(
                  'Downloading model: ${_downloadStore.progress.toStringAsFixed(2)}%',
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: Column(
        spacing: 16.0,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _ocrStore.isLoading || _aiStore.isLoading
                ? null
                : () async {
                    final ocrText = await _ocrStore.extractOrcFromCamera();
                    if (ocrText != null) {
                      await _aiStore.generateResponse(ocrText);
                      await _googleSheetsStore.addDataToSheet(
                        _aiStore.responseMap,
                      );
                    }
                  },
            tooltip: 'Camera',
            heroTag: 'Camera',
            child: const Icon(Icons.camera),
          ),
          FloatingActionButton(
            onPressed: _ocrStore.isLoading || _aiStore.isLoading
                ? null
                : () async {
                    final ocrText = await _ocrStore.extractOcrFromGallery();
                    if (ocrText != null) {
                      await _aiStore.generateResponse(ocrText);
                      await _googleSheetsStore.addDataToSheet(
                        _aiStore.responseMap,
                      );
                    }
                  },
            tooltip: 'Gallery',
            heroTag: 'Gallery',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
