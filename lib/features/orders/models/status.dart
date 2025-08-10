import 'package:flutter/material.dart';

enum OrderStatus { Pending, proccessing, shipped, outfordelivery, delivery }

// String toString(OrderStatus status) {
//   switch (status) {
//     case OrderStatus.proccessing:
//       return "Processing";
//     case OrderStatus.shipped:
//       return "Shipped";
//     case OrderStatus.outfordelivery:
//       return "Out for Delvier";
// case OrderStatus.outfordelivery
//     case OrderStatus.delivery:
//       return "Delivered";

//   }

// }
int getIndexWithStatus(String value) {
  switch (value) {
    case "Pending":
      return 0;
    case "proccessing":
      return 1;
    case "shipped":
      return 2;
    case "outfordelivery":
      return 3;
    case "delivery":
      return 4;
    default:
      return 0;
  }
}
