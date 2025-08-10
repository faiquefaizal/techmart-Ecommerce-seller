import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  @override
  List<Object> get props => [id];
  final String id;
  final String fullName;
  final String phoneNumber;
  final String pinCode;
  final String state;
  final String city;
  final String houseNo;
  final String area;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.pinCode,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.area,
    this.isDefault = false,
  });
  String get fulladdress => "$houseNo, $area, $city, $state - $pinCode";
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      pinCode: map['pinCode'],
      state: map['state'],
      city: map['city'],
      houseNo: map['houseNo'],
      area: map['area'],
      isDefault: map['isDefault'] ?? false,
    );
  }
}
