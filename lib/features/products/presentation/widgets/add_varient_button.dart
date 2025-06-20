import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';

class AddVariantButton extends StatelessWidget {
  const AddVariantButton({
    super.key,
    required this.formKey,
    required this.buyingPriceController,
    required this.quantityController,
    required this.regularPriceController,
    required this.sellingPriceController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController buyingPriceController;
  final TextEditingController quantityController;
  final TextEditingController regularPriceController;
  final TextEditingController sellingPriceController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          final inputState = context.read<CurrentVarientCubit>().state;

          if (!formKey.currentState!.validate()) {
            custemSnakbar(
              context,
              "Please fill all required fields",
              Colors.red,
            );
            return;
          }

          if (inputState.categoryId == null || inputState.brandId == null) {
            custemSnakbar(
              context,
              "Please select category and brand",
              Colors.red,
            );
            return;
          }

          final images = context.read<ImageCubit>().currentImages;
          if (images.isEmpty) {
            custemSnakbar(context, "Add at least one image", Colors.red);
            return;
          }

          if (inputState.variantAttributes.isEmpty) {
            custemSnakbar(
              context,
              "Select at least one variant attribute",
              Colors.red,
            );
            return;
          }

          final model = ProductVarientModel(
            buyingPrice: int.parse(buyingPriceController.text.trim()),
            quantity: int.parse(quantityController.text.trim()),
            regularPrice: int.parse(regularPriceController.text.trim()),
            sellingPrice: int.parse(sellingPriceController.text.trim()),
            variantAttributes: inputState.variantAttributes,
          );

          context.read<ProductVarientCubit>().addProductVarient(model, images);
          context.read<ImageCubit>().clearImage();
          context.read<CurrentVarientCubit>().clearInputs();
          buyingPriceController.clear();
          quantityController.clear();
          regularPriceController.clear();
          sellingPriceController.clear();

          custemSnakbar(context, "Variant added!", Colors.green);
        },
        child: Text("Add Variant"),
      ),
    );
  }
}
