import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';

part 'product_varient_state.dart';

class ProductVarientCubit extends Cubit<ProductVarientState> {
  ProductVarientCubit() : super(ProductVarientInitial());
  final List<ProductVarientModel> _productVarientList = [];
  List<ProductVarientModel> get productVarientList =>
      List.unmodifiable(_productVarientList);
  final List<List<Uint8List>?> _imagesVarientList = [];
  List<List<Uint8List>?> get rawVariantImagesLists =>
      List.unmodifiable(_imagesVarientList);
  final List<List<String>> _imageVarietUrlList = [];
  List<List<String>> get imageProductVarientUrlList =>
      List.unmodifiable(_imageVarietUrlList);

  void addProductVarient(
    ProductVarientModel product,
    List<Uint8List> rawImages,
  ) {
    try {
      _productVarientList.add(product);
      _imagesVarientList.add(rawImages.isEmpty ? null : rawImages);
      _imageVarietUrlList.add(product.variantImageUrls ?? []);
      log("url $_imageVarietUrlList");
      log("local ${_imagesVarientList.length}");
      emit(
        ProductVarintLoaded(
          productVarient: List.from(_productVarientList),
          imageLIst: List.from(_imagesVarientList),
          imageUrlList: List.from(_imageVarietUrlList),
        ),
      );
      log(
        "Added variant: ${_productVarientList.length}, Images: ${_imagesVarientList.length}",
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void fillProductVarient(List<ProductVarientModel> productVairents) {
    try {
      _productVarientList.clear();
      _productVarientList.addAll(productVairents);
      _imagesVarientList.clear();
      _imagesVarientList.addAll(
        List.generate(productVairents.length, (_) => []),
      );
      _imageVarietUrlList.clear();
      _imageVarietUrlList.addAll(
        productVairents.map((varient) => varient.variantImageUrls!),
      );
      emit(
        ProductVarintLoaded(
          productVarient: List.from(_productVarientList),
          imageLIst: List.from(_imagesVarientList),
          imageUrlList: List.from(_imageVarietUrlList),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteProductEvent(int index) {
    try {
      if (_productVarientList.isNotEmpty) {
        _productVarientList.removeAt(index);
        _imagesVarientList.removeAt(index);
        _imageVarietUrlList.removeAt(index);
        emit(
          ProductVarintLoaded(
            productVarient: List.from(_productVarientList),
            imageLIst: List.from(_imagesVarientList),
            imageUrlList: List.from(_imageVarietUrlList),
          ),
        );
      } else {
        emit(ProductVarientInitial());
      }
      ;
    } catch (e) {
      log(e.toString());
    }
  }

  void clearAllVariants() {
    _productVarientList.clear();
    _imagesVarientList.clear();
    _imageVarietUrlList.clear();
    emit(ProductVarientInitial());
  }
}
