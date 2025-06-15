// techmart_seller/features/products/models/product_model.dart

import 'package:techmart_seller/features/products/models/product_varient_model.dart';

class ProductModel {
  String? productId;
  String productName;
  String productDescription;
  String sellerUid;
  String categoryId;
  String brandId;
  List<String>? imageUrls;
  List<ProductVarientModel> varients;

  ProductModel({
    this.productId,
    required this.brandId,
    required this.categoryId,
    this.imageUrls,
    required this.productDescription,
    required this.productName,
    required this.sellerUid,
    required this.varients,
  });

  Map<String, dynamic> toMap() {
    return {
      "productName": productName,
      "productDescription": productDescription,
      "sellerUid": sellerUid,
      "brandId": brandId,
      "categoryId": categoryId,
      "imageUrls": imageUrls,
      "varients": varients.map((e) => e.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      brandId: map["brandId"], // Corrected: Was map["productName"]
      categoryId: map["categoryId"],
      imageUrls: (map["imageUrls"] as List?)?.map((e) => e.toString()).toList(),
      productDescription: map["productDescription"],
      productName: map["productName"],
      sellerUid: map["sellerUid"],
      varients:
          (map["varients"]
                  as List<dynamic>?) // Firestore reads as List<dynamic>
              ?.map(
                (e) => ProductVarientModel.fromMap(e as Map<String, dynamic>),
              )
              .toList() ??
          [], // Provide empty list if null
    );
  }
}
