// // techmart_seller/screens/seller_products_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
// import 'package:techmart_seller/features/products/bloc/product_event.dart';
// import 'package:techmart_seller/features/products/bloc/product_state.dart';
// import 'package:techmart_seller/features/products/models/product_model.dart';
// import 'package:techmart_seller/screens/add_product_screen.dart'; // To navigate to add product screen
// // Import your Category model (assuming this is used in seller app)

// class SellerProductsScreen extends StatefulWidget {
//   const SellerProductsScreen({Key? key}) : super(key: key);

//   @override
//   State<SellerProductsScreen> createState() => _SellerProductsScreenState();
// }

// class _SellerProductsScreenState extends State<SellerProductsScreen> {
//   String? _sellerUid;
//   final CollectionReference _categoriesRef = FirebaseFirestore.instance
//       .collection("Catagory");
//   final CollectionReference _brandsRef = FirebaseFirestore.instance.collection(
//     "Brands",
//   ); // Reference to Brands collection

//   @override
//   void initState() {
//     super.initState();
//     _getSellerUidAndFetchProducts();
//   }

//   void _getSellerUidAndFetchProducts() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _sellerUid = user.uid;
//       });
//       context.read<ProductBloc>().add(FetchSellerProductsEvent(_sellerUid!));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Seller not logged in. Please log in to view products.',
//           ),
//         ),
//       );
//       // Optional: Navigate to login screen if user is not logged in
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
//     }
//   }

//   // Function to get Category Name from ID
//   // Assuming CategoryModel is available in the seller app as it's used for product creation
//   Future<String> _getCategoryName(String categoryId) async {
//     try {
//       DocumentSnapshot doc = await _categoriesRef.doc(categoryId).get();
//       if (doc.exists && doc.data() is Map<String, dynamic>) {
//         return (doc.data() as Map<String, dynamic>)['Name'] as String? ??
//             'Unknown Category';
//       }
//       return 'Category Not Found';
//     } catch (e) {
//       return 'Error Category';
//     }
//   }

//   // Function to get Brand Name from ID (without BrandModel in seller app)
//   Future<String> _getBrandName(String brandId) async {
//     try {
//       DocumentSnapshot doc = await _brandsRef.doc(brandId).get();
//       if (doc.exists && doc.data() is Map<String, dynamic>) {
//         // Access 'name' field directly as we don't have a BrandModel
//         return (doc.data() as Map<String, dynamic>)['name'] as String? ??
//             'Unknown Brand';
//       }
//       return 'Brand Not Found';
//     } catch (e) {
//       return 'Error Brand';
//     }
//   }

//   // Confirmation dialog for deleting a product
//   Future<void> _confirmDeleteProduct(
//     BuildContext context,
//     ProductModel product,
//   ) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // User must tap button!
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Delete Product'),
//           content: Text(
//             'Are you sure you want to delete "${product.productName}"? This action cannot be undone.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Dismiss dialog
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//               onPressed: () {
//                 context.read<ProductBloc>().add(DeleteProductEvent(product));
//                 Navigator.of(dialogContext).pop(); // Dismiss dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Products')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const AddProductScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body:
//           _sellerUid == null
//               ? const Center(child: CircularProgressIndicator())
//               : BlocBuilder<ProductBloc, ProductState>(
//                 builder: (context, state) {
//                   if (state is SellerProductsLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is SellerProductsLoaded) {
//                     if (state.products.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           'No products added yet. Click "+" to add one!',
//                         ),
//                       );
//                     }
//                     return ListView.builder(
//                       padding: const EdgeInsets.all(8.0),
//                       itemCount: state.products.length,
//                       itemBuilder: (context, index) {
//                         final product = state.products[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           elevation: 2.0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   product.productName,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   product.productDescription,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(color: Colors.grey[600]),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 // Display Category Name (fetched dynamically)
//                                 FutureBuilder<String>(
//                                   future: _getCategoryName(product.categoryId),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Text('Category: Loading...');
//                                     } else if (snapshot.hasError) {
//                                       return const Text('Category: Error');
//                                     }
//                                     return Text('Category: ${snapshot.data}');
//                                   },
//                                 ),
//                                 // Display Brand Name (fetched dynamically)
//                                 FutureBuilder<String>(
//                                   future: _getBrandName(product.brandId),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Text('Brand: Loading...');
//                                     } else if (snapshot.hasError) {
//                                       return const Text('Brand: Error');
//                                     }
//                                     return Text('Brand: ${snapshot.data}');
//                                   },
//                                 ),
//                                 const SizedBox(height: 8),
//                                 // Display main images (if any)
//                                 if (product.imageUrls != null &&
//                                     product.imageUrls!.isNotEmpty)
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Main Images:',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Wrap(
//                                         spacing: 8.0,
//                                         runSpacing: 4.0,
//                                         children:
//                                             product.imageUrls!
//                                                 .take(
//                                                   3,
//                                                 ) // Show up to 3 main images
//                                                 .map(
//                                                   (url) => Image.network(
//                                                     url,
//                                                     width: 50,
//                                                     height: 50,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder:
//                                                         (
//                                                           context,
//                                                           error,
//                                                           stackTrace,
//                                                         ) => const Icon(
//                                                           Icons.broken_image,
//                                                         ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   'Variants:',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 // Display product variants
//                                 ...product.varients.map((variant) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 8.0,
//                                       top: 4.0,
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${variant.variantName}: ${variant.variantValue}',
//                                         ),
//                                         Text(
//                                           'Qty: ${variant.quantity}, Selling: \$${variant.sellingPrice}',
//                                         ),
//                                         // Display variant-specific images (if any)
//                                         if (variant.variantImageUrls != null &&
//                                             variant
//                                                 .variantImageUrls!
//                                                 .isNotEmpty)
//                                           Wrap(
//                                             spacing: 4.0,
//                                             runSpacing: 2.0,
//                                             children:
//                                                 variant.variantImageUrls!
//                                                     .take(
//                                                       2,
//                                                     ) // Show up to 2 variant images
//                                                     .map(
//                                                       (url) => Image.network(
//                                                         url,
//                                                         width: 30,
//                                                         height: 30,
//                                                         fit: BoxFit.cover,
//                                                         errorBuilder:
//                                                             (
//                                                               context,
//                                                               error,
//                                                               stackTrace,
//                                                             ) => const Icon(
//                                                               Icons
//                                                                   .broken_image,
//                                                               size: 20,
//                                                             ),
//                                                       ),
//                                                     )
//                                                     .toList(),
//                                           ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                                 // Add actions like Edit/Delete
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.edit,
//                                           color: Colors.blue,
//                                         ),
//                                         onPressed: () {
//                                           // TODO: Navigate to an EditProductScreen
//                                           // You would typically pass the product object to the edit screen
//                                           // Navigator.of(context).push(MaterialPageRoute(
//                                           //   builder: (context) => EditProductScreen(product: product),
//                                           // ));
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text(
//                                                 'Edit ${product.productName} (Functionality Coming Soon)',
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                         ),
//                                         onPressed: () {
//                                           _confirmDeleteProduct(
//                                             context,
//                                             product,
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else if (state is SellerProductsError) {
//                     return Center(child: Text('Error: ${state.message}'));
//                   }
//                   return const Center(
//                     child: Text('Unknown state for products.'),
//                   );
//                 },
//               ),
//     );
//   }
// }
