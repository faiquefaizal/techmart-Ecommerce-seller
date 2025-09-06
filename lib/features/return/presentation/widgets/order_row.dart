import 'package:flutter/material.dart';
import 'package:techmart_seller/core/funtion/common_funtion.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';

class OrderDetailsRow extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          order.orderId,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          order.createTime.ddmmyyyy,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
