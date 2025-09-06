// import 'package:flutter/material.dart';
// import 'package:techmart_seller/core/funtion/common_funtion.dart';
// import 'package:techmart_seller/features/orders/models/order_status.dart';
// import 'package:techmart_seller/features/orders/service/order_service.dart';

// void showOrderDetails(BuildContext context, OrderModel order) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Order Details"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Order ID: ${order.orderId}"),
//             Text("Date: ${order.createTime.ddmmyyyy}"),
//             const SizedBox(height: 10),
//             FutureBuilder<String?>(
//               future: OrderService().getUserName(order.userId),
//               builder: (context, snapshot) {
//                 return Text("Customer: ${snapshot.data ?? 'Loading...'}");
//               },
//             ),
//             const SizedBox(height: 10),
//             FutureBuilder<Map<String, dynamic>?>(
//               future: OrderService().getProductDetailsFromVarient(
//                 order.productId,
//                 order.varientId,
//               ),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Text("Product: Loading...");
//                 final data = snapshot.data!;
//                 return Row(
//                   children: [
//                     Image.network(data["VarientImage"], width: 50, height: 50),
//                     const SizedBox(width: 8),
//                     Expanded(child: Text(data["ProductName"])),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             Text("Quantity: ${order.quantity}"),
//             Text("Total: \$${order.total.toStringAsFixed(2)}"),
//             const SizedBox(height: 10),
//             Text("Status: ${order.status}"),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';
import 'package:techmart_seller/core/funtion/common_funtion.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';

void showOrderDetails(BuildContext context, OrderModel order) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Order Details"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: ${order.orderId}"),
              Text("Date: ${order.createTime.ddmmyyyy}"),
              const SizedBox(height: 10),
              FutureBuilder<String>(
                future: order.fullName,
                builder: (context, snapshot) {
                  return Text("Customer: ${snapshot.data ?? 'Loading...'}");
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>?>(
                future: OrderService().getProductDetailsFromVarient(
                  order.productId,
                  order.varientId,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Text("Product: Loading...");
                  final data = snapshot.data!;
                  return Row(
                    children: [
                      Image.network(
                        data["VarientImage"],
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(data["ProductName"])),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Text("Quantity: ${order.quantity}"),
              Text("Total: \$${order.total.toStringAsFixed(2)}"),
              Text("Payment Mode: ${order.paymentMode}"),
              const SizedBox(height: 10),
              Text("Status: ${order.status}"),
              const SizedBox(height: 10),
              Text(
                "Delivery Address:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Full Name: ${order.address.fullName}"),
              Text("House No: ${order.address.houseNo}"),
              Text("Area: ${order.address.area}"),
              Text("City: ${order.address.city}"),
              Text("State: ${order.address.state}"),
              Text("Pin Code: ${order.address.pinCode}"),
              Text("Phone Number: ${order.address.phoneNumber}"),
              if (order.deliveryCharge != null && order.deliveryCharge! > 0)
                Text(
                  "Delivery Charge: \$${order.deliveryCharge!.toStringAsFixed(2)}",
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
