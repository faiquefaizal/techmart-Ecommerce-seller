import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:techmart_seller/features/authentication/models/seller_model.dart';

class AuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  static String? get sellerId {
    FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String?> registerSeller({
    required String email,
    required String password,
    required String name,
    required String businessname,
    required String phonenumber,
  }) async {
    try {
      UserCredential usercred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      SellerModel seller = SellerModel(
        selleruid: usercred.user!.uid,
        businessName: email,
        passord: password,
        phoneNumber: phonenumber,
        sellerName: businessname,
      );

      await db.collection("seller").doc(seller.selleruid).set(seller.toMap());
      return usercred.user?.uid;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> loginIn(String email, String password) async {
    try {
      final usercred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return usercred.user?.uid;
    } catch (e) {
      rethrow;
    }
  }

  bool loginCheck() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> sellerVerificationStatus(String userId) {
    return db.collection("seller").doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()?['is_verfied'] ?? false;
      } else {
        throw Exception("Seller not found");
      }
    });
  }
}
