import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:techmart_seller/features/dashboard/presentation/widgets/card_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardInitial) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is DataLoaded) {
          return GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              custemCard(
                'Total Products',
                '${state.productCount}',
                Icons.inventory,
              ),
              custemCard(
                'Total Orders',
                '${state.orderCount}',
                Icons.shopping_cart,
              ),
              custemCard(
                'Approved Returns',
                '${state.returnCount}',
                Icons.sync,
              ),
            ],
          );
        }
        return Center(child: Text("Loading..."));
      },
    );
  }
}
