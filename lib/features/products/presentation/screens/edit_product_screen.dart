import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/dropdown/cubit/dropdown_cubit.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
import 'package:techmart_seller/core/widgets/fire_store_dropdown.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
import 'package:techmart_seller/features/products/bloc/product_event.dart';
import 'package:techmart_seller/features/products/bloc/product_state.dart';

import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/presentation/widgets/added_varients.dart';
import 'package:techmart_seller/features/products/presentation/widgets/edit_add_varient_button.dart';
import 'package:techmart_seller/features/products/presentation/widgets/product_discroption_card.dart';
import 'package:techmart_seller/features/products/presentation/widgets/product_varient_form.dart';
import 'package:techmart_seller/features/products/presentation/widgets/update_added_varients.dart';
import 'package:techmart_seller/features/products/presentation/widgets/update_product_button.dart';

import 'package:techmart_seller/features/products/presentation/widgets/varient_image_picker.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel product;
  final VoidCallback onBack;

  EditProductScreen({super.key, required this.product, required this.onBack});

  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  TextEditingController quantityController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Corrected typo
  void _resetForm(BuildContext context) {
    productNameController.clear();
    productDescriptionController.clear();
    quantityController.clear();
    _regularPriceController.clear();
    _sellingPriceController.clear();
    _buyingPriceController.clear();

    context.read<CatagoryCubit>().clear();
    context.read<CurrentVarientCubit>().clearInputs();
    context.read<ProductVarientCubit>().clearAllVariants();
    context.read<ImageCubit>().clearImage();
  }

  @override
  Widget build(BuildContext context) {
    productNameController = TextEditingController(text: product.productName);
    productDescriptionController = TextEditingController(
      text: product.productDescription,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductVarientCubit>().fillProductVarient(product.varients);
      context.read<CurrentVarientCubit>().updateBrandIdAndCategoryId(
        product.brandId,
        product.categoryId,
      );
    });
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductEditedState) {
          log("product Added state");
          custemSnakbar(context, "Product Editted successfully!", Colors.green);
          _resetForm(context);
          onBack();
        } else if (state is ProductErrorState) {
          custemSnakbar(context, "Error: ${state.error}", Colors.red);
        }
      },

      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Product",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ProductDiscriptionCard(
                      productDescriptionController:
                          productDescriptionController,
                      productNameController: productNameController,
                    ),
                    SizedBox(height: 16),
                    ProductVarientForm(
                      quantityController: quantityController,
                      buyingPriceController: _buyingPriceController,
                      regularPriceController: _regularPriceController,
                      sellingPriceController: _sellingPriceController,
                    ),
                    const SizedBox(height: 16),
                    VarientImagePicker(),
                    SizedBox(height: 16),
                    EditAddVariantButton(
                      formKey: _formKey,
                      buyingPriceController: _buyingPriceController,
                      quantityController: quantityController,
                      regularPriceController: _regularPriceController,
                      sellingPriceController: _sellingPriceController,
                    ),
                    SizedBox(height: 16),
                    UpdateAddedVarients(),
                    SizedBox(height: 16),
                    EditProductButton(
                      formKey: _formKey,
                      productNameController: productNameController,
                      productDescriptionController:
                          productDescriptionController,
                      product: product,
                    ),
                    // BlocBuilder<ProductVarientCubit, ProductVarientState>(
                    // builder: (context, variantState) {
                    //   // final hasVariants =
                    //   // variantState is ProductVarintLoaded &&
                    //   // variantState.productVarient.isNotEmpty;
                    //   return ElevatedButton(
                    //     onPressed: () {
                    //       if (!_formKey.currentState!.validate()) {
                    //         custemSnakbar(
                    //           context,
                    //           "Please fill product name and description correctly",
                    //           Colors.red,
                    //         );
                    //         return;
                    //       }
                    //       final inputData =
                    //           context.read<CurrentVarientCubit>().state;
                    //       if (inputData.categoryId == null) {
                    //         custemSnakbar(
                    //           context,
                    //           "Please select a Category for the product",
                    //           Colors.red,
                    //         );
                    //         return;
                    //       }
                    //       if (inputData.brandId == null) {
                    //         custemSnakbar(
                    //           context,
                    //           "Please select a Brand for the product",
                    //           Colors.red,
                    //         );
                    //         return;
                    //       }

                    //       final productdeisc =
                    //           productDescriptionController.text.trim();
                    //       final productName =
                    //           productNameController.text.trim();
                    //       // log(brandId ?? "bradn is null");
                    //       // log(catagoryId ?? "cat is null");
                    //       final sellerId = ProductService.userUid;
                    //       log("$productdeisc  $productName  $sellerId  ");
                    //       final varientImageList =
                    //           context
                    //               .read<ProductVarientCubit>()
                    //               .rawVariantImagesLists;
                    //       // log("list${varientImageList.toString()}");
                    //       final varients =
                    //           context
                    //               .read<ProductVarientCubit>()
                    //               .productVarientList;
                    //       for (var valeu in varients) {
                    //         log("vaients${valeu.toString()}");
                    //       }

                    //       final productModel = ProductModel(
                    //         productId: product.productId,
                    //         brandId: inputData.brandId!,
                    //         categoryId: inputData.categoryId!,
                    //         productDescription: productdeisc,
                    //         productName: productName,
                    //         sellerUid: sellerId,
                    //         varients: varients,
                    //       );
                    //       log(productModel.toString());
                    //       log("aFTER");
                    //       for (var valeu in varients) {
                    //         log("vaients${valeu.toString()}");
                    //       }
                    //       // log("list${varientImageList.toString()}");
                    //       log(productModel.toString());
                    //       context.read<ProductBloc>().add(
                    //         EditProductEvent(
                    //           updatedProduct: productModel,
                    //           newVarientList: varientImageList,
                    //         ),
                    //       );
                    //       log("Product Added");
                    //     },
                    //     child: Text("Edit Product"),
                    //   );
                    // },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
