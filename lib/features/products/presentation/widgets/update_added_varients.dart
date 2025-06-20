import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_varient_model.dart';

class UpdateAddedVarients extends StatelessWidget {
  const UpdateAddedVarients({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductVarientCubit, ProductVarientState>(
      builder: (context, state) {
        if (state is ProductVarientInitial) {
          return const SizedBox.shrink();
        }
        if (state is ProductVarintLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Added Product Variants",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.productVarient.length,
                itemBuilder: (context, index) {
                  final variant = state.productVarient[index];
                  final urls =
                      state.imageUrlList.length > index
                          ? state.imageUrlList[index]
                          : [];
                  final rawImages =
                      state.imageLIst.length > index
                          ? state.imageLIst[index]
                          : null;
                  final variantName = variant.variantAttributes.entries
                      .map((e) => "${e.key}: ${e.value}")
                      .join(", ");
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              // Changed: Show first available image
                              child:
                                  urls.isNotEmpty
                                      ? Image.network(
                                        urls[0],
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (_, __, ___) =>
                                                const Icon(Icons.error),
                                      )
                                      : rawImages != null &&
                                          rawImages.isNotEmpty
                                      ? Image.memory(
                                        rawImages[0],
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      )
                                      : const Icon(Icons.image, size: 60),
                            ),
                            title: Text(
                              variantName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quantity: ${variant.quantity}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Regular Price: ${variant.regularPrice}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Selling Price: ${variant.sellingPrice}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Buying Price: ${variant.buyingPrice}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 24,
                              ),
                              // Changed: Updated to deleteVariant
                              onPressed: () {
                                context
                                    .read<ProductVarientCubit>()
                                    .deleteProductEvent(index);
                              },
                            ),
                          ),
                          // Changed: Display all images
                          if (urls.isNotEmpty ||
                              (rawImages != null && rawImages.isNotEmpty))
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...urls.map(
                                    (url) => ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        url,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.error,
                                              size: 60,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (rawImages != null)
                                    ...rawImages.map(
                                      (image) => ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          image,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
