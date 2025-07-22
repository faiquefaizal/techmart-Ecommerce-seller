import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:techmart_seller/core/funtion/date_picker/date_picker.dart';
import 'package:techmart_seller/core/widgets/dialog_widget.dart';
import 'package:techmart_seller/core/widgets/text_fields.dart';
import 'package:techmart_seller/features/coupens/bloc/coupen_bloc.dart';
import 'package:techmart_seller/features/coupens/cubit/current_coupen_fields_cubit.dart';
import 'package:techmart_seller/features/coupens/helper_funtion/clear_funtion.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';

class CouponForm extends StatelessWidget {
  CouponForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final percentageController = TextEditingController();
  final minPriceController = TextEditingController();

  final DateFormat dateFormat = DateFormat.yMMMd();
  final startController = TextEditingController();
  final endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentstate = context.read<CurrentCoupenFieldsCubit>().state;
    startController.text = dateFormat.format(currentstate.startDate);
    endController.text = dateFormat.format(currentstate.endDate);
    return BlocListener<CoupenBloc, CoupenState>(
      listener: (context, state) {
        if (state is CoupenAdding) {
          loadingDialog(context, "Coupens Adding");
        } else if (state is CoupenAdded) {
          context.read<CurrentCoupenFieldsCubit>().reset();
          resetForm([nameController, percentageController, minPriceController]);
          Navigator.of(context).pop();
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustemTextFIeld(
                label: "Coupon Code",
                hintText: "Enter your Coupon Name",
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter coupon code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustemTextFIeld(
                controller: startController,
                label: "Start Date",
                hintText: "Pick the Start Date",
                readOnly: true,
                onTap: () async {
                  final pickedDate = await giveSelectedDate(context);
                  if (pickedDate != null) {
                    context.read<CurrentCoupenFieldsCubit>().updateStartDate(
                      pickedDate,
                    );
                    startController.text = dateFormat.format(pickedDate);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Start date required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustemTextFIeld(
                controller: endController,
                label: "End Date",
                hintText: "Pick the End Date",
                readOnly: true,
                onTap: () async {
                  final picked = await giveSelectedDate(context);
                  if (picked != null) {
                    context.read<CurrentCoupenFieldsCubit>().updateEndDate(
                      picked,
                    );
                    endController.text = dateFormat.format(picked);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'End date required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustemTextFIeld(
                hintText: "Enter the percentage discount",
                label: "Percentage %",
                controller: percentageController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val <= 0 || val > 100) {
                    return 'Enter a valid percentage (1-100)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustemTextFIeld(
                label: "Minimum Price",
                hintText: "Enter the minimum order price",
                controller: minPriceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val < 0) {
                    return 'Enter a valid minimum price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final field =
                        context.read<CurrentCoupenFieldsCubit>().state;
                    final name = nameController.text.trim();
                    final percent = double.parse(percentageController.text);
                    final minPrice = double.parse(minPriceController.text);
                    final start = field.startDate;
                    final end = field.endDate;

                    final couponModel = SellerCouponModel(
                      minimumPrice: minPrice,
                      couponName: name,
                      discountPercentage: percent,
                      startTime: start,
                      endTime: end,
                      isActive: true,
                    );

                    context.read<CoupenBloc>().add(AddCoupenEvent(couponModel));
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
