import 'package:ecommerce_app_1/containers/dashboard_chart.dart';
import 'package:ecommerce_app_1/containers/dashboard_text.dart';
import 'package:ecommerce_app_1/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thống kê", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DashboardText(keyword: "Tổng số Danh mục", value: "${adminProvider.categories.length}"),
                    DashboardText(keyword: "Tổng số Sản phẩm", value: "${adminProvider.products.length}"),
                    DashboardText(keyword: "Tổng số Đơn hàng", value: "${adminProvider.totalOrders}"),
                    DashboardText(keyword: "Đơn hàng chưa giao", value: "${adminProvider.orderPendingProcess}"),
                    DashboardText(keyword: "Đơn hàng đang giao", value: "${adminProvider.ordersOnTheWay}"),
                    DashboardText(keyword: "Đơn hàng đã giao", value: "${adminProvider.ordersDelivered}"),
                    DashboardText(keyword: "Đơn hàng đã hủy", value: "${adminProvider.ordersCancelled}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            DashboardChart(
              pending: adminProvider.orderPendingProcess,
              onTheWay: adminProvider.ordersOnTheWay,
              delivered: adminProvider.ordersDelivered,
              cancelled: adminProvider.ordersCancelled,
            ),
          ],
        ),
      ),
    );
  }
}
