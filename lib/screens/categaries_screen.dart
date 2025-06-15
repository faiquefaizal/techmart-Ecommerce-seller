// // techmart_seller/screens/edit_product_screen.dart

// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
// import 'package:techmart_seller/core/widgets/text_fields.dart';
// import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
// import 'package:techmart_seller/features/products/bloc/product_event.dart';
// import 'package:techmart_seller/features/products/bloc/product_state.dart';
// import 'package:techmart_seller/features/products/models/product_model.dart';
// import 'package:techmart_seller/features/products/models/product_varient_model.dart';
// import 'package:techmart_seller/features/products/services/product_service.dart';
//  // Assuming this path is correct

// class EditProductScreen extends StatefulWidget {
//   final ProductModel product; // Product to be edited

//   const EditProductScreen({Key? key, required this.product}) : super(key: key);

//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   late TextEditingController _productNameController;
//   late TextEditingController _productDescriptionController;
//   final categoriesRef = FirebaseFirestore.instance.collection("Catagory");
//   final brandsRef = FirebaseFirestore.instance.collection("Brands");
//   String? _selectedCategoryId;
//   String? _selectedBrandId;
//   final Map<String, String?> _currentVariantSelections = {};
//   final List<ProductVarientModel> _productVariants = []; // Holds current variants, including newly added ones
//   List<String> _initialMainImageUrls = []; // Stores original main product images for deletion comparison
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _regularPriceController = TextEditingController();
//   final TextEditingController _sellingPriceController = TextEditingController();
//   final TextEditingController _buyingPriceController = TextEditingController();
//   final GlobalKey<FormState> _mainProductFormKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _variantFormKey = GlobalKey<FormState>();
//   // ProductService is used for direct image uploads here, not via Bloc
//   final ProductService _productService = ProductService();

//   // Reference to the main ImageCubit to manage newly picked images
//   // This Cubit is provided in main.dart
//   late ImageCubit _mainImageCubit;

//   @override
//   void initState() {
//     super.initState();
//     _productNameController = TextEditingController(text: widget.product.productName);
//     _productDescriptionController = TextEditingController(text: widget.product.productDescription);
//     _selectedCategoryId = widget.product.categoryId;
//     _selectedBrandId = widget.product.brandId;
//     // Deep copy variants to allow modification without affecting original widget.product
//     _productVariants.addAll(widget.product.varients.map((v) => ProductVarientModel(
//       buyingPrice: v.buyingPrice,
//       quantity: v.quantity,
//       regularPrice: v.regularPrice,
//       sellingPrice: v.sellingPrice,
//       variantName: v.variantName,
//       variantValue: v.variantValue,
//       variantImageUrls: v.variantImageUrls != null ? List.from(v.variantImageUrls!) : null,
//     )));
//     _initialMainImageUrls = List.from(widget.product.imageUrls ?? []); // Store original URLs for deletion later

//     // Access the main ImageCubit (provided in main.dart)
//     // We clear its state as it's for *new* main images in edit mode.
//     // Existing main images are displayed from _initialMainImageUrls.
//     _mainImageCubit = context.read<ImageCubit>();
//     _mainImageCubit.clearImage(); // Ensure it starts clean for new picks
//   }

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     _productDescriptionController.dispose();
//     _quantityController.dispose();
//     _regularPriceController.dispose();
//     _sellingPriceController.dispose();
//     _buyingPriceController.dispose();
//     super.dispose();
//   }

//   // Function to add a new product variant to the _productVariants list
//   void _addVariant(ImageCubit variantImageCubit) async {
//     if (!_variantFormKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all required variant details correctly.")),
//       );
//       return;
//     }

//     if (_currentVariantSelections.isEmpty || _currentVariantSelections.values.contains(null)) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select all variant options before adding.")));
//       return;
//     }

//     final int quantity = int.parse(_quantityController.text);
//     final int regularPrice = int.parse(_regularPriceController.text);
//     final int sellingPrice = int.parse(_sellingPriceController.text);
//     final int buyingPrice = int.parse(_buyingPriceController.text);

//     final variantImageCubitState = variantImageCubit.state;
//     List<Uint8List> pickedVariantImages = [];
//     if (variantImageCubitState is PickimagePicked) {
//       pickedVariantImages = variantImageCubitState.images;
//     }

//     List<String> variantImageUrls = [];
//     if (pickedVariantImages.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Uploading variant images...")),);
//       try {
//         variantImageUrls = await _productService.uploadImages(pickedVariantImages);
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Variant images uploaded.")),);
//       } catch (e) {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload variant images: $e")),);
//         return;
//       }
//     } else {
//       // In edit mode, if no new images are picked for a new variant, it's an error for new variants.
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please pick at least one image for this new variant.")),);
//       return;
//     }

