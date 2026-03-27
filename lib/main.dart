import 'dart:math';

import 'package:finance_control/src/image_picker_service.dart';
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
  final int _counter = 0;

  void _incrementCounter() {
    _imagePickerService.getImageFromCamera();
  }

  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
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
                  for (TextBlock block in recognizedText.blocks) {
                    final Rect rect = block.boundingBox;
                    final List<Point<int>> cornerPoints = block.cornerPoints;
                    final String text = block.text;
                    final List<String> languages = block.recognizedLanguages;

                    for (TextLine line in block.lines) {
                      // Same getters as TextBlock
                      for (TextElement element in line.elements) {
                        // Same getters as TextBlock
                      }
                    }
                  }
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
