// techmart_seller/core/funtion/pick_images/pick_image.dart

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<List<Uint8List>> pickImagesFunction() async {
  // Changed name and return type
  final picker = ImagePicker();
  final List<XFile> images =
      await picker.pickMultiImage(); // Use pickMultiImage
  List<Uint8List> imageBytesList = [];
  for (XFile image in images) {
    imageBytesList.add(await image.readAsBytes());
  }
  return imageBytesList;
}

// Your ImageCubit will need adjustment to use this new function.
// This means the ImageCubit needs to support adding a list of images.
// Let's modify ImageCubit to call this new function.
