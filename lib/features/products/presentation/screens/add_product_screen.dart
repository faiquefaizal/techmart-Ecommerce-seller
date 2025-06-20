import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';

import 'package:techmart_seller/core/widgets/snakbar_widget.dart';

import 'package:techmart_seller/features/products/bloc/product_bloc.dart';

import 'package:techmart_seller/features/products/bloc/product_state.dart';

import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';

import 'package:techmart_seller/features/products/presentation/widgets/add_product_button.dart';
import 'package:techmart_seller/features/products/presentation/widgets/add_varient_button.dart';
import 'package:techmart_seller/features/products/presentation/widgets/added_varients.dart';
import 'package:techmart_seller/features/products/presentation/widgets/product_discroption_card.dart';
import 'package:techmart_seller/features/products/presentation/widgets/product_varient_form.dart';
import 'package:techmart_seller/features/products/presentation/widgets/varient_image_picker.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CatagoryCubit()),
        BlocProvider(create: (context) => CurrentVarientCubit()),
        BlocProvider(create: (context) => ProductVarientCubit()),
        BlocProvider(create: (context) => ImageCubit()),
      ],
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAddedState) {
            log("load state called");
            custemSnakbar(context, "Product added successfully!", Colors.green);
            _resetForm(context);
            // Optional: Navigate back to SellerProductsScreen
            // Navigator.pop(context);
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
                        "Add New Product",
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
                      AddVariantButton(
                        formKey: _formKey,
                        buyingPriceController: _buyingPriceController,
                        quantityController: quantityController,
                        regularPriceController: _regularPriceController,
                        sellingPriceController: _sellingPriceController,
                      ),
                      SizedBox(height: 16),
                      AddedVarients(),
                      SizedBox(height: 16),
                      SubmitProductButton(
                        formKey: _formKey,
                        productNameController: productNameController,
                        productDescriptionController:
                            productDescriptionController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
