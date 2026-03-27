import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService() {
    _imagePicker = ImagePicker();
  }

  late final ImagePicker _imagePicker;

  Future<Uint8List?> getImageFromCamera() async {
    final file = await _imagePicker.pickImage(source: ImageSource.camera);
    return await file?.readAsBytes();
  }

  Future<String?> getImageFromGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }
}
