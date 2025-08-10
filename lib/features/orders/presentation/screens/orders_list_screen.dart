import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:techmart_seller/core/funtion/common_funtion.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';

import 'package:techmart_seller/features/orders/presentation/widgets/status_dropdown_widget.dart';
import 'package:techmart_seller/features/orders/presentation/widgets/view_order_details.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';

class OrdersListScreen extends StatelessWidget {
  final List<OrderModel> orders;
  const OrdersListScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 70,

            columns: const [
              DataColumn(label: Text("ORDER ID")),
              DataColumn(label: Text("CUSTOMER")),
              DataColumn(label: Text("PRODUCTS")),
              DataColumn(label: Text("TOTAL AMOUNT")),
              DataColumn(label: Text("STATUS")),
              DataColumn(label: Text("ACTIONS")),
            ],
            rows:
                orders.map((order) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              order.orderId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.createTime.ddmmyyyy,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      DataCell(
                        FutureBuilder<String?>(
                          future: OrderService().getUserName(order.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 60,
                                height: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            return Text(snapshot.data ?? "No user");
                          },
                        ),
                      ),

                      DataCell(
                        FutureBuilder<Map<String, dynamic>?>(
                          future: OrderService().getProductDetailsFromVarient(
                            order.productId,
                            order.varientId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 80,
                                height: 40,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              log("Error loading product: ${snapshot.error}");
                              return const Text("No product");
                            }

                            final productName =
                                snapshot.data!["ProductName"] as String;
                            final imageUrl =
                                snapshot.data!["VarientImage"] as String;

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
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      DataCell(
                        Text(
                          "\$${order.total.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),

                      DataCell(
                        StatusDropdownWidget(
                          currentStatus: order.status,
                          id: order.orderId,
                        ),
                      ),

                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            showOrderDetails(context, order);
                          },
                          child: const Text("View Details"),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
