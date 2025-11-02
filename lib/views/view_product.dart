import 'package:ecommerce_app_1/constants/discount.dart';
import 'package:ecommerce_app_1/controllers/assets_service.dart';
import 'package:ecommerce_app_1/models/product_model.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as ProductsModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ảnh sản phẩm tự điều chỉnh kích thước
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300, // Giới hạn chiều cao tối đa
              ),
              child: ImageLoader(imageUrl: arguments.image)
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // Tên sản phẩm
                  Text(
                    arguments.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 10),

                  // Giá sản phẩm và phần trăm giảm giá
                  Row(
                    children: [
                      Text(
                        "${arguments.old_price}₫",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${arguments.new_price}₫",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                      Text(
                        "${discountPercent(arguments.old_price, arguments.new_price)}%",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Tình trạng hàng
                  arguments.maxQuantity == 0
                      ? const Text(
                          "Hết hàng",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
                        )
                      : Text(
                          "Chỉ còn ${arguments.maxQuantity} sản phẩm!",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
                        ),

                  const SizedBox(height: 15),

                  // Mô tả sản phẩm
                  Text(
                    arguments.description,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            // Nút "Thêm vào giỏ"
            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Theme.of(context).primaryColor,
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(vertical: 15),
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            //     ),
            //     child: const Text("Thêm vào giỏ hàng", style: TextStyle(fontSize: 16)),
            //   ),
            // ),
            const SizedBox(width: 10),
            // Nút "Mua ngay"
            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.white,
            //       foregroundColor: Theme.of(context).primaryColor,
            //       padding: const EdgeInsets.symmetric(vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         side: BorderSide(color: Theme.of(context).primaryColor),
            //       ),
            //     ),
            //     child: const Text("Mua ngay", style: TextStyle(fontSize: 16)),
            //   ),
          ],
        ),
      ),
    );
  }
}
