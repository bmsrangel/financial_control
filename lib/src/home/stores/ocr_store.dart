import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/image_picker_service.dart';

class OcrStore extends ChangeNotifier {
  OcrStore(this._imagePickerService);

  final ImagePickerService _imagePickerService;

  bool isLoading = false;

  Future<String?> extractOrcFromCamera() async {
    isLoading = true;
    notifyListeners();
    final path = await _imagePickerService.getImageFromCamera();
    if (path != null) {
      final inputImage = InputImage.fromFilePath(path);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      String text = recognizedText.text;
      textRecognizer.close();
      isLoading = false;
      notifyListeners();
      return text;
    }
    isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> extractOcrFromGallery() async {
    isLoading = true;
    notifyListeners();
    final path = await _imagePickerService.getImageFromGallery();
    if (path != null) {
      final inputImage = InputImage.fromFilePath(path);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      String text = recognizedText.text;
      textRecognizer.close();
      isLoading = false;
      notifyListeners();
      return text;
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
}