//     String variantNameCombined = _currentVariantSelections.keys.join(', ');
//     String variantValueCombined = _currentVariantSelections.values.where((v) => v != null).join(', ');

//     final newVariant = ProductVarientModel(
//       variantName: variantNameCombined,
//       variantValue: variantValueCombined,
//       quantity: quantity,
//       regularPrice: regularPrice,
//       sellingPrice: sellingPrice,
//       buyingPrice: buyingPrice,
//       variantImageUrls: variantImageUrls,
//     );

//     setState(() {
//       _productVariants.add(newVariant);
//       _quantityController.clear();
//       _regularPriceController.clear();
//       _sellingPriceController.clear();
//       _buyingPriceController.clear();
//       _currentVariantSelections.updateAll((key, value) => null); // Reset variant dropdowns
//     });

//     variantImageCubit.clearImage(); // Clear variant-specific image cubit state
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New variant added to list!")),);
//   }

//   // Function to handle the product update submission
//   void _submitProductUpdate(BuildContext context) async {
//     if (!_mainProductFormKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all required product details in the main section.")),);
//       return;
//     }

//     if (_selectedCategoryId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category.")),);
//       return;
//     }

//     if (_selectedBrandId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a brand.")),);
//       return;
//     }

//     if (_productVariants.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least one product variant.")),);
//       return;
//     }

//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Seller not logged in. Please log in first.")),);
//       return;
//     }
//     final String sellerUid = currentUser.uid;

//     // Get newly picked main images from the ImageCubit
//     final newMainProductImagesUint8 = _mainImageCubit.state is PickimagePicked
//         ? (_mainImageCubit.state as PickimagePicked).images
//         : <Uint8List>[];

//     final updatedProduct = ProductModel(
//       productId: widget.product.productId, // Crucial: Retain existing product ID
//       productName: _productNameController.text.trim(),
//       productDescription: _productDescriptionController.text.trim(),
//       sellerUid: sellerUid,
//       categoryId: _selectedCategoryId!,
//       brandId: _selectedBrandId!,
//       varients: _productVariants, // This list contains updated variants (newly added and original retained)
//       imageUrls: [], // This will be set by ProductService after upload/deletion logic
//     );

//     context.read<ProductBloc>().add(
//       EditProductEvent(
//         updatedProduct: updatedProduct,
//         newMainImagesBytes: newMainProductImagesUint8,
//         oldMainImageUrls: _initialMainImageUrls, // Pass the original URLs for deletion comparison
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Product")),
//       body: BlocListener<ProductBloc, ProductState>(
//         listener: (context, state) {
//           if (state is ProductLoadingState) {
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saving changes...")),);
//           } else if (state is ProductEditedState) {
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product updated successfully!")),);
//             Navigator.of(context).pop(); // Go back after successful update
//           } else if (state is ProductErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating product: ${state.error}")),);
//           }
//         },
//         child: Form(
//           key: _mainProductFormKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustemTextFIeld(
//                   label: "Product Name",
//                   hintText: "Enter Product Name",
//                   controller: _productNameController,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Product name cannot be empty";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 CustemTextFIeld(
//                   label: "Product Description",
//                   hintText: "Enter Product Description",
//                   controller: _productDescriptionController,
//                   // maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Product description cannot be empty";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Category Dropdown
//                 const Text("Select Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: categoriesRef.snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasError) {
//                       return Text('Error loading categories: ${snapshot.error}');
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Text('No categories available. Please add categories in Admin App.');
//                     }

//                     final categories = snapshot.data!.docs;
//                     return DropdownButtonFormField<String>(
//                       value: _selectedCategoryId,
//                       hint: const Text("Choose category"),
//                       isExpanded: true,
//                       items: categories.map((doc) {
//                         final categoryName = doc["Name"] as String? ?? "Unnamed Category";
//                         return DropdownMenuItem<String>(
//                           value: doc.id,
//                           child: Text(categoryName),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedCategoryId = value;
//                           // When category changes, variants for this product might also change
//                           // For simplicity, we clear existing variants if category changes.
//                           // A more advanced edit screen would need to map/reconfigure variants.
//                           _currentVariantSelections.clear();
//                           _productVariants.clear();
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return "Please select a category";
//                         }
//                         return null;
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Brand Dropdown
//                 const Text("Select Brand", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: brandsRef.snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasError) {
//                       return Text('Error loading brands: ${snapshot.error}');
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Text('No brands available. Please add brands in Admin App.');
//                     }

