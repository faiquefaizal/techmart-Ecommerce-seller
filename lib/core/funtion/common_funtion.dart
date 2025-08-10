extension DateTimeFormat on DateTime {
  String get ddmmyyyy {
    final d = day.toString().padLeft(2, "0");
    final m = month.toString().padLeft(2, "0");
    final y = year.toString();
    return "$d/$m/$y";
  }
}
