// // techmart_seller/features/products/services/product_service.dart

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:techmart_seller/features/products/models/catagory_varient_model.dart';
// import 'package:techmart_seller/features/products/models/product_model.dart';
// import 'package:techmart_seller/features/products/models/product_varient_model.dart'; // Ensure this is imported

// class ProductService {
//   static final CollectionReference _productRef = FirebaseFirestore.instance
//       .collection("Products");
//   static final userUid = FirebaseAuth.instance.currentUser?.uid ?? "hello";
//   static const cloudName = "dmkamtddy";
//   static const cloudPreset = "flutter_uploads";
//   static const cloudApiKey = "956275761217399";
//   static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";
//   static final categoriesRef = FirebaseFirestore.instance.collection(
//     "Catagory",
//   );

//   static final brandsRef = FirebaseFirestore.instance.collection("Brands");
//   Future<String?> sendImageToCloudinary(Uint8List image) async {
//     try {
//       final url = Uri.parse(
//         "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
//       );
//       final request =
//           http.MultipartRequest("POST", url)
//             ..fields["upload_preset"] = cloudPreset
//             ..files.add(
//               http.MultipartFile.fromBytes(
//                 "file",
//                 image,
//                 filename:
//                     "product_${DateTime.now().millisecondsSinceEpoch}.jpg",
//               ),
//             );
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final resBody = await response.stream.bytesToString();
//         return jsonDecode(resBody)["secure_url"];
//       } else {
//         log("Cloudinary upload failed with status: ${response.statusCode}");
//         final resBody = await response.stream.bytesToString();
//         log("Cloudinary error response: $resBody");
//         return null;
//       }
//     } catch (e) {
//       log("Error sending image to Cloudinary: $e");
//       return null;
//     }
//   }

//   Future<List<String>> uploadImages(List<Uint8List>? images) async {
//     if (images == null || images.isEmpty) {
//       return [];
//     }
//     List<String> imageUrls = [];

//     for (var image in images) {
//       final url = await sendImageToCloudinary(image);
//       if (url != null) {
//         imageUrls.add(url);
//       } else {
//         throw "Failed to upload some images";
//       }
//     }
//     return imageUrls;
//   }

//   /// Fetch products filtered by seller UID (for display on seller's product list)
//   static Stream<List<ProductModel>> fetchProductsBySeller() {
//     return _productRef
//         .where("sellerUid", isEqualTo: userUid)
//         .snapshots()
//         .map(
//           (snapshot) =>
//               snapshot.docs
//                   .map(
//                     (doc) => ProductModel.fromMap(
//                       doc.data() as Map<String, dynamic>,
//                     ),
//                   )
//                   .toList(),
//         );
//   }

//   Future<List<ProductVarientModel>> uploadVariantImagesAndGetModels(
//     List<ProductVarientModel> variants,
//     List<List<Uint8List>?> rawVariantImagesList,
//   ) async {
//     assert(
//       variants.length == rawVariantImagesList.length,
//       'Variants and image lists must have the same length',
//     );

//     List<ProductVarientModel> updatedVariants = [];

//     for (int i = 0; i < variants.length; i++) {
//       final variant = variants[i];
//       final images = rawVariantImagesList[i];

//       // Preserve existing image URLs if no new images are provided
//       final imageUrls =
//           images != null && images.isNotEmpty
//               ? await uploadImages(images)
//               : variant.variantImageUrls ?? [];

//       updatedVariants.add(variant.copyWith(variantImageUrls: imageUrls));
//     }

//     return updatedVariants;
//   }

//   /// Add a new product to Firestore
//   Future<void> addProduct(
//     ProductModel product,
//     // List<Uint8List> mainImages,
//     List<List<Uint8List>?>? rawVariantImagesLists, // Add this
//   ) async {
//     try {
//       final docRef = _productRef.doc();
//       product.productId = docRef.id;
//       log("product Id${product.productId.toString()}");
//       // Upload main product images
//       // final imageUrls = await uploadImages(mainImages);
//       // product.imageUrls = imageUrls;

//       // Upload variant images and update variant models
//       List<ProductVarientModel> updatedVariants = product.varients;
//       if (rawVariantImagesLists != null && rawVariantImagesLists.isNotEmpty) {
//         updatedVariants = await uploadVariantImagesAndGetModels(
//           product.varients,
//           rawVariantImagesLists,
//         );
//       }

//       product.varients = updatedVariants;
//       log("product Id${product.toString()}");
//       assert(
//         product.productId != null && product.productId!.isNotEmpty,
//         "productI os null",
//       );
//       await _productRef.doc(product.productId).set(product.toMap());
//       log("✅ Product added successfully!");
//     } catch (e) {
//       log("❌ Error adding product: $e");
//       rethrow;
//     }
//   }

