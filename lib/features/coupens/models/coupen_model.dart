import 'package:cloud_firestore/cloud_firestore.dart';

class SellerCouponModel {
  final String? id;
  final String? sellerId;
  final String couponName;
  final double discountPercentage;
  final double minimumPrice;
  final DateTime startTime;
  final DateTime endTime;
  final bool isActive;

  SellerCouponModel({
    this.sellerId,
    this.id,
    required this.couponName,
    required this.discountPercentage,
    required this.minimumPrice,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerid': sellerId,
      'couponName': couponName.toLowerCase(),
      'discountPercentage': discountPercentage,
      'minimumPrice': minimumPrice,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
    };
  }

  factory SellerCouponModel.fromMap(Map<String, dynamic> map) {
    return SellerCouponModel(
      id: map['id'],
      sellerId: map['sellerid'],
      couponName: map['couponName'],
      discountPercentage: (map['discountPercentage'] as num).toDouble(),
      minimumPrice: (map['minimumPrice'] as num).toDouble(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      isActive: map['isActive'],
    );
  }

  SellerCouponModel copyWith({
    String? id,
    String? sellerId,
    String? couponName,
    double? discountPercentage,
    double? minimumPrice,
    DateTime? startTime,
    DateTime? endTime,
    bool? isActive,
  }) {
    return SellerCouponModel(
      sellerId: sellerId ?? this.sellerId,
      id: id ?? this.id,
      couponName: couponName ?? this.couponName,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
    );
  }
}
