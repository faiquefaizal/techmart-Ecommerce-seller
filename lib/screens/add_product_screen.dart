// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

// // Assuming these paths are correct in your project structure
// import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';

// import 'package:techmart_seller/core/widgets/text_fields.dart';
// import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
// import 'package:techmart_seller/features/products/bloc/product_event.dart';
// import 'package:techmart_seller/features/products/bloc/product_state.dart';
// import 'package:techmart_seller/features/products/models/catagory_model.dart';
// import 'package:techmart_seller/features/products/models/product_model.dart';
// import 'package:techmart_seller/features/products/models/product_varient_model.dart';
// import 'package:techmart_seller/features/products/services/product_service.dart'; // Import ProductService

// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({Key? key}) : super(key: key);

//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _productDescriptionController =
//       TextEditingController();

//   String? _selectedCategoryId;
//   String? _selectedBrandId;
//   final Map<String, String?> _currentVariantSelections = {};
//   final List<ProductVarientModel> _productVariants = [];
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _regularPriceController = TextEditingController();
//   final TextEditingController _sellingPriceController = TextEditingController();
//   final TextEditingController _buyingPriceController = TextEditingController();
//   final GlobalKey<FormState> _mainProductFormKey =
//       GlobalKey<FormState>(); // Key for main product form
//   final GlobalKey<FormState> _variantFormKey =
//       GlobalKey<FormState>(); // Key for variant input form
//   final ProductService _productService = ProductService();

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
//   // It accepts the ImageCubit instance directly for the variant images.
//   void _addVariant(ImageCubit variantImageCubit) async {
//     // Parameter is ImageCubit instance
//     // Validate only the variant-specific form fields using its dedicated key
//     if (!_variantFormKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please fill all required variant details correctly."),
//         ),
//       );
//       return;
//     }

//     // Check for selected variant options
//     if (_currentVariantSelections.isEmpty ||
//         _currentVariantSelections.values.contains(null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select all variant options before adding."),
//         ),
//       );
//       return;
//     }

//     final int quantity = int.parse(_quantityController.text);
//     final int regularPrice = int.parse(_regularPriceController.text);
//     final int sellingPrice = int.parse(_sellingPriceController.text);
//     final int buyingPrice = int.parse(_buyingPriceController.text);

//     // Access state directly from the passed Cubit instance
//     final variantImageCubitState = variantImageCubit.state;
//     List<Uint8List> pickedVariantImages = [];
//     if (variantImageCubitState is PickimagePicked) {
//       pickedVariantImages = variantImageCubitState.images;
//     }

//     if (pickedVariantImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please pick at least one image for this variant."),
//         ),
//       );
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Uploading variant images...")),
//     );

//     List<String> variantImageUrls = [];
//     try {
//       variantImageUrls = await _productService.uploadImages(
//         pickedVariantImages,
//       );
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Variant images uploaded.")));
//     } catch (e) {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to upload variant images: $e")),
//       );
//       return;
//     }

//     String variantNameCombined = _currentVariantSelections.keys.join(', ');
//     String variantValueCombined = _currentVariantSelections.values
//         .where((v) => v != null)
//         .join(', ');

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
//       _currentVariantSelections.updateAll(
//         (key, value) => null,
//       ); // Reset variant dropdowns
//     });

//     variantImageCubit.clearImage(); // Clear variant-specific image cubit state
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Variant added!")));
//   }

//   // Function to handle the final product submission
//   void _submitProduct(BuildContext context) async {
//     // Using the main context to find ImageCubit
//     // Validate the main product form fields ONLY here
//     if (!_mainProductFormKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Please fill in all required product details in the main section.",
//           ),
//         ),
//       );
//       return;
//     }

//     if (_selectedCategoryId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a category.")),
//       );
//       return;
//     }

//     if (_selectedBrandId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please select a brand.")));
//       return;
//     }

