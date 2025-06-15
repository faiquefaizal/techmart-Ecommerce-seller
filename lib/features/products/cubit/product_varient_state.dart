part of 'product_varient_cubit.dart';

@immutable
sealed class ProductVarientState {}

final class ProductVarientInitial extends ProductVarientState {}

final class ProductVarintLoaded extends ProductVarientState {
  List<ProductVarientModel> productVarient;
  ProductVarintLoaded({required this.productVarient});
}
