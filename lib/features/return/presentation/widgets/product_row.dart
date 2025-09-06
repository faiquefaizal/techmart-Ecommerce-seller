import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';

class ProductRow extends StatelessWidget {
  final OrderModel order;
  const ProductRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: OrderService().getProductDetailsFromVarient(
        order.productId,
        order.varientId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 80,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          log("Error loading product: ${snapshot.error}");
          return const Text("No product");
        }

        final productName = snapshot.data!["ProductName"] as String;
        final imageUrl = snapshot.data!["VarientImage"] as String;

        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "Qty: ${order.quantity}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
