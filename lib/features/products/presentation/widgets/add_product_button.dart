import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/widgets/snakbar_widget.dart';
import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
import 'package:techmart_seller/features/products/bloc/product_event.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';

class SubmitProductButton extends StatelessWidget {
  const SubmitProductButton({
    super.key,
    required this.formKey,
    required this.productNameController,
    required this.productDescriptionController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductVarientCubit, ProductVarientState>(
      builder: (context, variantState) {
        final hasVariants =
            variantState is ProductVarintLoaded &&
            variantState.productVarient.isNotEmpty;

        return ElevatedButton(
          onPressed:
              hasVariants
                  ? () {
                    if (!formKey.currentState!.validate()) {
                      custemSnakbar(
                        context,
                        "Fill product name and description",
                        Colors.red,
                      );
                      return;
                    }

                    final input = context.read<CurrentVarientCubit>().state;
                    if (input.categoryId == null || input.brandId == null) {
                      custemSnakbar(
                        context,
                        "Select brand and category",
                        Colors.red,
                      );
                      return;
                    }

                    final product = ProductModel(
                      productName: productNameController.text.trim(),
                      productDescription:
                          productDescriptionController.text.trim(),
                      brandId: input.brandId!,
                      categoryId: input.categoryId!,
                      sellerUid: ProductService.userUid,
                      varients:
                          context
                              .read<ProductVarientCubit>()
                              .productVarientList,
                    );

                    final images =
                        context
                            .read<ProductVarientCubit>()
                            .rawVariantImagesLists;
                    log(product.toString());

                    context.read<ProductBloc>().add(
                      AddProductEvent(product, images),
                    );
                  }
                  : null,
          child: Text("Add Product"),
        );
      },
    );
  }
}
