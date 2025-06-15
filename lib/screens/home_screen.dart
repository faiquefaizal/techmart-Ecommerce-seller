import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:techmart_seller/screens/categaries_screen.dart';
import 'package:techmart_seller/screens/sample.dart';
import 'dashboard_screen.dart';
import 'products_screen.dart';
import 'add_product_screen.dart';
import 'orders_screen.dart';
import 'returns_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

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
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                DashboardScreen(),
                Sample(),
                // AddProductScreen(),
                // EditProductScreen(),
                OrdersScreen(),
                ReturnsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
