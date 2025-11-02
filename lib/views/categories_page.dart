import 'dart:io';
import 'package:ecommerce_app_1/containers/additional_confirm.dart';
import 'package:ecommerce_app_1/controllers/cloudinary_service.dart';
import 'package:ecommerce_app_1/controllers/db_service.dart';
import 'package:ecommerce_app_1/models/categories_model.dart';
import 'package:ecommerce_app_1/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh mục"),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoriesModel> categories =
              CategoriesModel.fromJsonList(value.categories);

          if (value.categories.isEmpty) {
            return Center(
              child: Text("Không tìm thấy danh mục"),
            );
          }

          return ListView.builder(
            itemCount: value.categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                    height: 50,
                    width: 50,
                    child: Image.network(categories[index].image == null ||
                            categories[index].image == ""
                        ? "https://demofree.sirv.com/nope-not-here.jpg"
                        : categories[index].image)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Bạn muốn làm gì"),
                            content: Text("Hành động xóa không thể hoàn tác"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => AdditionalConfirm(
                                            contentText:
                                                "Bạn có chắc chắn muốn xóa cái này",
                                            onYes: () {
                                              DbService().deleteCategories(
                                                  docId: categories[index].id);
                                              Navigator.pop(context);
                                            },
                                            onNo: () {
                                              Navigator.pop(context);
                                            }));
                                  },
                                  child: Text("Xóa danh mục")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => ModifyCategory(
                                              isUpdating: true,
                                              categoryId: categories[index].id,
                                              priority:
                                                  categories[index].priority,
                                              image: categories[index].image,
                                              name: categories[index].name,
                                            ));
                                  },
                                  child: Text("Cập nhật danh mục"))
                            ],
                          ));
                },
                title: Text(
                  categories[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Ưu tiên : ${categories[index].priority}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ModifyCategory(
                              isUpdating: true,
                              categoryId: categories[index].id,
                              priority: categories[index].priority,
                              image: categories[index].image,
                              name: categories[index].name,
                            ));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ModifyCategory(
                    isUpdating: false,
                    categoryId: "",
                    priority: 0,
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory(
      {super.key,
      required this.isUpdating,
      this.name,
      required this.categoryId,
      this.image,
      required this.priority});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
  }

  // NEW : upload to cloudinary
  void _pickImageAndCloudinaryUpload() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tải ảnh lên thành công")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Cập nhật danh mục" : "Thêm danh mục"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tất cả sẽ được chuyển thành chữ thường"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                decoration: InputDecoration(
                    hintText: "Tên danh mục",
                    label: Text("Tên danh mục"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Điều này sẽ được sử dụng để sắp xếp danh mục"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Ưu tiên",
                    label: Text("Ưu tiên"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              image == null
                  ? imageController.text.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.all(20),
                          height: 100,
                          width: double.infinity,
                          color: Colors.deepPurple.shade50,
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                          ))
                      : SizedBox()
                  : Container(
                      margin: EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.deepPurple.shade50,
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.contain,
                      )),
              ElevatedButton(
                  onPressed: () {
                    _pickImageAndCloudinaryUpload();
                  },
                  child: Text("Chọn ảnh")),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "Không được để trống." : null,
                decoration: InputDecoration(
                    hintText: "Liên kết hình ảnh",
                    label: Text("Liên kết hình ảnh"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.isUpdating) {
                  await DbService()
                      .updateCategories(docId: widget.categoryId, data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Danh mục đã được cập nhật"),
                  ));
                } else {
                  await DbService().createCategories(data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Danh mục đã được thêm"),
                  ));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.isUpdating ? "Cập nhật" : "Thêm")),
      ],
    );
  }
}
