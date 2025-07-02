import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
import 'package:techmart_seller/features/products/bloc/product_event.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/new_service.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class EditProductButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;
  final ProductModel product;

  const EditProductButton({
    Key? key,
    required this.formKey,
    required this.productNameController,
    required this.productDescriptionController,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!formKey.currentState!.validate()) {
          custemSnakbar(
            context,
            "Please fill product name and description correctly",
            Colors.red,
          );
          return;
        }
        final inputData = context.read<CurrentVarientCubit>().state;
        if (inputData.categoryId == null) {
          custemSnakbar(
            context,
            "Please select a Category for the product",
            Colors.red,
          );
          return;
        }
        if (inputData.brandId == null) {
          custemSnakbar(
            context,
            "Please select a Brand for the product",
            Colors.red,
          );
          return;
        }

        final productDescription = productDescriptionController.text.trim();
        final productName = productNameController.text.trim();
        final sellerId = ProductService.userUid;

        final varientImageList =
            context.read<ProductVarientCubit>().rawVariantImagesLists;
        final varients = context.read<ProductVarientCubit>().productVarientList;

        final productModel = ProductModel(
          productId: product.productId,
          brandId: inputData.brandId!,
          categoryId: inputData.categoryId!,
          productDescription: productDescription,
          productName: productName,
          sellerUid: sellerId,
        );

        context.read<ProductBloc>().add(
          EditProductEvent(
            updatedProduct: productModel,
            updatedVarient: varients,
            newVarientImageList: varientImageList,
          ),
        );
      },
      child: Text("Edit Product"),
    );
  }
}
