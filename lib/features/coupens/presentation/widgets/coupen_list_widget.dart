import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:techmart_seller/core/widgets/confirm_alert_dialog.dart';
import 'package:techmart_seller/features/coupens/bloc/coupen_bloc.dart';
import 'package:techmart_seller/features/coupens/cubit/current_coupen_fields_cubit.dart';
import 'package:techmart_seller/features/coupens/models/coupen_model.dart';
import 'package:techmart_seller/features/coupens/presentation/widgets/edit_coupen_widget.dart';

class CouponListWidget extends StatelessWidget {
  final DateFormat dateFormat = DateFormat.yMMMd();

  CouponListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<CoupenBloc, CoupenState>(
        builder: (context, state) {
          if (state is CoupenLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoupenError) {
            return Center(child: Text(state.error));
          } else if (state is CoupensIsEmpty) {
            return const Center(child: Text("No coupons found"));
          } else if (state is CoupenLoaded) {
            final List<SellerCouponModel> coupons = state.coupens;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                alignment: Alignment.topCenter,
                child: DataTable(
                  columnSpacing: 24,
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey.shade300),
                    outside: BorderSide(color: Colors.grey.shade400),
                  ),
                  headingRowColor: WidgetStateProperty.all(
                    Colors.grey.shade100,
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [
                    DataColumn(label: Text("Coupon Name")),
                    DataColumn(label: Text("Start Date")),
                    DataColumn(label: Text("End Date")),
                    DataColumn(label: Text("Offer %")),
                    DataColumn(label: Text("Min Price")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows:
                      coupons.map((coupon) {
                        return DataRow(
                          cells: [
                            DataCell(Text(coupon.couponName)),
                            DataCell(Text(dateFormat.format(coupon.startTime))),
                            DataCell(Text(dateFormat.format(coupon.endTime))),
                            DataCell(Text('${coupon.discountPercentage}%')),
                            DataCell(
                              Text(
                                '₹${coupon.minimumPrice.toStringAsFixed(2)}',
                              ),
                            ),
                            DataCell(
                              Chip(
                                label: Text(
                                  coupon.isActive ? "Live" : "Unlisted",
                                ),
                                backgroundColor:
                                    coupon.isActive
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                labelStyle: TextStyle(
                                  color:
                                      coupon.isActive
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit Coupon',
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => BlocProvider(
                                              create:
                                                  (context) =>
                                                      CurrentCoupenFieldsCubit()
                                                        ..loadFromModel(coupon),
                                              child: EditCouponDialog(
                                                id: coupon.id!,
                                              ),
                                            ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip:
                                        coupon.isActive
                                            ? 'Unlist Coupon'
                                            : 'List Coupon',
                                    icon: Icon(
                                      coupon.isActive
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color:
                                          coupon.isActive
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                    onPressed: () {
                                      context.read<CoupenBloc>().add(
                                        ToggleEvent(coupon),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    tooltip: 'Delete Coupon',
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showALertDialog(context, () {
                                        context.read<CoupenBloc>().add(
                                          DeleteCoupenEvent(coupon.id!),
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