//     // Ensure at least one product variant has been added
//     if (_productVariants.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please add at least one product variant."),
//         ),
//       );
//       return;
//     }

//     // --- GET SELLER UID ---
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Seller not logged in. Please log in first."),
//         ),
//       );
//       // You might want to navigate to login screen here:
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
//       return;
//     }
//     final String sellerUid = currentUser.uid;
//     // ----------------------

//     // Access the main ImageCubit which is now provided by MultiBlocProvider in main.dart
//     final mainImageCubitState =
//         context
//             .read<ImageCubit>()
//             .state; // This 'context' now cofrrectly finds the main ImageCubit
//     List<Uint8List> mainProductImages = [];
//     if (mainImageCubitState is PickimagePicked) {
//       mainProductImages = mainImageCubitState.images;
//     }

//     if (mainProductImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Please select at least one main image for the product.",
//           ),
//         ),
//       );
//       return;
//     }

//     final product = ProductModel(
//       productName: _productNameController.text.trim(),
//       productDescription: _productDescriptionController.text.trim(),
//       sellerUid: sellerUid, // Using the actual seller UID from Firebase Auth
//       categoryId: _selectedCategoryId!,
//       brandId: _selectedBrandId!,
//       varients:
//           _productVariants, // Product variants already have their image URLs
//       imageUrls:
//           [], // This list will be populated by ProductService after Cloudinary upload
//     );

//     context.read<ProductBloc>().add(
//       AddProductEvent(product, mainProductImages),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Product")),
//       body: BlocListener<ProductBloc, ProductState>(
//         listener: (context, state) {
//           if (state is ProductLoadingState) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text("Adding product...")));
//           } else if (state is ProductAddedState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Product added successfully!")),
//             );
//             _productNameController.clear();
//             _productDescriptionController.clear();
//             setState(() {
//               _selectedCategoryId = null;
//               _selectedBrandId = null;
//               _productVariants.clear();
//               _currentVariantSelections.clear();
//             });
//             // The main ImageCubit is accessible from this context because it's in main.dart
//             context.read<ImageCubit>().clearImage();
//           } else if (state is ProductErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Error adding product: ${state.error}")),
//             );
//           }
//         },
//         // IMPORTANT: The main ImageCubit is now provided in main.dart,
//         // so no BlocProvider is needed here for the main ImageCubit.
//         child: Form(
//           // This is the main product form
//           key: _mainProductFormKey, // Use the main form key here
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
//                   minLine: 3,
//                   label: "Product Description",
//                   hintText: "Enter Product Description",
//                   controller: _productDescriptionController,

