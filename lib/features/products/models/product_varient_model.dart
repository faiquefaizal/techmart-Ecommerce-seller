class ProductVarientModel {
  String? variantId;
  Map<String, String?> variantAttributes;
  int quantity;
  int regularPrice;
  int sellingPrice;
  int buyingPrice;
  List<String>? variantImageUrls;

  ProductVarientModel({
    this.variantId,
    required this.buyingPrice,
    required this.quantity,
    required this.regularPrice,
    required this.sellingPrice,
    required this.variantAttributes,
    this.variantImageUrls,
  });

  Map<String, dynamic> toMap() {
    return {
      "varientId": variantId,
      "variantAttributes": variantAttributes,
      "quantity": quantity,
      "regularPrice": regularPrice,
      "sellingPrice": sellingPrice,
      "buyingPrice": buyingPrice,
      "variantImageUrls": variantImageUrls, // <--- ADDED TO toMap()
    };
  }

  factory ProductVarientModel.fromMap(Map<String, dynamic> map) {
    return ProductVarientModel(
      variantId: map["varientId"],
      buyingPrice: map["buyingPrice"],
      quantity: map["quantity"],
      regularPrice: map["regularPrice"],
      sellingPrice: map["sellingPrice"],
      variantAttributes: Map<String, String>.from(
        map["variantAttributes"] ?? {},
      ),
      variantImageUrls:
          (map["variantImageUrls"] as List?)?.map((e) => e.toString()).toList(),
    );
  }
  ProductVarientModel copyWith({
    String? variantId,
    int? buyingPrice,
    int? quantity,
    int? regularPrice,
    int? sellingPrice,
    Map<String, String?>? variantAttributes,
    List<String>? variantImageUrls,
  }) {
    return ProductVarientModel(
      variantId: variantId ?? this.variantId,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      quantity: quantity ?? this.quantity,
      regularPrice: regularPrice ?? this.regularPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      variantAttributes: variantAttributes ?? this.variantAttributes,
      variantImageUrls: variantImageUrls ?? this.variantImageUrls,
    );
  }
}
