import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/features/coupens/cubit/current_coupen_fields_cubit.dart';
import 'package:techmart_seller/features/coupens/presentation/widgets/coupen_form_widget.dart';

import 'package:techmart_seller/features/coupens/presentation/widgets/coupen_list_widget.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: BlocProvider(
              create: (context) => CurrentCoupenFieldsCubit(),
              child: CouponForm(),
            ),
          ),
          Expanded(flex: 2, child: CouponListWidget()),
        ],
      ),
    );
  }
}