//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Product description cannot be empty";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Category Dropdown
//                 const Text(
//                   "Select Category",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: ProductService.categoriesRef.snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasError) {
//                       return Text(
//                         'Error loading categories: ${snapshot.error}',
//                       );
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Text(
//                         'No categories available. Please add categories in Admin App.',
//                       );
//                     }

//                     final categories = snapshot.data!.docs;
//                     return DropdownButtonFormField<String>(
//                       value: _selectedCategoryId,
//                       hint: const Text("Choose category"),
//                       isExpanded: true,
//                       items:
//                           categories.map((doc) {
//                             final categoryName =
//                                 doc["Name"] as String? ?? "Unnamed Category";
//                             return DropdownMenuItem<String>(
//                               value: doc.id,
//                               child: Text(categoryName),
//                             );
//                           }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedCategoryId = value;
//                           _currentVariantSelections
//                               .clear(); // Clear variant selections on category change
//                           _productVariants
//                               .clear(); // Clear previously added variants
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
//                 const Text(
//                   "Select Brand",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: ProductService.brandsRef.snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//                     if (snapshot.hasError) {
//                       return Text('Error loading brands: ${snapshot.error}');
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Text(
//                         'No brands available. Please add brands in Admin App.',
//                       );
//                     }

//                     final brands = snapshot.data!.docs;
//                     return DropdownButtonFormField<String>(
//                       value: _selectedBrandId,
//                       hint: const Text("Choose brand"),
//                       isExpanded: true,
//                       items:
//                           brands.map((doc) {
//                             final brandName =
//                                 doc["name"] as String? ?? "Unnamed Brand";
//                             return DropdownMenuItem<String>(
//                               value: doc.id,
//                               child: Text(brandName),
//                             );
//                           }).toList(),
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

//                 // --- Dynamic Product Variants Section ---
//                 if (_selectedCategoryId != null) ...[
//                   const Divider(),
//                   const Text(
//                     "Product Variants",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   FutureBuilder<DocumentSnapshot>(
//                     future:
//                         ProductService.categoriesRef
//                             .doc(_selectedCategoryId)
//                             .get(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       }
//                       if (snapshot.hasError) {
//                         return Text(
//                           'Error loading category variant options: ${snapshot.error}',
//                         );
//                       }
//                       if (!snapshot.hasData ||
//                           !snapshot.data!.exists ||
//                           snapshot.data!.data() == null) {
//                         return const Text(
//                           'Selected category details not found or corrupted.',
//                         );
//                       }

//                       final categoryData =
//                           snapshot.data!.data() as Map<String, dynamic>;
//                       final List<CatagoryVarient> categoryVariants =
//                           (categoryData["varientOptions"] as List<dynamic>?)
//                               ?.map(
//                                 (e) => CatagoryVarient.fromMap(
//                                   e as Map<String, dynamic>,
//                                 ),
//                               )
//                               .toList() ??
//                           [];

//                       if (categoryVariants.isEmpty) {
//                         return const Text(
//                           "No variants defined for this category in Admin App.",
//                         );
//                       }

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Divider(),
//                           const Text(
//                             "Define New Variant",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           // New Form for variant input fields, separating its validation from main form
//                           Form(
//                             key:
//                                 _variantFormKey, // Use the separate variant form key
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ...categoryVariants.map((catVariant) {
//                                   if (!_currentVariantSelections.containsKey(
//                                     catVariant.name,
//                                   )) {
//                                     _currentVariantSelections[catVariant.name] =
//                                         null;
//                                   }
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 10.0,
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Select ${catVariant.name}",
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         DropdownButtonFormField<String>(
//                                           value:
//                                               _currentVariantSelections[catVariant
//                                                   .name],
//                                           hint: Text(
//                                             "Choose ${catVariant.name}",
//                                           ),
//                                           isExpanded: true,
//                                           items:
//                                               catVariant.options
//                                                   .map(
//                                                     (option) =>
//                                                         DropdownMenuItem<
//                                                           String
//                                                         >(
//                                                           value: option,
//                                                           child: Text(option),
//                                                         ),
//                                                   )
//                                                   .toList(),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _currentVariantSelections[catVariant
//                                                       .name] =
//                                                   value;
//                                             });
//                                           },
//                                           validator: (value) {
//                                             if (value == null) {
//                                               return "Please select a ${catVariant.name}";
//                                             }
//                                             return null;
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                                 const SizedBox(height: 10),
//                                 CustemTextFIeld(
//                                   label: "Quantity",
//                                   hintText: "Enter Quantity",
//                                   controller: _quantityController,

//                                   validator: (value) {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Quantity cannot be empty";
//                                     }
//                                     if (int.tryParse(value) == null) {
//                                       return "Enter a valid number";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 10),
//                                 CustemTextFIeld(
//                                   label: "Regular Price",
//                                   hintText: "Enter Regular Price",
//                                   controller: _regularPriceController,

//                                   validator: (value) {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Regular price cannot be empty";
//                                     }
//                                     if (int.tryParse(value) == null) {
//                                       return "Enter a valid number";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 10),
//                                 CustemTextFIeld(
//                                   label: "Selling Price",
//                                   hintText: "Enter Selling Price",
//                                   controller: _sellingPriceController,

//                                   validator: (value) {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Selling price cannot be empty";
//                                     }
//                                     if (int.tryParse(value) == null) {
//                                       return "Enter a valid number";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 10),
//                                 CustemTextFIeld(
//                                   label: "Buying Price",
//                                   hintText: "Enter Buying Price",
//                                   controller: _buyingPriceController,

//                                   validator: (value) {
//                                     if (value == null || value.trim().isEmpty) {
//                                       return "Buying price cannot be empty";
//                                     }
//                                     if (int.tryParse(value) == null) {
//                                       return "Enter a valid number";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ), // End of Variant Form (_variantFormKey)
//                           // This Builder provides the correct context for the variant's ImageCubit
//                           BlocProvider<ImageCubit>(
//                             create: (_) => ImageCubit(),
//                             child: Builder(
//                               // Builder to get BuildContext specific to this BlocProvider's subtree
//                               builder: (variantImageContext) {
//                                 // This 'variantImageContext' is the one we need for the variant's ImageCubit
//                                 return Column(
//                                   // Wrap the image picker UI in a Column
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "Variant Images",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10),
//                                     BlocBuilder<ImageCubit, PickimageState>(
//                                       builder: (context, state) {
//                                         // This 'context' is the local context for BlocBuilder
//                                         if (state is PickimageInitial) {
//                                           return ElevatedButton.icon(
//                                             onPressed:
//                                                 () =>
//                                                     variantImageContext
//                                                         .read<ImageCubit>()
//                                                         .pickImage(),
//                                             icon: const Icon(Icons.image),
//                                             label: const Text(
//                                               "Pick Images for this Variant",
//                                             ),
//                                           );
//                                         } else if (state is PickimagePicked) {
//                                           return Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Wrap(
//                                                 spacing: 8,
//                                                 runSpacing: 8,
//                                                 children:
//                                                     state.images
//                                                         .asMap()
//                                                         .entries
//                                                         .map(
//                                                           (entry) => Stack(
//                                                             alignment:
//                                                                 Alignment
//                                                                     .topRight,
//                                                             children: [
//                                                               Container(
//                                                                 decoration: BoxDecoration(
//                                                                   border: Border.all(
//                                                                     color:
//                                                                         Colors
//                                                                             .grey,
//                                                                   ),
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                         8,
//                                                                       ),
//                                                                 ),
//                                                                 child: ClipRRect(
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                         8,
//                                                                       ),
//                                                                   child: Image.memory(
//                                                                     entry.value,
//                                                                     width: 100,
//                                                                     height: 100,
//                                                                     fit:
//                                                                         BoxFit
//                                                                             .cover,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Positioned(
//                                                                 right: -10,
//                                                                 top: -10,
//                                                                 child: IconButton(
//                                                                   icon: const Icon(
//                                                                     Icons
//                                                                         .remove_circle,
//                                                                     color:
//                                                                         Colors
//                                                                             .red,
//                                                                   ),
//                                                                   onPressed: () {
//                                                                     variantImageContext
//                                                                         .read<
//                                                                           ImageCubit
//                                                                         >()
//                                                                         .removeImage(
//                                                                           entry
//                                                                               .key,
//                                                                         );
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         )
//                                                         .toList(),
//                                               ),
//                                               const SizedBox(height: 10),
//                                               ElevatedButton.icon(
//                                                 onPressed:
//                                                     () =>
//                                                         variantImageContext
//                                                             .read<ImageCubit>()
//                                                             .pickImage(),
//                                                 icon: const Icon(
//                                                   Icons.add_a_photo,
//                                                 ),
//                                                 label: const Text(
//                                                   "Add More Variant Images",
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         } else if (state is PickimageError) {
//                                           return Text(
//                                             'Error picking variant image: ${state.error}',
//                                             style: const TextStyle(
//                                               color: Colors.red,
//                                             ),
//                                           );
//                                         } else {
//                                           return const SizedBox.shrink();
//                                         }
//                                       },
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ), // Spacing after image picker
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: ElevatedButton.icon(
//                                         // Correctly pass the Cubit instance from its specific context
//                                         onPressed:
//                                             () => _addVariant(
//                                               variantImageContext
//                                                   .read<ImageCubit>(),
//                                             ),
//                                         icon: const Icon(Icons.add),
//                                         label: const Text("Add Variant"),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ), // Spacing after Add Variant button
//                           // Display the list of already added product variants
//                           if (_productVariants.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Added Product Variants:",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: _productVariants.length,
//                                   itemBuilder: (context, index) {
//                                     final variant = _productVariants[index];
//                                     return Card(
//                                       margin: const EdgeInsets.only(bottom: 8),
//                                       child: ListTile(
//                                         title: Text(
//                                           "${variant.variantName}: ${variant.variantValue}",
//                                         ),
//                                         subtitle: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Qty: ${variant.quantity}, Reg: ${variant.regularPrice}, Sell: ${variant.sellingPrice}, Buy: ${variant.buyingPrice}",
//                                             ),
//                                             if (variant.variantImageUrls !=
//                                                     null &&
//                                                 variant
//                                                     .variantImageUrls!
//                                                     .isNotEmpty)
//                                               Text(
//                                                 "Images: ${variant.variantImageUrls!.length} selected",
//                                               ),
//                                           ],
//                                         ),
//                                         trailing: IconButton(
//                                           icon: const Icon(
//                                             Icons.delete,
//                                             color: Colors.red,
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               _productVariants.removeAt(index);
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                   const Divider(),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Main Product Images",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   BlocBuilder<ImageCubit, PickimageState>(
//                     builder: (context, state) {
//                       if (state is PickimageInitial) {
//                         return ElevatedButton.icon(
//                           onPressed:
//                               () => context.read<ImageCubit>().pickImage(),
//                           icon: const Icon(Icons.image),
//                           label: const Text("Pick Main Images"),
//                         );
//                       } else if (state is PickimagePicked) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children:
//                                   state.images
//                                       .asMap()
//                                       .entries
//                                       .map(
//                                         (entry) => Stack(
//                                           alignment: Alignment.topRight,
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   color: Colors.grey,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 child: Image.memory(
//                                                   entry.value,
//                                                   width: 100,
//                                                   height: 100,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                             Positioned(
//                                               right: -10,
//                                               top: -10,
//                                               child: IconButton(
//                                                 icon: const Icon(
//                                                   Icons.remove_circle,
//                                                   color: Colors.red,
//                                                 ),
//                                                 onPressed: () {
//                                                   context
//                                                       .read<ImageCubit>()
//                                                       .removeImage(entry.key);
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                       .toList(),
//                             ),
//                             const SizedBox(height: 10),
//                             ElevatedButton.icon(
//                               onPressed:
//                                   () => context.read<ImageCubit>().pickImage(),
//                               icon: const Icon(Icons.add_a_photo),
//                               label: const Text("Add More Main Images"),
//                             ),
//                           ],
//                         );
//                       } else if (state is PickimageError) {
//                         return Text(
//                           'Error picking main image: ${state.error}',
//                           style: const TextStyle(color: Colors.red),
//                         );
//                       } else {
//                         return const SizedBox.shrink();
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed:
//                           () => _submitProduct(
//                             context,
//                           ), // This 'context' is the AddProductScreen's context
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       child: BlocBuilder<ProductBloc, ProductState>(
//                         builder: (context, state) {
//                           if (state is ProductLoadingState) {
//                             return const CircularProgressIndicator(
//                               color: Colors.white,
//                             );
//                           }
//                           return const Text(
//                             "Submit Product",
//                             style: TextStyle(fontSize: 18),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
