import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/dropdown/cubit/dropdown_cubit.dart';
import 'package:techmart_seller/core/widgets/fire_store_dropdown.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';

class ProductVarientForm extends StatelessWidget {
  TextEditingController quantityController = TextEditingController();
  TextEditingController regularPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  ProductVarientForm({
    super.key,
    required this.quantityController,
    required this.buyingPriceController,
    required this.regularPriceController,
    required this.sellingPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Variant Details",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            BlocBuilder<CurrentVarientCubit, CurrentVarientState>(
              builder: (context, state) {
                return FireStoreDropdownButton(
                  stream: ProductService.categoriesRef.snapshots(),
                  Seleeted: state.categoryId,
                  dataName: "Categories",
                  labelField: "Name",
                  onChanged: (value) {
                    context.read<CatagoryCubit>().selectCategory(value);
                    context.read<CurrentVarientCubit>().updateCategoryId(value);
                  },
                );
              },
            ),
            SizedBox(height: 10),
            BlocBuilder<CurrentVarientCubit, CurrentVarientState>(
              builder: (context, state) {
                return FireStoreDropdownButton(
                  stream: ProductService.brandsRef.snapshots(),
                  Seleeted: state.brandId,
                  dataName: "Brands",
                  labelField: "name",
                  onChanged: (value) {
                    context.read<CurrentVarientCubit>().updateBrandId(value);
                    // log(
                    //   currentInputState.brandId ?? "brand value from cubic",
                    // );
                  },
                );
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
                                              state.variantAttributes[varients
                                                  .name],
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
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
                                                          child: Text(option),
                                                        ),
                                                  )
                                                  .toList(),
                                          onChanged: (value) {
                                            log(varients.name);
                                            context
                                                .read<CurrentVarientCubit>()
                                                .updateVariantAttribute(
                                                  varients.name,
                                                  value,
                                                );
                                            final varient =
                                                context
                                                    .read<CurrentVarientCubit>()
                                                    .state;

                                            log(
                                              "Check for issue ${varient.variantAttributes}",
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
            BlocBuilder<ProductVarientCubit, ProductVarientState>(
              builder: (context, variantState) {
                final hasVariants =
                    variantState is ProductVarintLoaded &&
                    variantState.productVarient.isNotEmpty;
                return CustemTextFIeld(
                  label: "Quantity",
                  hintText: "Enter Quantity",
                  controller: quantityController,

                  validator:
                      hasVariants
                          ? null
                          : (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Quantity cannot be empty";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProductVarientCubit, ProductVarientState>(
              builder: (context, variantState) {
                final hasVariants =
                    variantState is ProductVarintLoaded &&
                    variantState.productVarient.isNotEmpty;
                return CustemTextFIeld(
                  label: "Regular Price",
                  hintText: "Enter Regular Price",
                  controller: regularPriceController,

                  validator:
                      hasVariants
                          ? null
                          : (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Regular price cannot be empty";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProductVarientCubit, ProductVarientState>(
              builder: (context, variantState) {
                final hasVariants =
                    variantState is ProductVarintLoaded &&
                    variantState.productVarient.isNotEmpty;
                return CustemTextFIeld(
                  label: "Selling Price",
                  hintText: "Enter Selling Price",
                  controller: sellingPriceController,

                  validator:
                      hasVariants
                          ? null
                          : (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Selling price cannot be empty";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<ProductVarientCubit, ProductVarientState>(
              builder: (context, variantState) {
                final hasVariants =
                    variantState is ProductVarintLoaded &&
                    variantState.productVarient.isNotEmpty;
                return CustemTextFIeld(
                  label: "Buying Price",
                  hintText: "Enter Buying Price",
                  controller: buyingPriceController,

                  validator:
                      hasVariants
                          ? null
                          : (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Buying price cannot be empty";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
