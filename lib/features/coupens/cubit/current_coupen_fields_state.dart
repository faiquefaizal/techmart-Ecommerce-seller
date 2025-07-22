part of 'current_coupen_fields_cubit.dart';

class CoupenFieldsUpdated extends Equatable {
  final String couponName;
  final String? id;
  final double percentage;
  final double minPrice;
  final DateTime startDate;
  final DateTime endDate;
  final bool islive;
  final String? sellerId;

  const CoupenFieldsUpdated({
    this.sellerId,
    this.id,
    required this.couponName,
    required this.percentage,
    required this.minPrice,
    required this.startDate,
    required this.endDate,
    required this.islive,
  });

  CoupenFieldsUpdated copyWith({
    String? sellerId,
    String? couponName,
    String? id,
    double? percentage,
    double? minPrice,
    DateTime? startDate,
    DateTime? endDate,
    bool? islive,
  }) {
    return CoupenFieldsUpdated(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      couponName: couponName ?? this.couponName,
      percentage: percentage ?? this.percentage,
      minPrice: minPrice ?? this.minPrice,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      islive: islive ?? this.islive,
    );
  }

  @override
  List<Object> get props => [
    couponName,
    percentage,
    minPrice,
    startDate,
    endDate,
    islive,
  ];
}
