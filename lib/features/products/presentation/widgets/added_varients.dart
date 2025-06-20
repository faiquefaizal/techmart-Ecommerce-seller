import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';

class AddedVarients extends StatelessWidget {
  const AddedVarients({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductVarientCubit, ProductVarientState>(
      builder: (context, state) {
        if (state is ProductVarientInitial) {
          return SizedBox.shrink();
        }
        if (state is ProductVarintLoaded) {
          final rawImages =
              context.read<ProductVarientCubit>().rawVariantImagesLists;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Add Products Varient",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.productVarient.length,
                itemBuilder: (context, index) {
                  final image = rawImages[index]!;
                  final varient = state.productVarient[index];
                  final varientName = varient.variantAttributes.entries
                      .map((e) => "${e.key}:${e.value}")
                      .join(", ");
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          image[0],
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      title: Text(
                        varientName,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity: ${varient.quantity}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Regular Price: ${varient.regularPrice}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Selling Price: ${varient.sellingPrice}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Buying Price: ${varient.buyingPrice}',
                            style: TextStyle(fontSize: 20),
                          ),

                          Text(
                            'Images: ${image.length}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 24),
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
    );
  }
}
