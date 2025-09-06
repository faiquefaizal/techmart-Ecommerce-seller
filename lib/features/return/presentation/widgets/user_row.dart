import 'package:flutter/material.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';

class UserRow extends StatelessWidget {
  final String orderId;
  const UserRow({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: OrderService().getUserName(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 60,
            height: 20,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (snapshot.hasError) {
          return Text("Error");
        }
        return Text(snapshot.data ?? "No user");
      },
    );
  }
}
