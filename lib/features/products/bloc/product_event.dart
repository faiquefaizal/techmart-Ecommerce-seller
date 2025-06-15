// techmart_seller/features/products/bloc/product_event.dart

import 'dart:typed_data';
import 'package:techmart_seller/features/products/models/product_model.dart';

abstract class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final ProductModel product;
  // final List<Uint8List> images;
  final List<List<Uint8List>> varientImages;
  AddProductEvent(this.product, this.varientImages);
}

class EditProductEvent extends ProductEvent {
  final ProductModel updatedProduct;
  // final List<Uint8List> newMainImagesBytes; // Newly picked images as bytes
  final List<String>
  oldMainImageUrls; // Original URLs from the product being edited

  EditProductEvent({
    required this.updatedProduct,
    // required this.newMainImagesBytes,
    required this.oldMainImageUrls,
  });
}

class DeleteProductEvent extends ProductEvent {
  final ProductModel product;
  DeleteProductEvent(this.product);
}

class FetchSellerProductsEvent extends ProductEvent {
  final String sellerUid;
  FetchSellerProductsEvent(this.sellerUid);
}
