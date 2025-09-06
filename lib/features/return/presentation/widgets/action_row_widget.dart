import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/return/bloc/return_bloc.dart';

class ActionRow extends StatelessWidget {
  final String orderId, productId, varientId;
  final int count;
  const ActionRow({
    super.key,
    required this.orderId,
    required this.productId,
    required this.varientId,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            context.read<ReturnBloc>().add(
              AcceptReturn(orderId, productId, varientId, count),
            );
          },

          child: const Text("Approve"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            context.read<ReturnBloc>().add(RejectReturn(orderId));
          },
          child: const Text("Reject"),
        ),
      ],
    );
  }
}
