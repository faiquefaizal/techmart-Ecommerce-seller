import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';

part 'product_varient_state.dart';

class ProductVarientCubit extends Cubit<ProductVarientState> {
  ProductVarientCubit() : super(ProductVarientInitial());
  final List<ProductVarientModel> _productVarientList = [];
  final List<List<Uint8List>> _imagesVarientList = [];
  List<List<Uint8List>> get rawVariantImagesLists =>
      List.unmodifiable(_imagesVarientList);

  void addProductVarient(
    ProductVarientModel product,
    List<Uint8List> rawImages,
  ) {
    try {
      _productVarientList.add(product);
      _imagesVarientList.add(rawImages);

      emit(ProductVarintLoaded(productVarient: List.from(_productVarientList)));
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteProductEvent(int index) {
    try {
      if (_productVarientList.isNotEmpty) {
        _productVarientList.removeAt(index);
        _imagesVarientList.removeAt(index);
        emit(
          ProductVarintLoaded(productVarient: List.from(_productVarientList)),
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
    emit(ProductVarientInitial());
  }
}
