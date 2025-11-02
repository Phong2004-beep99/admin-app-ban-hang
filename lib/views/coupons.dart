import 'package:ecommerce_app_1/containers/additional_confirm.dart';
import 'package:ecommerce_app_1/controllers/db_service.dart';
import 'package:ecommerce_app_1/models/coupon_model.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mã giảm giá"),
      ),
      body: StreamBuilder(
        stream: DbService().readCouponCode(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> coupons =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;

            if (coupons.isEmpty) {
              return Center(
                child: Text("Không tìm thấy mã giảm giá"),
              );
            } else {
              return ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Bạn muốn làm gì"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AdditionalConfirm(
                                                  contentText:
                                                      "Xóa không thể hoàn tác",
                                                  onNo: () {
                                                    Navigator.pop(context);
                                                  },
                                                  onYes: () {
                                                    DbService()
                                                        .deleteCouponCode(
                                                            docId:
                                                                coupons[index]
                                                                    .id);
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                      },
                                      child: Text("Xóa mã giảm giá")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) => ModifyCoupon(
                                                id: coupons[index].id,
                                                code: coupons[index].code,
                                                desc: coupons[index].desc,
                                                discount:
                                                    coupons[index].discount));
                                      },
                                      child: Text("Cập nhật mã giảm giá")),
                                ],
                              ));
                    },
                    title: Text(coupons[index].code),
                    subtitle: Text(coupons[index].desc),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => ModifyCoupon(
                                id: coupons[index].id,
                                code: coupons[index].code,
                                desc: coupons[index].desc,
                                discount: coupons[index].discount));
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  ModifyCoupon(id: "", code: "", desc: "", discount: 0));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id, code, desc;
  final int discount;
  const ModifyCoupon(
      {super.key,
      required this.id,
      required this.code,
      required this.desc,
      required this.discount});

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController disPercentController = TextEditingController();

  @override
  void initState() {
    descController.text = widget.desc;
    codeController.text = widget.code;
    disPercentController.text = widget.discount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.id.isNotEmpty ? "Cập nhật mã giảm giá" : "Thêm mã giảm giá"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tất cả sẽ được chuyển thành chữ hoa"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: codeController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                decoration: InputDecoration(
                    hintText: "Mã giảm giá",
                    label: Text("Mã giảm giá"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: descController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                decoration: InputDecoration(
                    hintText: "Mô tả",
                    label: Text("Mô tả"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: disPercentController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                decoration: InputDecoration(
                    hintText: "Phần trăm giảm giá",
                    label: Text("Phần trăm giảm giá"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Hủy")),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                var data = {
                  "code": codeController.text.toUpperCase(),
                  "desc": descController.text,
                  "discount": int.parse(disPercentController.text)
                };

                if (widget.id.isNotEmpty) {
                  DbService().updateCouponCode(docId: widget.id, data: data);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Mã giảm giá đã được cập nhật.")));
                } else {
                  DbService().createCouponCode(data: data);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Mã giảm giá đã được thêm.")));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.id.isNotEmpty ? "Cập nhật mã giảm giá" : "Thêm mã giảm giá")),
      ],
    );
  }
}