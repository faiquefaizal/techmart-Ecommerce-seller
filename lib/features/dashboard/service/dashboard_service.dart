import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardService {
  String? get sellerId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  final CollectionReference productRef = FirebaseFirestore.instance.collection(
    "Products",
  );
  final CollectionReference orderRef = FirebaseFirestore.instance.collection(
    "Orders",
  );
  Stream<int> getProductCountBySellerId(String sellerId) {
    return productRef
        .where('sellerUid', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalOrders() {
    return orderRef
        .where("sellerId", isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalApprovedReturns() {
    return orderRef
        .where("sellerId", isEqualTo: sellerId)
        .where('status', isEqualTo: 'Approved')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
