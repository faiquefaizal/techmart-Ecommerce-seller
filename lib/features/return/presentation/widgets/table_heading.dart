import 'package:flutter/material.dart';

List<DataColumn> get tableHeading {
  return const [
    DataColumn(label: Text("ORDER ID")),
    DataColumn(label: Text("CUSTOMER")),
    DataColumn(label: Text("PRODUCTS")),
    DataColumn(label: Text("TOTAL AMOUNT")),
    DataColumn(label: Text("REASON")),
    DataColumn(label: Text("STATUS")),
    DataColumn(label: Text("ACTIONS")),
  ];
}