//                     final brands = snapshot.data!.docs;
//                     return DropdownButtonFormField<String>(
//                       value: _selectedBrandId,
//                       hint: const Text("Choose brand"),
//                       isExpanded: true,
//                       items: brands.map((doc) {
//                         final brandName = doc["name"] as String? ?? "Unnamed Brand";
//                         return DropdownMenuItem<String>(
//                           value: doc.id,
//                           child: Text(brandName),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedBrandId = value;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return "Please select a brand";
//                         }
//                         return null;
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Display Existing Variants (from original product)
//                 if (_productVariants.isNotEmpty) ...[
//                   const Divider(),
//                   const Text("Current Variants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _productVariants.length,
//                     itemBuilder: (context, index) {
//                       final variant = _productVariants[index];
//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 8),
//                         child: ListTile(
//                           title: Text("${variant.variantName}: ${variant.variantValue}"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Qty: ${variant.quantity}, Reg: ${variant.regularPrice}, Sell: ${variant.sellingPrice}, Buy: ${variant.buyingPrice}"),
//                               if (variant.variantImageUrls != null && variant.variantImageUrls!.isNotEmpty)
//                                 Wrap(
//                                   spacing: 4.0,
//                                   runSpacing: 2.0,
//                                   children: variant.variantImageUrls!
//                                       .map((url) => Image.network(
//                                             url,
//                                             width: 30,
//                                             height: 30,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 20),
//                                           ))
//                                       .toList(),
//                                 ),
//                             ],
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.remove_circle, color: Colors.red),
//                             onPressed: () {
//                               setState(() {
//                                 _productVariants.removeAt(index); // Allows removal of existing variants from the list
//                                 // NOTE: Deleting images from Cloudinary for removed variants is NOT handled here.
//                                 // If a variant is removed, its images will only be deleted from Cloudinary
//                                 // when the *entire product* is deleted.
//                               });
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   const Divider(),
//                 ],

//                 // --- Dynamic Product Variants Section (for adding new variants) ---
//                 if (_selectedCategoryId != null) ...[
//                   const Text("Add New Variant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Form(
//                     key: _variantFormKey, // Use the separate variant form key
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Dynamically generate dropdowns for each category variant (e.g., Color, Size)
//                         ...categoryVariants.map((catVariant) {
//                           if (!_currentVariantSelections.containsKey(catVariant.name)) {
//                             _currentVariantSelections[catVariant.name] = null;
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Select ${catVariant.name}", style: const TextStyle(fontWeight: FontWeight.w500)),
//                                 DropdownButtonFormField<String>(
//                                   value: _currentVariantSelections[catVariant.name],
//                                   hint: Text("Choose ${catVariant.name}"),
//                                   isExpanded: true,
//                                   items: catVariant.options.map((option) => DropdownMenuItem<String>(value: option, child: Text(option))).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _currentVariantSelections[catVariant.name] = value;
//                                     });
//                                   },
//                                   validator: (value) {
//                                     if (value == null) {
//                                       return "Please select a ${catVariant.name}";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                         const SizedBox(height: 10),
//                         CustemTextFIeld(label: "Quantity", hintText: "Enter Quantity", controller: _quantityController,  validator: (value) { if (value == null || value.trim().isEmpty) { return "Quantity cannot be empty"; } if (int.tryParse(value) == null) { return "Enter a valid number"; } return null; },),
//                         const SizedBox(height: 10),
//                         CustemTextFIeld(label: "Regular Price", hintText: "Enter Regular Price", controller: _regularPriceController, validator: (value) { if (value == null || value.trim().isEmpty) { return "Regular price cannot be empty"; } if (int.tryParse(value) == null) { return "Enter a valid number"; } return null; },),
//                         const SizedBox(height: 10),
//                         CustemTextFIeld(label: "Selling Price", hintText: "Enter Selling Price", controller: _sellingPriceController, validator: (value) { if (value == null || value.trim().isEmpty) { return "Selling price cannot be empty"; } if (int.tryParse(value) == null) { return "Enter a valid number"; } return null; },),
//                         const SizedBox(height: 10),
//                         CustemTextFIeld(label: "Buying Price", hintText: "Enter Buying Price", controller: _buyingPriceController, validator: (value) { if (value == null || value.trim().isEmpty) { return "Buying price cannot be empty"; } if (int.tryParse(value) == null) { return "Enter a valid number"; } return null; },),
//                         const SizedBox(height: 20),

