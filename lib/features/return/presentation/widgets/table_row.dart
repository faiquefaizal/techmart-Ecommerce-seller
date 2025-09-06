import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/common_funtion.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';
import 'package:techmart_seller/features/return/bloc/return_bloc.dart';
import 'package:techmart_seller/features/return/presentation/widgets/action_row_widget.dart';
import 'package:techmart_seller/features/return/presentation/widgets/order_row.dart';
import 'package:techmart_seller/features/return/presentation/widgets/product_row.dart';
import 'package:techmart_seller/features/return/presentation/widgets/user_row.dart';
import 'package:techmart_seller/features/return/util/funtions/helper_funtions.dart';

DataRow tableRow(OrderModel order, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(OrderDetailsRow(order: order)),

      DataCell(UserRow(orderId: order.orderId)),

      DataCell(ProductRow(order: order)),

      DataCell(
        Text(
          "₹${order.total.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      DataCell(
        Text(
          "${order.returnReason}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      DataCell(
        Text(
          order.status,
          style: TextStyle(color: returnColorFromStatus(order.status)),
        ),
      ),

      DataCell(
        (order.status == "returnRequest")
            ? ActionRow(
              orderId: order.orderId,
              productId: order.productId,
              varientId: order.varientId,
              count: order.quantity,
            )
            : SizedBox.shrink(),
      ),
    ],
  );
}
