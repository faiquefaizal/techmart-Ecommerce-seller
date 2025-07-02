import 'package:cloud_firestore/cloud_firestore.dart';

String generateFirestoreId() {
  return FirebaseFirestore.instance.collection('_').doc().id;
}
