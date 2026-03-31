import 'dart:convert';

import 'package:finance_control/src/ai_store.dart';
import 'package:finance_control/src/image_picker_service.dart';
import 'package:finance_control/src/model_download_store.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    _imagePickerService.getImageFromCamera().then((path) async {
      if (path != null) {
        final inputImage = InputImage.fromFilePath(path);

        final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );
        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );

        String text = recognizedText.text;
        _aiStore.generateResponse(text);
        textRecognizer.close();
      }
    });
  }

  final ImagePickerService _imagePickerService = ImagePickerService();
  final ModelDownloadStore _downloadStore = ModelDownloadStore();
  late final AiStore _aiStore = AiStore();

  @override
  void initState() {
    super.initState();
    _downloadStore.downloadModel();
    _downloadStore.addListener(isModelDownloadedListener);
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
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              _imagePickerService.getImageFromGallery().then((path) async {
                if (path != null) {
                  final inputImage = InputImage.fromFilePath(path);

                  final textRecognizer = TextRecognizer(
                    script: TextRecognitionScript.latin,
                  );
                  final RecognizedText recognizedText = await textRecognizer
                      .processImage(inputImage);

                  String text = recognizedText.text;
                  _aiStore.generateResponse(text);
                  textRecognizer.close();
                }
              });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.browse_gallery),
          ),
        ],
      ),
    );
  }
}
