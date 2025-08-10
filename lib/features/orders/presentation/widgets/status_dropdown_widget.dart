import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/orders/bloc/order_bloc.dart';

import 'package:techmart_seller/features/orders/models/status.dart';

class StatusDropdownWidget extends StatelessWidget {
  final String currentStatus;
  final String id;

  const StatusDropdownWidget({
    super.key,
    required this.currentStatus,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final statusNames = OrderStatus.values.map((e) => e.name).toList();
    return SizedBox(
      width: 150,
      child: DropdownButton<String>(
        value:
            statusNames.contains(currentStatus)
                ? currentStatus
                : statusNames.first,
        style: TextStyle(color: Colors.black),
        items:
            OrderStatus.values.map((value) {
              return DropdownMenuItem<String>(
                value: value.name,

                child: Text(value.name, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<OrderBloc>().add(UpdateStaus(value, id));
          }
        },
      ),
    );
  }
}