//   /// Edit product data, handling image re-upload and deletion
//   Future<void> editProduct(
//     ProductModel updatedProduct,
//     List<ProductVarientModel> updatedvarientalist,
//     List<List<Uint8List>?>? rawVariantImagesLists,
//   ) async {
//     try {
//       if (updatedProduct.productId == null) {
//         throw 'Product ID is required for editing.';
//       }

//       // Fetch the existing product to preserve unchanged variants
//       final existingProductDoc =
//           await _productRef.doc(updatedProduct.productId).get();
//       final existingProduct = ProductModel.fromMap(
//         existingProductDoc.data() as Map<String, dynamic>,
//       );

//       List<ProductVarientModel> updatedVariants = updatedProduct.varients;
//       if (rawVariantImagesLists != null && rawVariantImagesLists.isNotEmpty) {
//         // Match existing variants with new image data based on attributes
//         updatedVariants = await _updateVariantsWithImages(
//           existingProduct.varients,
//           updatedProduct.varients,
//           rawVariantImagesLists,
//         );
//       } else {
//         // No new images provided, retain existing images
//         updatedVariants =
//             updatedProduct.varients.map((variant) {
//               final existingVariant = existingProduct.varients.firstWhere(
//                 (ev) => ev.variantAttributes == variant.variantAttributes,
//                 orElse: () => variant,
//               );
//               return variant.copyWith(
//                 variantImageUrls: existingVariant.variantImageUrls ?? [],
//               );
//             }).toList();
//       }

//       final finalProduct = updatedProduct.copyWith(varients: updatedVariants);
//       await _productRef
//           .doc(finalProduct.productId)
//           .update(finalProduct.toMap());
//       log("✅ Product updated successfully!");
//     } catch (e) {
//       log("❌ Error editing product: $e");
//       rethrow;
//     }
//   }

//   Future<List<ProductVarientModel>> _updateVariantsWithImages(
//     List<ProductVarientModel> existingVariants,
//     List<ProductVarientModel> updatedVariants,
//     List<List<Uint8List>?> rawVariantImagesLists,
//   ) async {
//     assert(
//       updatedVariants.length == rawVariantImagesLists.length,
//       'Updated variants and image lists must have the same length',
//     );

//     List<ProductVarientModel> result = [];

//     for (int i = 0; i < updatedVariants.length; i++) {
//       final updatedVariant = updatedVariants[i];
//       final images = rawVariantImagesLists[i];
//       final existingVariant = existingVariants.firstWhere(
//         (ev) => ev.variantAttributes == updatedVariant.variantAttributes,
//         orElse: () => updatedVariant, // New variant if not found
//       );

//       final imageUrls =
//           images != null && images.isNotEmpty
//               ? await uploadImages(images)
//               : existingVariant.variantImageUrls ?? [];

//       result.add(updatedVariant.copyWith(variantImageUrls: imageUrls));
//     }

//     return result;
//   }

//   Future<void> deleteProduct(ProductModel product) async {
//     try {
//       if (product.productId == null) {
//         throw 'Product ID is required for deletion.';
//       }

//       // Delete main product images
//       // if (product.imageUrls != null) {
//       //   for (final imageUrl in product.imageUrls!) {
//       //     await _deleteImageFromCloudinary(imageUrl);
//       //   }
//       // }

//       // Delete variant-specific images
//       for (final variant in product.varients) {
//         if (variant.variantImageUrls != null) {
//           for (final variantImageUrl in variant.variantImageUrls!) {
//             await _deleteImageFromCloudinary(variantImageUrl);
//           }
//         }
//       }

//       await _productRef.doc(product.productId).delete();
//       log("✅ Product deleted successfully!");
//     } catch (e) {
//       log("❌ Error deleting product: $e");
//       rethrow;
//     }
//   }

//   /// Helper to delete an image from Cloudinary
//   Future<void> _deleteImageFromCloudinary(String imageUrl) async {
//     try {
//       final uri = Uri.parse(imageUrl);
//       final pathSegments = uri.pathSegments;

//       String publicId = '';
//       final uploadIndex = pathSegments.indexOf(cloudPreset);
//       if (uploadIndex != -1 && uploadIndex + 1 < pathSegments.length) {
//         // Extract public_id for images uploaded with 'flutter_uploads' preset structure
//         publicId =
//             pathSegments.sublist(uploadIndex + 1).join('/').split('.').first;
//       } else if (pathSegments.isNotEmpty) {
//         // Fallback for older/different URL structures (e.g., just filename)
//         publicId = pathSegments.last.split('.').first;
//       }

