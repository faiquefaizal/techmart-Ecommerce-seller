import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

void showProductDetailsDialog({
  required BuildContext parentContext,
  required ProductModel product,
}) {
  log('Showing dialog for product: ${product.productName}');
  showDialog(
    context: parentContext,
    barrierDismissible: true,
    builder:
        (dialogContext) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          log(
                            'Closing dialog for product: ${product.productName}',
                          );
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          } else {
                            log(
                              'Dialog context not mounted, falling back to parentContext',
                            );
                            if (parentContext.mounted) {
                              Navigator.pop(parentContext);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Description: ${product.productDescription}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          FutureBuilder<String>(
                            future: ProductService.getCataagaryNameById(
                              product.categoryId,
                            ),
                            builder: (context, snapshot) {
                              return Text(
                                "Category: ${snapshot.data ?? 'Loading...'}",
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          FutureBuilder<String>(
                            future: ProductService.getBrandNameById(
                              product.brandId,
                            ),
                            builder: (context, snapshot) {
                              return Text(
                                "Brand: ${snapshot.data ?? 'Loading...'}",
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Variants",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 8),
                  product.varients.isEmpty
                      ? Text(
                        "No variants available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: product.varients.length,
                        itemBuilder: (context, index) {
                          final variant = product.varients[index];
                          final variantName = variant.variantAttributes.entries
                              .map((e) => "${e.key}: ${e.value}")
                              .join(", ");
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    variantName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Regular Price: ${variant.regularPrice}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Selling Price: ${variant.sellingPrice}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Buying Price: ${variant.buyingPrice}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Quantity: ${variant.quantity}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    " Images:   ${variant.variantImageUrls?.length ?? "Not availablAe"}    ",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        log(
                          'Closing dialog for product: ${product.productName}',
                        );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        } else {
                          log(
                            'Dialog context not mounted, falling back to parentContext',
                          );
                          if (parentContext.mounted) {
                            Navigator.pop(parentContext);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
