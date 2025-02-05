import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return [];

    final directory = await getApplicationDocumentsDirectory();
    final List<String> savedPaths = [];

    for (var image in images) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${directory.path}/$fileName';
      await File(image.path).copy(savedPath);
      savedPaths.add(savedPath);
    }

    return savedPaths;
  }

  Future<void> deleteImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
