import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:techmart_seller/core/funtion/date_picker/date_picker.dart';
import 'package:techmart_seller/features/coupens/bloc/coupen_bloc.dart';
import 'package:techmart_seller/features/coupens/cubit/current_coupen_fields_cubit.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';

class EditCouponDialog extends StatelessWidget {
  final DateFormat dateFormat = DateFormat.MEd();
  final String id;
  EditCouponDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Coupon"),
      content: BlocBuilder<CurrentCoupenFieldsCubit, CoupenFieldsUpdated>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: state.couponName,
                decoration: const InputDecoration(labelText: 'Coupon Name'),
                onChanged: context.read<CurrentCoupenFieldsCubit>().updateName,
              ),
              TextFormField(
                initialValue: state.percentage.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Offer %'),
                onChanged: (val) {
                  context.read<CurrentCoupenFieldsCubit>().updatePercentage(
                    double.tryParse(val) ?? 0,
                  );
                },
              ),
              TextFormField(
                initialValue: state.minPrice.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minimun Price'),
                onChanged: (val) {
                  context.read<CurrentCoupenFieldsCubit>().updateMinPrice(
                    double.tryParse(val) ?? 0,
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Start: ${dateFormat.format(state.startDate)}"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await giveSelectedDate(context);
                      if (date != null) {
                        context
                            .read<CurrentCoupenFieldsCubit>()
                            .updateStartDate(date);
                      }
                    },
                    child: const Text("Change"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("End: ${dateFormat.format(state.endDate)}"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await giveSelectedDate(context);
                      if (date != null) {
                        context.read<CurrentCoupenFieldsCubit>().updateEndDate(
                          date,
                        );
                      }
                    },
                    child: const Text("Change"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final state = context.read<CurrentCoupenFieldsCubit>().state;
            final updatedCoupen = SellerCouponModel(
              isActive: state.islive,
              endTime: state.endDate,
              minimumPrice: state.minPrice,
              id: id,
              couponName: state.couponName,
              discountPercentage: state.percentage,
              startTime: state.startDate,
              sellerId: state.sellerId,
            );
            log(updatedCoupen.sellerId!);
            context.read<CoupenBloc>().add(EditCoupenEvent(updatedCoupen));

            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
