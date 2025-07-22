import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:techmart_seller/features/products/models/catagory_varient_model.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/utils/generate_firestore_id.dart';

class ProductService {
  static final CollectionReference _productRef = FirebaseFirestore.instance
      .collection("Products");
  static final userUid = FirebaseAuth.instance.currentUser?.uid ?? "hello";
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

  Future<List<String>> uploadImages(List<Uint8List>? images) async {
    if (images == null || images.isEmpty) {
      return [];
    }
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

  static Stream<List<ProductModel>> fetchProductsBySeller() {
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
    List<List<Uint8List>?> rawVariantImagesList,
  ) async {
    assert(
      variants.length == rawVariantImagesList.length,
      'Variants and image lists must have the same length',
    );

    List<ProductVarientModel> updatedVariants = [];

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final images = rawVariantImagesList[i];

      // Preserve existing image URLs if no new images are provided
      final imageUrls =
          images != null && images.isNotEmpty
              ? await uploadImages(images)
              : variant.variantImageUrls ?? [];

      updatedVariants.add(variant.copyWith(variantImageUrls: imageUrls));
    }

    return updatedVariants;
  }

  /// Add a new product to Firestore
  Future<void> addProduct(
    ProductModel product,
    List<ProductVarientModel> varients,
    List<List<Uint8List>?>? rawVariantImagesLists, // Add this
  ) async {
    try {
      final docRef = _productRef;
      int minPrice = varients
          .map((v) => v.regularPrice)
          .reduce((a, b) => a < b ? a : b);
      int maxPrice = varients
          .map((v) => v.regularPrice)
          .reduce((a, b) => a > b ? a : b);
      product.productId = generateFirestoreId();
      product.minPrice = minPrice;
      product.maxPrice = maxPrice;

      log("product Id${product.productId.toString()}");
      await docRef.doc(product.productId).set(product.toMap());

      if (rawVariantImagesLists != null && rawVariantImagesLists.isNotEmpty) {
        for (var i = 0; i < varients.length; i++) {
          final varient = varients[i];
          final rawImages = rawVariantImagesLists[i];
          List<String> imageUrl =
              rawImages != null ? await uploadImages(rawImages) : [];
          String varientId = generateFirestoreId();
          docRef
              .doc(product.productId)
              .collection("varients")
              .doc(varientId)
              .set(
                varient
                    .copyWith(variantId: varientId, variantImageUrls: imageUrl)
                    .toMap(),
              );
        }
      }

      log("product Id${product.toString()}");
      assert(
        product.productId != null && product.productId!.isNotEmpty,
        "productI os null",
      );
      await _productRef.doc(product.productId).set(product.toMap());
      log("Product added successfully!");
    } catch (e) {
      log("Error adding product: $e");
      rethrow;
    }
  }

  /// Edit product data, handling image re-upload and deletion
  Future<void> editProduct(
    ProductModel updatedProduct,
    List<ProductVarientModel> varientList,
    List<List<Uint8List>?>? rawVariantImagesLists,
  ) async {
    try {
      if (updatedProduct.productId == null) {
        throw 'Product ID is required for editing.';
      }

      final productDocRef = _productRef.doc(updatedProduct.productId);
      final varientDocRef = productDocRef.collection("varients");
      int minPrice = varientList
          .map((v) => v.regularPrice)
          .reduce((a, b) => a < b ? a : b);
      int maxPrice = varientList
          .map((v) => v.regularPrice)
          .reduce((a, b) => a > b ? a : b);
      updatedProduct.maxPrice = maxPrice;
      updatedProduct.minPrice = minPrice;
      await productDocRef.update(updatedProduct.toMap());

      final existingSnopt = await varientDocRef.get();
      final existingVarients =
          existingSnopt.docs
              .map((varient) => ProductVarientModel.fromMap(varient.data()))
              .toList();

      final exitingId =
          existingVarients.map((v) => v.variantId).whereType<String>().toSet();
      final updatedIds =
          varientList.map((v) => v.variantId).whereType<String>().toSet();

      for (var i = 0; i < varientList.length; i++) {
        final varient = varientList[i];
        if (varient.variantId != null &&
            exitingId.contains(varient.variantId)) {
          continue;
        }
        final rawImages =
            rawVariantImagesLists != null ? rawVariantImagesLists[i] : null;
        final List<String> ImageUrls =
            rawImages != null && rawImages.isNotEmpty
                ? await uploadImages(rawImages)
                : [];

        final varientId = generateFirestoreId();

        final newVarient = varient.copyWith(
          variantId: varientId,
          variantImageUrls: ImageUrls,
        );

        varientDocRef.doc(newVarient.variantId).set(newVarient.toMap());
      }
      for (var element in existingVarients) {
        if (!updatedIds.contains(element.variantId)) {
          await varientDocRef.doc(element.variantId).delete();
          log("varietn deleted");
          continue;
        }
        if (element.variantImageUrls != null) {
          for (var image in element.variantImageUrls!) {
            await _deleteImageFromCloudinary(image);
          }
        }
      }
      log("Product and variants updated successfully.");
      // Fetch the existing product to preserve unchanged variants
    } catch (e) {
      log(" Error editing product: $e");
      rethrow;
    }
  }

