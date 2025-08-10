// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
import 'package:techmart_seller/features/authentication/bloc/bloc/auth_bloc.dart';
import 'package:techmart_seller/features/coupens/bloc/coupen_bloc.dart';
import 'package:techmart_seller/features/coupens/presentation/screens/coupen.dart';
import 'package:techmart_seller/features/orders/bloc/order_bloc.dart';
import 'package:techmart_seller/features/orders/service/order_service.dart';
import 'package:techmart_seller/features/products/bloc/product_bloc.dart';
import 'package:techmart_seller/features/products/services/new_service.dart';
import 'package:techmart_seller/features/products/services/product_service.dart';
import 'package:techmart_seller/features/authentication/screens/login_screen.dart';
import 'package:techmart_seller/firebase_options.dart';
import 'package:techmart_seller/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Then run your app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ProductBloc(ProductService())),
        BlocProvider(
          create: (context) => CoupenBloc()..add(FechCoupensEvent()),
        ),
        BlocProvider(
          create: (context) => OrderBloc(OrderService())..add(FetchOrder()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TechMart Seller',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
