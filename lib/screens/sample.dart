import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/dropdown/cubit/dropdown_cubit.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
import 'package:techmart_seller/core/widgets/fire_store_dropdown.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/products/bloc/bloc/product_bloc.dart';
import 'package:techmart_seller/features/products/bloc/product_event.dart';
import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class Sample extends StatelessWidget {
  Sample({super.key});
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _regularPriceController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _buyinhPriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CatagoryCubit()),
        BlocProvider(create: (context) => CurrentVarientCubit()),
        BlocProvider(create: (context) => ProductVarientCubit()),
        BlocProvider(create: (context) => ImageCubit()),
      ],
      child: Builder(
        builder: (context) {
          final currentInputState = context.read<CurrentVarientCubit>().state;
          String? catagoryId = currentInputState.categoryId;
          String? brandId = currentInputState.brandId;
          // Map<String, String?> currentVarient =
          //     currentInputState.variantAttributes;

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Product",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  CustemTextFIeld(
                    label: "Product Name",
                    hintText: "Enter your Product Name",
                    controller: productNameController,
                  ),
                  CustemTextFIeld(
                    minLine: 3,
                    label: "Product Description",
                    hintText: "Enter Product Disocption",
                    controller: productDescriptionController,
                  ),
                  SizedBox(height: 10),
                  FireStoreDropdown(
                    stream: ProductService.categoriesRef.snapshots(),
                    dataName: "Catagories",
                    labelField: "Name",
                    onChanged: (value) {
                      context.read<CatagoryCubit>().selectCategory(value);
                      context.read<CurrentVarientCubit>().updateCategoryId(
                        value,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  FireStoreDropdown(
                    stream: ProductService.brandsRef.snapshots(),
                    dataName: "Brands",
                    labelField: "name",
                    onChanged: (value) {
                      context.read<CurrentVarientCubit>().updateBrandId(value);
                    },
                  ),
                  SizedBox(height: 10),

                  BlocBuilder<CatagoryCubit, String?>(
                    builder: (context, state) {
                      if (state == null || state.isEmpty) {
                        return SizedBox.shrink();
                      } else {
                        return FutureBuilder(
                          future: ProductService.fetchCatagories(state),

                          builder: (context, snapshot) {
                            log("future //");
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              log("begfore ${snapshot.data.toString()}");
                              return SizedBox();
                            }
                            final varients = snapshot.data!;
                            log("varients ${varients.toString()}");
                            return Column(
                              children:
                                  varients.map((varients) {
                                    log(varients.options.toString());
                                    return BlocProvider(
                                      create: (context) => DropdownCubit(),
                                      child: BlocBuilder<
                                        CurrentVarientCubit,
                                        CurrentVarientState
                                      >(
                                        builder: (context, state) {
                                          return Column(
                                            children: [
                                              DropdownButtonFormField(
                                                hint: Text(varients.name),
                                                value:
                                                    state
                                                        .variantAttributes[varients
                                                        .name],
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                ),
                                                items:
                                                    varients.options
                                                        .map(
                                                          (option) =>
                                                              DropdownMenuItem<
                                                                String
                                                              >(
                                                                value: option,
                                                                child: Text(
                                                                  option,
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                        CurrentVarientCubit
                                                      >()
                                                      .updateVariantAttribute(
                                                        varients.name,
                                                        value,
                                                      );
                                                },
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
                        );
                      }
                    },
                  ),
                  CustemTextFIeld(
                    label: "Quantity",
                    hintText: "Enter Quantity",
                    controller: _quantityController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Quantity cannot be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustemTextFIeld(
                    label: "Regular Price",
                    hintText: "Enter Regular Price",
                    controller: _regularPriceController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Regular price cannot be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustemTextFIeld(
                    label: "Selling Price",
                    hintText: "Enter Selling Price",
                    controller: _buyinhPriceController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Selling price cannot be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustemTextFIeld(
                    label: "Buying Price",
                    hintText: "Enter Buying Price",
                    controller: _sellingPriceController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Buying price cannot be empty";
                      }
                      if (int.tryParse(value) == null) {
                        return "Enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ImageCubit, PickimageState>(
                    builder: (context, state) {
                      if (state is PickimageInitial) {
                        return GestureDetector(
                          onTap: () {
                            context.read<ImageCubit>().pickImage();
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tap to add images',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is PickimagePicked) {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.read<ImageCubit>().pickImage();
                                },
                                icon: Icon(Icons.add),
                                label: Text("Add More"),
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemCount: state.images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Image.memory(
                                        state.images[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<ImageCubit>()
                                              .removeImage(index);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      } else if (state is PickimageError) {
                        custemSnakbar(context, state.error, Colors.red);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final inputState =
                            context.read<CurrentVarientCubit>().state;
                        if (inputState.categoryId == null) {
                          custemSnakbar(
                            context,
                            "Please select a Category",
                            Colors.red,
                          );
                          return;
                        }
                        if (inputState.brandId == null) {
                          custemSnakbar(
                            context,
                            "Please select a Brand",
                            Colors.red,
                          );
                          return;
                        }
                        if (productNameController.text.trim().isEmpty ||
                            productDescriptionController.text.trim().isEmpty) {
                          custemSnakbar(
                            context,
                            "Product name and description cannot be empty",
                            Colors.red,
                          );
                          return;
                        }
                        if (_quantityController.text.trim().isEmpty ||
                            _buyinhPriceController.text.trim().isEmpty ||
                            _sellingPriceController.text.trim().isEmpty ||
                            _regularPriceController.text.trim().isEmpty) {
                          custemSnakbar(
                            context,
                            "All price and quantity fields must be filled",
                            Colors.red,
                          );
                          return;
                        } else {
                          List<Uint8List> images =
                              (context.read<ImageCubit>().currentImages);

                          final ProductVarientModel varientModel =
                              ProductVarientModel(
                                buyingPrice: int.parse(
                                  _buyinhPriceController.text.trim(),
                                ),
                                quantity: int.parse(
                                  _quantityController.text.trim(),
                                ),
                                regularPrice: int.parse(
                                  _regularPriceController.text.trim(),
                                ),
                                sellingPrice: int.parse(
                                  _sellingPriceController.text.trim(),
                                ),
                                variantAttributes: inputState.variantAttributes,
                              );

                          context.read<ProductVarientCubit>().addProductVarient(
                            varientModel,
                            images,
                          );
                          custemSnakbar(
                            context,
                            "Variant added successfully!",
                            Colors.green,
                          );

                          _quantityController.clear();
                          _regularPriceController.clear();
                          _sellingPriceController
                              .clear(); // Corrected controller name
                          _buyinhPriceController
                              .clear(); // Corrected controller name
                          context
                              .read<CurrentVarientCubit>()
                              .clearInputs(); // Reset the input cubit
                          context.read<ImageCubit>().clearImage();
                        }
                      },

                      child: Text("Add Varients"),
                    ),
                  ),
                  BlocBuilder<ProductVarientCubit, ProductVarientState>(
                    builder: (context, state) {
                      if (state is ProductVarientInitial) {
                        return SizedBox.shrink();
                      }
                      if (state is ProductVarintLoaded) {
                        final rawImages =
                            context
                                .read<ProductVarientCubit>()
                                .rawVariantImagesLists;
                        return Column(
                          children: [
                            Text("Add Products Varient"),
                            SizedBox(height: 6),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.productVarient.length,
                              itemBuilder: (context, index) {
                                final image = rawImages[index];
                                final varient = state.productVarient[index];
                                final varientName = varient
                                    .variantAttributes
                                    .entries
                                    .map((e) => "${e.key}:${e.value}")
                                    .join(", ");
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ), // Add margin for card
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.memory(
                                        image[0],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    title: Text(
                                      varientName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Quantity: ${varient.quantity}'),
                                        Text(
                                          'Regular Price: ${varient.regularPrice}',
                                        ),
                                        Text(
                                          'Selling Price: ${varient.sellingPrice}',
                                        ),
                                        Text(
                                          'Buying Price: ${varient.buyingPrice}',
                                        ),

                                        Text('Images: ${image.length}'),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<ProductVarientCubit>()
                                            .deleteProductEvent(index);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final productdeisc =
                          productDescriptionController.text.trim();
                      final productName =
                          productDescriptionController.text.trim();
                      final sellerId = ProductService.userUid;
                      final varientImageList =
                          context
                              .read<ProductVarientCubit>()
                              .rawVariantImagesLists;

                      final varients =
                          context
                              .read<ProductVarientCubit>()
                              .productVarientList;
                      final productModel = ProductModel(
                        brandId: brandId!,
                        categoryId: catagoryId!,
                        productDescription: productdeisc,
                        productName: productName,
                        sellerUid: sellerId!,
                        varients: varients,
                      );
                      context.read<ProductBloc>().add(
                        AddProductEvent(productModel, varientImageList),
                      );
                    },
                    child: Text("Add Product"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
