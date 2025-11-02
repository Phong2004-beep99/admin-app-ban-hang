import 'package:ecommerce_app_1/containers/additional_confirm.dart';
import 'package:ecommerce_app_1/controllers/db_service.dart';
import 'package:ecommerce_app_1/models/product_model.dart';
import 'package:ecommerce_app_1/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sản phẩm"),),
      body: Consumer<AdminProvider>(builder: (context, value, child) {
        List<ProductsModel> products = ProductsModel.fromJsonList(value.products) as List<ProductsModel>;

        if (products.isEmpty) {
          return Center(child: Text("Không tìm thấy sản phẩm"),);
        }

        return ListView.builder(itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              onLongPress: () {
                showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    title: Text("Chọn hành động"),
                    content: Text("Xóa không thể hoàn tác"),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                        showDialog(context: context, builder: (context) =>
                          AdditionalConfirm(contentText: "Bạn có chắc chắn muốn xóa sản phẩm này",
                            onYes: () {
                              DbService().deleteProduct(docId: products[index].id);
                              Navigator.pop(context);
                            }, onNo: () {
                              Navigator.pop(context);
                            })
                        );
                      }, child: Text("Xóa sản phẩm")),
                      TextButton(onPressed: () {}, child: Text("Chỉnh sửa sản phẩm")),
                    ],
                  ));
              },
              onTap: () => Navigator.pushNamed(context, "/view_product", arguments: products[index]),
              leading: Container(height: 50, width: 50,
                child: Image.network(products[index].image),),
              title: Text(products[index].name, maxLines: 2, overflow: TextOverflow.ellipsis,),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${products[index].new_price.toString()}₫"),
                  Container(padding: EdgeInsets.all(4), color: Theme.of(context).primaryColor, child: Text(products[index].category.toUpperCase(), style: TextStyle(color: Colors.white),))
                ],
              ),
              trailing: IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {
                Navigator.pushNamed(context, "/add_product", arguments: products[index]);
              },),
            );
          },);
      },),

      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/add_product");
        },),
    );
  }
}
