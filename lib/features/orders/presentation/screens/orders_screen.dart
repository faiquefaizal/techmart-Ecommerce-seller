import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/orders/bloc/order_bloc.dart';
import 'package:techmart_seller/features/orders/presentation/screens/empty_order_screen.dart';
import 'package:techmart_seller/features/orders/presentation/screens/orders_list_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderEmptyState) {
          return EmptyOrderScreen();
        } else if (state is OrdersLoaded) {
          return OrdersListScreen(orders: state.orders);
        } else if (state is ErrorState) {
          log(state.message);
        }
        return SizedBox.shrink();
      },
    );
  }
}
