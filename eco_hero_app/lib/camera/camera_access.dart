import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

class CameraAccess {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    if (kIsWeb) {
      return _pickImageWeb();
    } else {
      // For mobile, use the ImagePicker for camera access
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return await pickedFile.readAsBytes();
      }
    }
    return null;
  }

  Future<Uint8List?> _pickImageWeb() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.setAttribute('capture', 'camera');
    uploadInput.click();

    await uploadInput.onChange.first;

    if (uploadInput.files!.isEmpty) return null;
    final html.File file = uploadInput.files!.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    return reader.result as Uint8List?;
  }
}