//       if (publicId.isEmpty) {
//         log(
//           "Could not extract publicId from URL: $imageUrl, skipping deletion.",
//         );
//         return;
//       }

//       final deleteUrl = Uri.parse(
//         "https://api.cloudinary.com/v1_1/$cloudName/resources/image/destroy",
//       );
//       final response = await http.post(
//         deleteUrl,
//         headers: {
//           "Authorization":
//               "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({"public_id": publicId, "invalidate": true}),
//       );

//       if (response.statusCode == 200) {
//         log("✅ Image deleted from Cloudinary: $publicId");
//       } else {
//         log(
//           "❌ Failed to delete image from Cloudinary: ${response.statusCode} - ${response.body}",
//         );
//       }
//     } catch (e) {
//       log("❌ Error deleting image from Cloudinary: $e");
//     }
//   }

//   static Future<List<CatagoryVarient>> fetchCatagories(String id) async {
//     final data = await categoriesRef.doc(id).get();
//     final doc = data.data();
//     if (doc == null || !doc.containsKey("varientOptions")) {
//       log("in funtion: null ${doc.toString()}");
//       return [];
//     }
//     log("in funtion: ${doc["varientOptions"].toString()}");
//     return (doc["varientOptions"] as List)
//         .map((e) => CatagoryVarient.fromMap(e))
//         .toList();
//   }

//   static Future<String> getCataagaryNameById(String id) async {
//     return await categoriesRef
//         .doc(id)
//         .get()
//         .then((doc) => CatagoryVarient.catagoryFromMap(doc.data()!).name);
//   }

//   static Future<String> getBrandNameById(String id) async {
//     return await brandsRef.doc(id).get().then((doc) => doc["name"]);
//   }
// }

// // ✅ Refactored ProductService for Firestore subcollection structure

// // import 'dart:convert';
// // import 'dart:developer';
// // import 'dart:typed_data';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:techmart_seller/features/products/models/catagory_varient_model.dart';
// // import 'package:techmart_seller/features/products/models/product_model.dart';
// // import 'package:techmart_seller/features/products/models/product_varient_model.dart';

// // class ProductService {
// //   static final CollectionReference _productRef = FirebaseFirestore.instance.collection("Products");
// //   static final userUid = FirebaseAuth.instance.currentUser?.uid ?? "hello";
// //   static const cloudName = "dmkamtddy";
// //   static const cloudPreset = "flutter_uploads";
// //   static const cloudApiKey = "956275761217399";
// //   static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";
// //   static final categoriesRef = FirebaseFirestore.instance.collection("Catagory");
// //   static final brandsRef = FirebaseFirestore.instance.collection("Brands");

// //   Future<String?> sendImageToCloudinary(Uint8List image) async {
// //     try {
// //       final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
// //       final request = http.MultipartRequest("POST", url)
// //         ..fields["upload_preset"] = cloudPreset
// //         ..files.add(http.MultipartFile.fromBytes("file", image, filename: "product_\${DateTime.now().millisecondsSinceEpoch}.jpg"));

// //       final response = await request.send();
// //       if (response.statusCode == 200) {
// //         final resBody = await response.stream.bytesToString();
// //         return jsonDecode(resBody)["secure_url"];
// //       } else {
// //         log("Cloudinary upload failed with status: \${response.statusCode}");
// //         return null;
// //       }
// //     } catch (e) {
// //       log("Error sending image to Cloudinary: $e");
// //       return null;
// //     }
// //   }

// //   Future<List<String>> uploadImages(List<Uint8List>? images) async {
// //     if (images == null || images.isEmpty) return [];

// //     List<String> urls = [];
// //     for (var img in images) {
// //       final url = await sendImageToCloudinary(img);
// //       if (url != null) {
// //         urls.add(url);
// //       } else {
// //         throw Exception("Image upload failed");
// //       }
// //     }
// //     return urls;
// //   }

// //   Future<void> addProduct(ProductModel product, List<ProductVarientModel> variants, List<List<Uint8List>?>? rawVariantImagesLists) async {
// //     try {
// //       final docRef = _productRef.doc();
// //       product.productId = docRef.id;

// //       await docRef.set(product.toMap(includeVariants: false));

// //       if (rawVariantImagesLists != null && rawVariantImagesLists.isNotEmpty) {
// //         for (int i = 0; i < variants.length; i++) {
// //           final variant = variants[i];
// //           final rawImages = rawVariantImagesLists[i];

