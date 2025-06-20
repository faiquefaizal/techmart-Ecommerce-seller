class CatagoryVarient {
  String name;
  List<String> options;
  CatagoryVarient({required this.name, required this.options});

  Map<String, dynamic> toMap() {
    return {"name": name, "options": options};
  }

  factory CatagoryVarient.fromMap(Map<String, dynamic> map) {
    return CatagoryVarient(
      name: map["name"] ?? "",
      options: List<String>.from(map["options"] ?? []),
    );
  }
  factory CatagoryVarient.catagoryFromMap(Map<String, dynamic> map) {
    return CatagoryVarient(name: map["Name"], options: map["options"] ?? []);
  }
}
