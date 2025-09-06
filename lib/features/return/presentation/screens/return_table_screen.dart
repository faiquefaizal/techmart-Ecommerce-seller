import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/common_funtion.dart';
import 'package:techmart_seller/features/orders/models/order_status.dart';

import 'package:techmart_seller/features/orders/presentation/widgets/status_dropdown_widget.dart';
import 'package:techmart_seller/features/orders/presentation/widgets/view_order_details.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';
import 'package:techmart_seller/features/return/bloc/return_bloc.dart';
import 'package:techmart_seller/features/return/presentation/widgets/table_heading.dart';
import 'package:techmart_seller/features/return/presentation/widgets/table_row.dart';
import 'package:techmart_seller/features/return/util/funtions/helper_funtions.dart';

class ReturnTableScreen extends StatelessWidget {
  final List<OrderModel> orders;
  const ReturnTableScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 50,

            columns: tableHeading,
            rows:
                orders.map((order) {
                  return tableRow(order, context);
                }).toList(),
          ),
        ),
      ),
    );
  }
}
