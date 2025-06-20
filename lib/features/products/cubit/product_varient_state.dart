part of 'product_varient_cubit.dart';

@immutable
sealed class ProductVarientState {}

final class ProductVarientInitial extends ProductVarientState {}

final class ProductVarintLoaded extends ProductVarientState {
  List<ProductVarientModel> productVarient;
  List<List<String>> imageUrlList;
  List<List<Uint8List>?> imageLIst;
  ProductVarintLoaded({
    required this.productVarient,
    required this.imageUrlList,
    required this.imageLIst,
  });
}

// final class ProductVarintUpdatedLoaded extends ProductVarientState {
//   List<ProductVarientModel> productVarient;
//   List<List<String>> imageUrlList;
//   List<List<Uint8List>> imageLIst;
//   ProductVarintUpdatedLoaded({
//     required this.productVarient,
//     required this.imageUrlList,
//     required this.imageLIst,
//   });
// }
