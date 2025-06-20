import 'package:techmart_seller/features/products/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductAddedState extends ProductState {}

class ProductEditedState extends ProductState {}

class ProductDeletedState extends ProductState {}

class ProductErrorState extends ProductState {
  final String error;

  ProductErrorState(this.error);
}

// class SellerProductsLoading extends ProductState {}

// class SellerProductsLoaded extends ProductState {
//   final List<ProductModel> products;
//   SellerProductsLoaded(this.products);
// }

// class SellerProductsError extends ProductState {
//   final String message;
//   SellerProductsError(this.message);
// }
