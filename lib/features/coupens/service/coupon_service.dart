import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';
import 'package:techmart_seller/features/products/utils/generate_firestore_id.dart';

class CouponService {
  final _couponRef = FirebaseFirestore.instance.collection("seller_coupons");

  final userUid =
      FirebaseAuth.instance.currentUser?.uid ?? "9qB4tLAvyQhMJgeYHNBaTM2K9uy1";
  addCoupon(SellerCouponModel coupon) async {
    final name = coupon.couponName;
    final id = generateFirestoreId();
    if (await checkCoupenExist(name)) {
      throw Exception("Coupoun Already Exist");
    }
    final updatedCoupon = coupon.copyWith(id: id, sellerId: userUid);
    await _couponRef.doc(updatedCoupon.id).set(updatedCoupon.toMap());
  }

  Future<void> updateCoupon(SellerCouponModel coupon) async {
    log(coupon.id ?? "null");
    await _couponRef.doc(coupon.id).update(coupon.toMap());
  }

  Future<void> deleteCoupon(String couponId) async {
    await _couponRef.doc(couponId).delete();
  }

  Future<bool> checkCoupenExist(String name) async {
    final couponRef =
        await _couponRef
            .where("couponName", isEqualTo: name.toLowerCase())
            .where("sellerId", isEqualTo: userUid)
            .get();
    return couponRef.docs.isNotEmpty;
  }

  Future<void> toggleLive(SellerCouponModel coupen) async {
    await _couponRef.doc(coupen.id).update({"isActive": !coupen.isActive});
  }

  Future<List<SellerCouponModel>> getSellerCoupons() async {
    log(userUid);
    final snapshot =
        await _couponRef.where('sellerid', isEqualTo: userUid).get();

    return snapshot.docs
        .map((doc) => SellerCouponModel.fromMap(doc.data()))
        .toList();
  }
}