//                         // --- Variant Image Picker for new variants ---
//                         const Text("Variant Images (for new variant)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 10),
//                         BlocProvider<ImageCubit>(
//                           create: (_) => ImageCubit(),
//                           child: Builder(
//                             builder: (variantImageContext) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   BlocBuilder<ImageCubit, PickimageState>(
//                                     builder: (context, state) {
//                                       if (state is PickimageInitial) {
//                                         return ElevatedButton.icon(onPressed: () => variantImageContext.read<ImageCubit>().pickImage(), icon: const Icon(Icons.image), label: const Text("Pick Images for this Variant"),);
//                                       } else if (state is PickimagePicked) {
//                                         return Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Wrap(spacing: 8, runSpacing: 8, children: state.images.asMap().entries.map((entry) => Stack(alignment: Alignment.topRight, children: [Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8),), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(entry.value, width: 100, height: 100, fit: BoxFit.cover,),),), Positioned(right: -10, top: -10, child: IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () { variantImageContext.read<ImageCubit>().removeImage(entry.key); },),),],)).toList(),),
//                                             const SizedBox(height: 10),
//                                             ElevatedButton.icon(onPressed: () => variantImageContext.read<ImageCubit>().pickImage(), icon: const Icon(Icons.add_a_photo), label: const Text("Add More Variant Images"),),
//                                           ],
//                                         );
//                                       } else if (state is PickimageError) { return Text('Error picking variant image: ${state.error}', style: const TextStyle(color: Colors.red)); } else { return const SizedBox.shrink(); }
//                                     },
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Align(alignment: Alignment.centerRight, child: ElevatedButton.icon(onPressed: () => _addVariant(variantImageContext.read<ImageCubit>()), icon: const Icon(Icons.add), label: const Text("Add New Variant"),),),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],

//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Main Product Images", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 // Display EXISTING main images (read from product object directly)
//                 if (_initialMainImageUrls.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Existing Main Images:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _initialMainImageUrls.asMap().entries.map((entry) {
//                           final url = entry.value;
//                           final index = entry.key;
//                           return Stack(
//                             alignment: Alignment.topRight,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
//                                 child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50)),),
//                               ),
//                               Positioned( // 'X' button to remove original image
//                                 right: -10, top: -10,
//                                 child: IconButton(
//                                   icon: const Icon(Icons.remove_circle, color: Colors.red),
//                                   onPressed: () {
//                                     setState(() {
//                                       _initialMainImageUrls.removeAt(index); // Remove from list of originals
//                                       // Note: This only marks for deletion on submit.
//                                       // Actual Cloudinary deletion handled in ProductService.
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 // Allow picking NEW main images (managed by the main ImageCubit)
//                 BlocBuilder<ImageCubit, PickimageState>(
//                   bloc: _mainImageCubit, // Explicitly provide the bloc instance
//                   builder: (context, state) {
//                     List<Widget> newPickedImageWidgets = [];
//                     if (state is PickimagePicked) {
//                       newPickedImageWidgets = state.images.asMap().entries.map((entry) => Stack(
//                         alignment: Alignment.topRight,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8),),
//                             child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(entry.value, width: 100, height: 100, fit: BoxFit.cover,),),
//                           ),
//                           Positioned( // 'X' button to remove newly picked image
//                             right: -10, top: -10,
//                             child: IconButton(
//                               icon: const Icon(Icons.remove_circle, color: Colors.red),
//                               onPressed: () {
//                                 _mainImageCubit.removeImage(entry.key); // Remove from cubit
//                               },
//                             ),
//                           ),
//                         ],
//                       )).toList();
//                     }

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (newPickedImageWidgets.isNotEmpty) ...[
//                           const Text('Newly Picked Images:', style: TextStyle(fontWeight: FontWeight.bold)),
//                           Wrap(spacing: 8, runSpacing: 8, children: newPickedImageWidgets),
//                           const SizedBox(height: 10),
//                         ],
//                         ElevatedButton.icon(
//                           onPressed: () => _mainImageCubit.pickImage(), // Use the initialized main ImageCubit
//                           icon: const Icon(Icons.add_a_photo),
//                           label: const Text("Pick More Main Images"),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => _submitProductUpdate(context), // Call update function
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: BlocBuilder<ProductBloc, ProductState>(
//                       builder: (context, state) {
//                         if (state is ProductLoadingState) {
//                           return const CircularProgressIndicator(color: Colors.white);
//                         }
//                         return const Text(
//                           "Save Changes", // Changed button text
//                           style: TextStyle(fontSize: 18),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CategariesScreen extends StatelessWidget {
  const CategariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("center"));
  }
}
