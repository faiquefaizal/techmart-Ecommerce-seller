// techmart_seller/features/products/services/product_service.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:techmart_seller/features/products/models/catagory_model.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart'; // Ensure this is imported

class ProductService {
  final CollectionReference _productRef = FirebaseFirestore.instance.collection(
    "Products",
  );
  final userUid = FirebaseAuth.instance.currentUser?.uid;
  static const cloudName = "dmkamtddy";
  static const cloudPreset = "flutter_uploads";
  static const cloudApiKey = "956275761217399";
  static const cloudApiSecretKey = "qHxukWJjglp4g3MpP1tPCgf2m0Q";
  static final categoriesRef = FirebaseFirestore.instance.collection(
    "Catagory",
  );

  static final brandsRef = FirebaseFirestore.instance.collection("Brands");
  Future<String?> sendImageToCloudinary(Uint8List image) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request =
          http.MultipartRequest("POST", url)
            ..fields["upload_preset"] = cloudPreset
            ..files.add(
              http.MultipartFile.fromBytes(
                "file",
                image,
                filename:
                    "product_${DateTime.now().millisecondsSinceEpoch}.jpg",
              ),
            );
      final response = await request.send();
      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        return jsonDecode(resBody)["secure_url"];
      } else {
        log("Cloudinary upload failed with status: ${response.statusCode}");
        final resBody = await response.stream.bytesToString();
        log("Cloudinary error response: $resBody");
        return null;
      }
    } catch (e) {
      log("Error sending image to Cloudinary: $e");
      return null;
    }
  }

  Future<List<String>> uploadImages(List<Uint8List> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      final url = await sendImageToCloudinary(image);
      if (url != null) {
        imageUrls.add(url);
      } else {
        throw "Failed to upload some images";
      }
    }
    return imageUrls;
  }

  /// Fetch products filtered by seller UID (for display on seller's product list)
  Stream<List<ProductModel>> fetchProductsBySeller() {
    return _productRef
        .where("sellerUid", isEqualTo: userUid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => ProductModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
        );
  }

  Future<List<ProductVarientModel>> uploadVariantImagesAndGetModels(
    List<ProductVarientModel> variants,
    List<List<Uint8List>> rawVariantImagesList,
  ) async {
    // rawVariantImagesList[i] corresponds to variant[i]
    assert(variants.length == rawVariantImagesList.length);

    List<ProductVarientModel> updatedVariants = [];

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final images = rawVariantImagesList[i];

      final imageUrls = await uploadImages(images); // already available

      updatedVariants.add(
        ProductVarientModel(
          buyingPrice: variant.buyingPrice,
          quantity: variant.quantity,
          regularPrice: variant.regularPrice,
          sellingPrice: variant.sellingPrice,
          variantAttributes: variant.variantAttributes,

          variantImageUrls: imageUrls,
        ),
      );
    }

    return updatedVariants;
  }

  /// Add a new product to Firestore
  Future<void> addProduct(
    ProductModel product,
    // List<Uint8List> mainImages,
    List<List<Uint8List>> variantImages, // Add this
  ) async {
    try {
      final docRef = _productRef.doc();
      product.productId = docRef.id;

      // Upload main product images
      // final imageUrls = await uploadImages(mainImages);
      // product.imageUrls = imageUrls;

      // Upload variant images and update variant models
      final updatedVariants = await uploadVariantImagesAndGetModels(
        product.varients,
        variantImages,
      );

      product.varients = updatedVariants;

      await docRef.set(product.toMap());
      log("✅ Product added successfully!");
    } catch (e) {
      log("❌ Error adding product: $e");
      rethrow;
    }
  }

  /// Edit product data, handling image re-upload and deletion
  Future<void> editProduct(
    ProductModel updatedProduct,
    // List<Uint8List> newMainImagesBytes,
    // List<String> oldMainImageUrls,
  ) async {
    try {
      if (updatedProduct.productId == null) {
        throw 'Product ID is required for editing.';
      }

      // 1. Upload new main images
      List<String> uploadedNewMainImageUrls = [];
      // if (newMainImagesBytes.isNotEmpty) {
      //   uploadedNewMainImageUrls = await uploadImages(newMainImagesBytes);
      // }

      // 2. Combine old and new image URLs for the updated product model
      // We are *replacing* the main images list with a new one containing only the selected/newly uploaded ones.
      // This means if user removes an old image from UI and doesn't replace it, it won't be in this new list.
      // updatedProduct.imageUrls = uploadedNewMainImageUrls;

      // 3. Update Firestore document
      await _productRef
          .doc(updatedProduct.productId)
          .update(updatedProduct.toMap());
      log("✅ Product updated successfully!");

      // 4. Delete old main images from Cloudinary (AFTER successful Firestore update)
      // Only delete images that were in the original list but are NOT in the final list
      // Set<String> finalUrlsSet = updatedProduct.imageUrls?.toSet() ?? {};
      // Set<String> oldUrlsSet = oldMainImageUrls.toSet();

      // for (final url in oldUrlsSet) {
      //   if (!finalUrlsSet.contains(url)) {
      //     await _deleteImageFromCloudinary(url);
      //   }
      // }

      // Note: Variant image URLs within updatedProduct.varients are assumed
      // to be already handled (uploaded) by the _addVariant logic on the screen.
      // Deletion of specific old variant images is a complex UI/service task
      // that is beyond the scope of this general edit.
      // When a variant itself is removed from the _productVariants list, its images
      // won't be explicitly deleted here. They will only be deleted when the
      // entire product is deleted via deleteProduct.
    } catch (e) {
      log("❌ Error editing product: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      if (product.productId == null) {
        throw 'Product ID is required for deletion.';
      }

      // Delete main product images
      // if (product.imageUrls != null) {
      //   for (final imageUrl in product.imageUrls!) {
      //     await _deleteImageFromCloudinary(imageUrl);
      //   }
      // }

      // Delete variant-specific images
      for (final variant in product.varients) {
        if (variant.variantImageUrls != null) {
          for (final variantImageUrl in variant.variantImageUrls!) {
            await _deleteImageFromCloudinary(variantImageUrl);
          }
        }
      }

      await _productRef.doc(product.productId).delete();
      log("✅ Product deleted successfully!");
    } catch (e) {
      log("❌ Error deleting product: $e");
      rethrow;
    }
  }

  /// Helper to delete an image from Cloudinary
  Future<void> _deleteImageFromCloudinary(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      String publicId = '';
      final uploadIndex = pathSegments.indexOf(cloudPreset);
      if (uploadIndex != -1 && uploadIndex + 1 < pathSegments.length) {
        // Extract public_id for images uploaded with 'flutter_uploads' preset structure
        publicId =
            pathSegments.sublist(uploadIndex + 1).join('/').split('.').first;
      } else if (pathSegments.isNotEmpty) {
        // Fallback for older/different URL structures (e.g., just filename)
        publicId = pathSegments.last.split('.').first;
      }

      if (publicId.isEmpty) {
        log(
          "Could not extract publicId from URL: $imageUrl, skipping deletion.",
        );
        return;
      }

      final deleteUrl = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/resources/image/destroy",
      );
      final response = await http.post(
        deleteUrl,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$cloudApiKey:$cloudApiSecretKey'))}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"public_id": publicId, "invalidate": true}),
      );

      if (response.statusCode == 200) {
        log("✅ Image deleted from Cloudinary: $publicId");
      } else {
        log(
          "❌ Failed to delete image from Cloudinary: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      log("❌ Error deleting image from Cloudinary: $e");
    }
  }

  static Future<List<CatagoryVarient>> fetchCatagories(String id) async {
    final data = await categoriesRef.doc(id).get();
    final doc = data.data();
    if (doc == null || !doc.containsKey("varientOptions")) {
      log("in funtion: null ${doc.toString()}");
      return [];
    }
    log("in funtion: ${doc["varientOptions"].toString()}");
    return (doc["varientOptions"] as List)
        .map((e) => CatagoryVarient.fromMap(e))
        .toList();
  }
}