// //           final imageUrls = rawImages != null ? await uploadImages(rawImages) : [];
// //           final variantId = FirebaseFirestore.instance.collection("_temp").doc().id;

// //           await docRef.collection("variants").doc(variantId).set(
// //             variant.copyWith(variantId: variantId, variantImageUrls: imageUrls).toMap(),
// //           );
// //         }
// //       }

// //       log("✅ Product added with variants as subcollection");
// //     } catch (e) {
// //       log("❌ Error adding product: $e");
// //       rethrow;
// //     }
// //   }

// //   Future<void> editProduct(ProductModel product, List<ProductVarientModel> variants, List<List<Uint8List>?>? rawVariantImagesLists) async {
// //     try {
// //       if (product.productId == null) throw "Product ID required";

// //       final productRef = _productRef.doc(product.productId);
// //       await productRef.update(product.toMap(includeVariants: false));

// //       final variantsCollection = productRef.collection("variants");
// //       final snapshot = await variantsCollection.get();

// //       for (var doc in snapshot.docs) {
// //         await doc.reference.delete();
// //       }

// //       for (int i = 0; i < variants.length; i++) {
// //         final variant = variants[i];
// //         final rawImages = rawVariantImagesLists?[i];

// //         final imageUrls = rawImages != null ? await uploadImages(rawImages) : [];
// //         final variantId = FirebaseFirestore.instance.collection("_temp").doc().id;

// //         await variantsCollection.doc(variantId).set(
// //           variant.copyWith(variantId: variantId, variantImageUrls: imageUrls).toMap(),
// //         );
// //       }

// //       log("✅ Product updated with variant subcollection");
// //     } catch (e) {
// //       log("❌ Error updating product: $e");
// //       rethrow;
// //     }
// //   }

// //   Future<void> deleteProduct(ProductModel product) async {
// //     try {
// //       if (product.productId == null) throw "Missing product ID";

// //       final productRef = _productRef.doc(product.productId);

// //       final variantSnap = await productRef.collection("variants").get();
// //       for (var doc in variantSnap.docs) {
// //         final data = doc.data();
// //         final urls = List<String>.from(data["variantImageUrls"] ?? []);
// //         for (final url in urls) {
// //           await _deleteImageFromCloudinary(url);
// //         }
// //         await doc.reference.delete();
// //       }

// //       await productRef.delete();
// //       log("✅ Product and variants deleted");
// //     } catch (e) {
// //       log("❌ Deletion failed: $e");
// //       rethrow;
// //     }
// //   }

// //   Future<void> _deleteImageFromCloudinary(String imageUrl) async {
// //     try {
// //       final uri = Uri.parse(imageUrl);
// //       final pathSegments = uri.pathSegments;

// //       String publicId = '';
// //       final uploadIndex = pathSegments.indexOf(cloudPreset);
// //       if (uploadIndex != -1 && uploadIndex + 1 < pathSegments.length) {
// //         publicId = pathSegments.sublist(uploadIndex + 1).join('/').split('.').first;
// //       } else if (pathSegments.isNotEmpty) {
// //         publicId = pathSegments.last.split('.').first;
// //       }

// //       if (publicId.isEmpty) return;

// //       final deleteUrl = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/resources/image/destroy");
// //       final response = await http.post(
// //         deleteUrl,
// //         headers: {
// //           "Authorization": "Basic \${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
// //           "Content-Type": "application/json",
// //         },
// //         body: jsonEncode({"public_id": publicId, "invalidate": true}),
// //       );

// //       if (response.statusCode == 200) {
// //         log("✅ Image deleted: $publicId");
// //       } else {
// //         log("❌ Cloudinary deletion failed: \${response.body}");
// //       }
// //     } catch (e) {
// //       log("❌ Image deletion error: $e");
// //     }
// //   }

// //   static Future<List<CatagoryVarient>> fetchCatagories(String id) async {
// //     final doc = await categoriesRef.doc(id).get();
// //     if (!doc.exists || !(doc.data()?.containsKey("varientOptions") ?? false)) return [];
// //     return (doc.data()!["varientOptions"] as List).map((e) => CatagoryVarient.fromMap(e)).toList();
// //   }

// //   static Future<String> getCataagaryNameById(String id) async {
// //     final doc = await categoriesRef.doc(id).get();
// //     return CatagoryVarient.catagoryFromMap(doc.data()!).name;
// //   }

// //   static Future<String> getBrandNameById(String id) async {
// //     final doc = await brandsRef.doc(id).get();
// //     return doc["name"];
// //   }
// // }