  Future<List<ProductVarientModel>> _updateVariantsWithImages(
    List<ProductVarientModel> existingVariants,
    List<ProductVarientModel> updatedVariants,
    List<List<Uint8List>?> rawVariantImagesLists,
  ) async {
    assert(
      updatedVariants.length == rawVariantImagesLists.length,
      'Updated variants and image lists must have the same length',
    );

    List<ProductVarientModel> result = [];

    for (int i = 0; i < updatedVariants.length; i++) {
      final updatedVariant = updatedVariants[i];
      final images = rawVariantImagesLists[i];
      final existingVariant = existingVariants.firstWhere(
        (ev) => ev.variantAttributes == updatedVariant.variantAttributes,
        orElse: () => updatedVariant, // New variant if not found
      );

      final imageUrls =
          images != null && images.isNotEmpty
              ? await uploadImages(images)
              : existingVariant.variantImageUrls ?? [];

      result.add(updatedVariant.copyWith(variantImageUrls: imageUrls));
    }

    return result;
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      if (product.productId == null) {
        throw 'Product ID is required for deletion.';
      }

      final productDocRef = _productRef.doc(product.productId);
      final variantCollectionRef = productDocRef.collection('varients');

      // 1. Fetch all variants
      final variantSnapshot = await variantCollectionRef.get();

      for (final doc in variantSnapshot.docs) {
        final variant = ProductVarientModel.fromMap(doc.data());

        // 2. Delete images from Cloudinary
        if (variant.variantImageUrls != null) {
          for (final imageUrl in variant.variantImageUrls!) {
            await _deleteImageFromCloudinary(imageUrl);
          }
        }

        // 3. Delete variant doc
        await doc.reference.delete();
        log("🗑️ Variant deleted: ${variant.variantId}");
      }

      await productDocRef.delete();
      log("Product deleted successfully!");
    } catch (e) {
      log(" Error deleting product: $e");
      rethrow;
    }
  }

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
        log(" Image deleted from Cloudinary: $publicId");
      } else {
        log(
          " Failed to delete image from Cloudinary: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      log(" Error deleting image from Cloudinary: $e");
    }
  }

  static Future<List<ProductVarientModel>> fetchVarientsByProductId(
    String productId,
  ) async {
    final varientsSnap =
        await _productRef.doc(productId).collection("varients").get();
    return varientsSnap.docs
        .map((doc) => ProductVarientModel.fromMap(doc.data()))
        .toList();
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

  static Future<String> getCataagaryNameById(String id) async {
    return await categoriesRef
        .doc(id)
        .get()
        .then((doc) => CatagoryVarient.catagoryFromMap(doc.data()!).name);
  }

  static Future<String> getBrandNameById(String id) async {
    return await brandsRef.doc(id).get().then((doc) => doc["name"]);
  }
}
