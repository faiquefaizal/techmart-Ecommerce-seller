import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';

String getMaxMinPriceFromVarients(
  List<ProductVarientModel>? varients,
  String key,
) {
  if (varients == null || varients.isEmpty) return "N/A";

  final prices =
      varients
          .map((varient) {
            if (key == "regularPrice") return varient.regularPrice;
            if (key == "sellingPrice") return varient.sellingPrice;
            return null;
          })
          .whereType<int>() // ✅ this removes any nulls safely
          .toList();

  if (prices.isEmpty) return "N/A";

  final minPrice = prices.reduce((a, b) => a < b ? a : b);
  final maxPrice = prices.reduce((a, b) => a > b ? a : b);

  return minPrice == maxPrice ? "₹$minPrice" : "₹$minPrice - ₹$maxPrice";
}

int getTotalStock(List<ProductVarientModel> varients) {
  return varients.map((varient) => varient.quantity).fold(0, (a, b) => a + b);
}
