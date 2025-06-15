class SellerModel {
  String selleruid;
  String businessName;
  String sellerName;
  String passord;
  String phoneNumber;
  bool isVerified;
  SellerModel({
    required this.selleruid,
    required this.businessName,
    required this.passord,
    required this.phoneNumber,
    required this.sellerName,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "selleruid": selleruid,
      "businessName": businessName,
      "sellerName": sellerName,
      "password": passord,
      "phoneNumber": phoneNumber,
      "is_verfied": isVerified,
    };
  }

  factory SellerModel.fromMap(Map<String, dynamic> map) {
    return SellerModel(
      selleruid: map["selleruid"],
      businessName: map["businessName"],
      passord: map["password"],
      phoneNumber: map["phoneNumber"],
      sellerName: "sellerName",
    );
  }
}
