// techmart_seller/features/products/bloc/product_bloc.dart

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/products/bloc/product_event.dart';
import 'package:techmart_seller/features/products/bloc/product_state.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;

  ProductBloc(this._productService) : super(ProductInitial()) {
    on<AddProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        await _productService.addProduct(
          event.product,
          // event.images,
          event.varientImages,
        );
        log(event.product.productId!);
        emit(ProductAddedState());
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });

    on<EditProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        await _productService.editProduct(
          event.updatedProduct,
          event.newVarientList,
          // event.newMainImagesBytes, // Pass new image bytes
          // event.oldMainImageUrls, // Pass old image URLs for deletion comparison
        );

        emit(ProductEditedState());
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        await _productService.deleteProduct(event.product);
        emit(ProductDeletedState());
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });

    // on<FetchSellerProductsEvent>((event, emit) async {
    //   emit(SellerProductsLoading());
    //   try {
    //     await emit.forEach(
    //       _productService.fetchProductsBySeller(),
    //       onData: (products) => SellerProductsLoaded(products),
    //       onError: (error, stackTrace) => SellerProductsError(error.toString()),
    //     );
    //   } catch (e) {
    //     emit(SellerProductsError(e.toString()));
    //   }
    // });
  }
}
