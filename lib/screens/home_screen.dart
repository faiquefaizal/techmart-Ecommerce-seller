import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/pick_images/cubit/image_cubit.dart';
import 'package:techmart_seller/features/coupens/presentation/screens/coupen.dart';
import 'package:techmart_seller/features/orders/presentation/screens/orders_screen.dart';
import 'package:techmart_seller/features/products/cubit/catagory_cubit.dart';
import 'package:techmart_seller/features/products/cubit/product_varient_cubit.dart';
import 'package:techmart_seller/features/products/models/product_model.dart';
import 'package:techmart_seller/features/products/presentation/screens/add_product_screen.dart';
import 'package:techmart_seller/features/products/presentation/screens/edit_product_screen.dart';
import 'package:techmart_seller/features/products/presentation/screens/products_screen.dart';
import 'package:techmart_seller/features/products/product_varients/cubit/current_varient_cubit.dart';

import 'dashboard_screen.dart';

import 'returns_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  ProductModel? editingProduct;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.blue[200],
              selectedTitleTextStyle: const TextStyle(color: Colors.black),
              selectedIconColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
            ),
            title: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Seller Panel', style: TextStyle(fontSize: 20)),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.dashboard),
              ),
              SideMenuItem(
                title: 'Products',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.list_alt),
              ),
              SideMenuItem(
                title: 'Add Product',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.add_box),
              ),
              SideMenuItem(
                title: 'Categories',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.category),
              ),
              SideMenuItem(
                title: 'Orders',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.shopping_cart),
              ),
              SideMenuItem(
                title: 'Returns & Refunds',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.undo),
              ),
              SideMenuItem(
                title: 'Coupens',
                onTap: (index, _) => pageController.jumpToPage(index),
                icon: Icon(Icons.local_offer),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                DashboardScreen(),
                ProductsScreen(
                  onEdit: (product) {
                    setState(() {
                      editingProduct = product;
                    });
                    pageController.jumpToPage(6);
                  },
                ),
                AddProductScreen(),
                OrdersScreen(),

                ReturnsScreen(),
                CouponScreen(),
                if (editingProduct != null)
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => CatagoryCubit()),
                      BlocProvider(create: (_) => CurrentVarientCubit()),
                      BlocProvider(create: (_) => ProductVarientCubit()),
                      BlocProvider(create: (_) => ImageCubit()),
                    ],
                    child: EditProductScreen(
                      product: editingProduct!,
                      onBack: () {
                        setState(() {
                          editingProduct = null;
                        });
                        pageController.jumpToPage(1); // Back to products page
                      },
                    ),
                  )
                else
                  const Center(child: Text("No product selected to edit")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
