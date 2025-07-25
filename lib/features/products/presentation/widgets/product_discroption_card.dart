import 'package:flutter/material.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';

class ProductDiscriptionCard extends StatelessWidget {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  ProductDiscriptionCard({
    super.key,
    required this.productDescriptionController,
    required this.productNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustemTextFIeld(
              label: "Product Name",
              hintText: "Enter your Product Name",
              controller: productNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Product name is required";
                }
                return null;
              },
            ),
            CustemTextFIeld(
              minLine: 3,
              label: "Product Description",
              hintText: "Enter Product Disocption",
              controller: productDescriptionController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Description is required";
                } else if (value.length > 2000) {
                  return "Product name should not exceed 350 characters";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
