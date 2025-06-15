// techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:techmart_seller/core/funtion/pick_images/pick_image.dart'; // Ensure correct import

part 'image_state.dart';

class ImageCubit extends Cubit<PickimageState> {
  ImageCubit() : super(PickimageInitial());
  final List<Uint8List> _images = [];
  List<Uint8List> get currentImages => List.unmodifiable(_images);

  // Changed to add a list of picked images
  Future<void> pickImage() async {
    try {
      // Calls the function to pick multiple images
      final pickedImages =
          await pickImagesFunction(); // Changed to pickImagesFunction
      if (pickedImages.isNotEmpty) {
        _images.addAll(pickedImages); // Add all new images to the list
        emit(PickimagePicked(List.from(_images)));
      } else if (_images.isEmpty) {
        // If no new images picked and list was empty, keep initial state
        emit(PickimageInitial());
      } else {
        // If no new images picked but list already has images, remain in picked state
        emit(PickimagePicked(List.from(_images)));
      }
    } catch (e) {
      emit(PickimageError(e.toString()));
    }
  }

  void removeImage(int index) {
    // Changed index type to int for clarity
    _images.removeAt(index);
    if (_images.isEmpty) {
      emit(PickimageInitial());
    } else {
      emit(PickimagePicked(List.from(_images)));
    }
  }

  void clearImage() {
    _images.clear();
    emit(PickimageInitial());
  }
}
