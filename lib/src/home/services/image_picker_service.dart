import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService() {
    _imagePicker = ImagePicker();
  }

  late final ImagePicker _imagePicker;

  Future<String?> getImageFromCamera() async {
    final file = await _imagePicker.pickImage(source: ImageSource.camera);
    return file?.path;
  }

  Future<String?> getImageFromGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }
}
