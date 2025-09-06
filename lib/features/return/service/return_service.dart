import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';

class ReturnService {
  final CollectionReference _orderRef = FirebaseFirestore.instance.collection(
    "Orders",
  );
  final CollectionReference _productRef = FirebaseFirestore.instance.collection(
    "Products",
  );

  Stream<List<OrderModel>> fetchReturns() {
    return _orderRef
        .where("status", whereIn: ["returnRequest", "Approved", "Rejected"])
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map(
                    (doc) =>
                        OrderModel.fromJson(doc.data() as Map<String, dynamic>),
                  )
                  .toList(),
        );
  }

  acceptReturn(String id, String productId, String varientId, int count) async {
    await _orderRef.doc(id).update({"status": "Approved"});
    await _productRef
        .doc(productId)
        .collection("varients")
        .doc(varientId)
        .update({"quantity": FieldValue.increment(count)});
  }

  rejectReturn(String id) {
    _orderRef.doc(id).update({"status": "Rejected"});
  }
}
