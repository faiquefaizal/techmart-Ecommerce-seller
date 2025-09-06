import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/return/bloc/return_bloc.dart';
import 'package:techmart_seller/features/return/presentation/screens/return_table_screen.dart';

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReturnBloc, ReturnState>(
        builder: (context, state) {
          if (state is ErrorState) {
            return Center(child: Text(state.toString()));
          }
          if (state is EmptyReturnState) {
            return Center(child: Text("No Returns"));
          }
          if (state is ReturnFetchedState) {
            return ReturnTableScreen(orders: state.orders);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
