import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
import 'package:techmart_seller/core/widgets/dialog_widget.dart';
import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/presentation/screens/edit_product_screen.dart';
import 'package:techmart_seller/features/products/presentation/widgets/delete_alert_dialog.dart';
import 'package:techmart_seller/features/products/presentation/widgets/show_peoduct_dialog.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/new_service.dart';

import 'package:techmart_seller/features/products/utils/price_utils.dart';

class ProductsScreen extends StatelessWidget {
  final void Function(ProductModel) onEdit;

  const ProductsScreen({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: ProductService.fetchProductsBySeller(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 10),
                Text("Loading"),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Products added  found.'));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text("Product Name")),
                  DataColumn(label: Text("Catagory")),
                  DataColumn(label: Text("Brand")),
                  DataColumn(label: Text("Regular Price")),
                  DataColumn(label: Text("Selling Price")),
                  DataColumn(label: Text("Total Stock")),
                  DataColumn(label: Text("Actions")),
                ],
                rows:
                    snapshot.data!.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data.productName)),
                          DataCell(
                            FutureBuilder<String>(
                              future: ProductService.getCataagaryNameById(
                                data.categoryId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                log(snapshot.data!);
                                return Text(
                                  snapshot.data ?? "Unknown",
                                  style: TextStyle(color: Colors.black),
                                );
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder(
                              future: ProductService.getBrandNameById(
                                data.brandId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return const Text('Error');
                                }
                                log(snapshot.data!);
                                return Text(snapshot.data ?? "unknown");
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder(
                              future: ProductService.fetchVarientsByProductId(
                                data.productId!,
                              ),
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading...");
                                } else if (asyncSnapshot.hasError) {
                                  return const Text("Error");
                                } else if (!asyncSnapshot.hasData) {
                                  return const Text("Is empty");
                                }
                                //  else if (!asyncSnapshot.hasData ||
                                //     asyncSnapshot.data!.isEmpty) {
                                //   return const Text("N/A");
                                // }

                                final varientList = asyncSnapshot.data;
                                final regularPrice = getMaxMinPriceFromVarients(
                                  varientList!,
                                  "regularPrice",
                                );
                                return Text(regularPrice);
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder(
                              future: ProductService.fetchVarientsByProductId(
                                data.productId!,
                              ),
                              builder: (context, asyncSnapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading...");
                                } else if (snapshot.hasError) {
                                  return const Text("Error");
                                }

                                final varientList = asyncSnapshot.data;
                                final sellingPrice = getMaxMinPriceFromVarients(
                                  varientList!,
                                  "sellingPrice",
                                );
                                return Text(sellingPrice);
                              },
                            ),
                          ),
                          DataCell(
                            FutureBuilder(
                              future: ProductService.fetchVarientsByProductId(
                                data.productId!,
                              ),
                              builder: (context, asyncSnapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading...");
                                } else if (snapshot.hasError) {
                                  return const Text("Error");
                                }

                                final varientList = asyncSnapshot.data;
                                final totalQuatity = getTotalStock(
                                  varientList!,
                                );
                                return Text(totalQuatity.toString());
                              },
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showProductDetailsDialog(
                                      parentContext: context,
                                      product: data,
                                    );
                                  },
                                  child: Text("View Detailed"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onEdit(data);
                                  },
                                  child: Text("Edit"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    CustomAlertDialog(context, data);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
