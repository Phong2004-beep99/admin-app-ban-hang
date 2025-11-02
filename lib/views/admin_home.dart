import 'package:ecommerce_app_1/containers/custom_drawer.dart';
import 'package:ecommerce_app_1/containers/dashboard_text.dart';
import 'package:ecommerce_app_1/containers/home_button.dart';
import 'package:ecommerce_app_1/controllers/auth_serivce.dart';
import 'package:ecommerce_app_1/providers/admin_provider.dart';
import 'package:ecommerce_app_1/views/dashboard_page.dart';
import 'package:ecommerce_app_1/views/order_page.dart';
import 'package:ecommerce_app_1/views/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    OrdersPage(),
    ProductsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 90, 129, 181),
        title: Text("Trang quản trị", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<AdminProvider>(context, listen: false).cancelProvider();
              await AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://www.pngmart.com/files/21/Admin-Profile-Vector-PNG-Image.png"),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Bảng điều khiển",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Đơn hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Sản phẩm",
          ),
        ],
      ),
    );
  }
}