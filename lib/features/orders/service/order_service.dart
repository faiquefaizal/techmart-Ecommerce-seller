import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techmart_seller/features/authentication/services/authentication_service.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';

class OrderService {
  final CollectionReference _orders = FirebaseFirestore.instance.collection(
    "Orders",
  );
  final CollectionReference _userRef = FirebaseFirestore.instance.collection(
    "Users",
  );
  final CollectionReference _productRef = FirebaseFirestore.instance.collection(
    "Products",
  );
  String? get sellerId {
    return AuthenticationService.sellerId;
  }

  Future<void> updateState(String toset, String id) async {
    try {
      await _orders.doc(id).update({"status": toset});
      //       await _orders.doc(id).update({
      //   "status": toset,
      //   "updatedTime": DateTime.now(),
      // });
      log("status chaged");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<OrderModel>> fetchOrder() {
    final ordersRef =
        _orders
            .where("sellerId", isEqualTo: sellerId)
            .orderBy("createTime", descending: true)
            .snapshots();
    return ordersRef.map(
      (snapshop) =>
          snapshop.docs
              .map(
                (doc) =>
                    OrderModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Future<String?> getUserName(String id) async {
    try {
      final userDoc = await _userRef.doc(id).get();
      if (userDoc.exists) {
        return userDoc.get("name") as String;
      }
      return null;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProductDetailsFromVarient(
    String productId,
    String varientId,
  ) async {
    try {
      final productDoc = await _productRef.doc(productId).get();
      if (!productDoc.exists) {
        log(_productRef.toString());
        log(productDoc.toString());

        log(productId);
        log("doesnt exist");
        return null;
      }
      final varientDoc =
          await _productRef
              .doc(productId)
              .collection("varients")
              .doc(varientId)
              .get();
      if (!productDoc.exists || !varientDoc.exists) {
        log("${productDoc.id},${varientDoc.id}");
        return null;
      }
      final productName = productDoc.get("productName");
      final List<dynamic> imageList = varientDoc.get("variantImageUrls");
      final firstImage = imageList.first;

      return {"ProductName": productName, "VarientImage": firstImage};
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
