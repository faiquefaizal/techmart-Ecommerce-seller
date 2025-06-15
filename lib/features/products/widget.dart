// import 'package:flutter/material.dart';

// import 'package:techmart_seller/features/products/models/product_varient_model.dart';

// class VariantSelector extends StatefulWidget {
//   const VariantSelector({super.key});

//   @override
//   State<VariantSelector> createState() => _VariantSelectorState();
// }

// class _VariantSelectorState extends State<VariantSelector> {
//   final List<ProductVarientModel> _variants = [];

//   final _variantNameController = TextEditingController();
//   final _variantValueController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _regularPriceController = TextEditingController();
//   final _sellingPriceController = TextEditingController();
//   final _buyingPriceController = TextEditingController();

//   void _addVariant() {
//     if (_variantNameController.text.isEmpty ||
//         _variantValueController.text.isEmpty ||
//         _quantityController.text.isEmpty ||
//         _regularPriceController.text.isEmpty ||
//         _sellingPriceController.text.isEmpty ||
//         _buyingPriceController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all variant fields.")),
//       );
//       return;
//     }

//     final variant = ProductVarientModel(
//       variantName: _variantNameController.text,
//       variantValue: _variantValueController.text,
//       quantity: int.tryParse(_quantityController.text) ?? 0,
//       regularPrice: int.tryParse(_regularPriceController.text) ?? 0,
//       sellingPrice: int.tryParse(_sellingPriceController.text) ?? 0,
//       buyingPrice: int.tryParse(_buyingPriceController.text) ?? 0,
//     );

//     setState(() {
//       _variants.add(variant);
//       _variantNameController.clear();
//       _variantValueController.clear();
//       _quantityController.clear();
//       _regularPriceController.clear();
//       _sellingPriceController.clear();
//       _buyingPriceController.clear();
//     });
//   }

//   List<ProductVarientModel> getSelectedVariants() => _variants;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Add Variants",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: _variantNameController,
//           decoration: const InputDecoration(
//             labelText: "Variant Name (e.g., Color)",
//           ),
//         ),
//         TextField(
//           controller: _variantValueController,
//           decoration: const InputDecoration(
//             labelText: "Variant Value (e.g., Red)",
//           ),
//         ),
//         TextField(
//           controller: _quantityController,
//           decoration: const InputDecoration(labelText: "Quantity"),
//           keyboardType: TextInputType.number,
//         ),
//         TextField(
//           controller: _regularPriceController,
//           decoration: const InputDecoration(labelText: "Regular Price"),
//           keyboardType: TextInputType.number,
//         ),
//         TextField(
//           controller: _sellingPriceController,
//           decoration: const InputDecoration(labelText: "Selling Price"),
//           keyboardType: TextInputType.number,
//         ),
//         TextField(
//           controller: _buyingPriceController,
//           decoration: const InputDecoration(labelText: "Buying Price"),
//           keyboardType: TextInputType.number,
//         ),
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: _addVariant,
//           child: const Text("Add Variant"),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           "Added Variants:",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         ..._variants.map(
//           (v) => ListTile(
//             title: Text("${v.variantName}: ${v.variantValue}"),
//             subtitle: Text("Qty: ${v.quantity} | Selling: ${v.sellingPrice}"),
//           ),
//         ),
//       ],
//     );
//   }
// }
