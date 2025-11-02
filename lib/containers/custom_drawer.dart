import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text("Menu Quản Trị", style: TextStyle(color: Colors.white, fontSize: 20)),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("A", style: TextStyle(fontSize: 40.0, color: Colors.blue)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Đơn Hàng"),
            onTap: () => Navigator.pushNamed(context, "/orders"),
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text("Sản Phẩm"),
            onTap: () => Navigator.pushNamed(context, "/products"),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Danh Mục"),
            onTap: () => Navigator.pushNamed(context, "/category"),
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text("Khuyến Mãi"),
            onTap: () => Navigator.pushNamed(context, "/promos", arguments: {"promo": true}),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Biểu Ngữ"),
            onTap: () => Navigator.pushNamed(context, "/promos", arguments: {"promo": false}),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text("Phiếu Giảm Giá"),
            onTap: () => Navigator.pushNamed(context, "/coupons"),
          ),
        ],
      ),
    );
  }
}
