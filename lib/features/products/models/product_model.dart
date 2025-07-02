// techmart_seller/features/products/models/product_model.dart

import 'package:techmart_seller/features/products/models/product_varient_model.dart';

class ProductModel {
  String? productId;
  String productName;
  String productDescription;
  String sellerUid;
  String categoryId;
  String brandId;
  int? minPrice;
  int? maxPrice;
  // List<String>? imageUrls;
  // List<ProductVarientModel> varients;

  ProductModel({
    this.productId,
    required this.brandId,
    required this.categoryId,
    // this.imageUrls,
    required this.productDescription,
    required this.productName,
    required this.sellerUid,
    this.minPrice,
    this.maxPrice,
    // required this.varients,
  });

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "productName": productName,
      "productDescription": productDescription,
      "sellerUid": sellerUid,
      "brandId": brandId,
      "categoryId": categoryId,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      // "imageUrls": imageUrls,
      // "varients": varients.map((e) => e.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map["productId"],
      brandId: map["brandId"], // Corrected: Was map["productName"]
      categoryId: map["categoryId"],
      // imageUrls: (map["imageUrls"] as List?)?.map((e) => e.toString()).toList(),
      productDescription: map["productDescription"],
      productName: map["productName"],
      sellerUid: map["sellerUid"],
      minPrice: map["minPrice"],
      maxPrice: map["maxPrice"],
      // varients:
      //     (map["varients"] as List<dynamic>?)
      //         ?.map(
      //           (e) => ProductVarientModel.fromMap(e as Map<String, dynamic>),
      //         )
      //         .toList() ??
      //     [], // Provide empty list if null
    );
  }
  @override
  String toString() {
    return '''
ProductModel(
productId:$productId,
  brandId: $brandId,
  categoryId: $categoryId,
  productDescription: $productDescription,
  productName: $productName,
  sellerUid: $sellerUid,
)''';
  }

  ProductModel copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    String? sellerUid,
    String? categoryId,
    String? brandId,
    // List<String>? imageUrls, // Uncomment this if you start using imageUrls
    // List<ProductVarientModel>? varients,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      sellerUid: sellerUid ?? this.sellerUid,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,

      // imageUrls: imageUrls ?? this.imageUrls, // Uncomment this if you start using imageUrls
    );
  }
}
