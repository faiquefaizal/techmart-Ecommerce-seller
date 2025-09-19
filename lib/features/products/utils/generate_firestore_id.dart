import 'package:cloud_firestore/cloud_firestore.dart';

String generateFirestoreId() {
  return FirebaseFirestore.instance.collection('_').doc().id;
}

bool areVariantAttributesEqual(
  Map<String, String?> existingAttributes,
  Map<String, String?> newAttributes,
) {
  if (existingAttributes.length != newAttributes.length) {
    return false;
  }
  return existingAttributes.entries.every((entry) {
    final newValue = newAttributes[entry.key];
    // Handle null values explicitly
    if (entry.value == null && newValue == null) {
      return true;
    }
    if (entry.value == null || newValue == null) {
      return false;
    }
    return entry.value == newValue;
  });
}
