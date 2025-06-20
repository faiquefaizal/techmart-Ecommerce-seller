import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';

String getMaxMinPriceFromVarients(
  List<ProductVarientModel> varients,
  String key,
) {
  final prices =
      varients.map((varient) {
        if (key == "regularPrice") return varient.regularPrice;
        if (key == "sellingPrice") return varient.sellingPrice;
        return 0;
      }).toList();

  final minPrice = prices.reduce((a, b) => a < b ? a : b);
  final maxPrice = prices.reduce((a, b) => a > b ? a : b);

  if (minPrice == maxPrice) {
    return minPrice.toString();
  }
  return "$minPrice-$maxPrice";
}

int getTotalStock(List<ProductVarientModel> varients) {
  return varients.map((varient) => varient.quantity).fold(0, (a, b) => a + b);
}
