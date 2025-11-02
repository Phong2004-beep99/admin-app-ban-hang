import 'package:ecommerce_app_1/controllers/auth_serivce.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline, size: 40, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Text("Bắt đầu với tài khoản của bạn"),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Email không được để trống." : null,
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Mật khẩu phải có ít nhất 8 ký tự."
                      : null,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                    label: Text("Mật khẩu"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text("Quên mật khẩu"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nhập email của bạn"),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      label: Text("Email"),
                                      border: OutlineInputBorder()),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Hủy")),
                              TextButton(
                                onPressed: () async {
                                  if (_emailController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content:
                                                Text("Email không được để trống")));
                                    return;
                                  }
                                  await AuthService()
                                      .resetPassword(_emailController.text)
                                      .then((value) {
                                    if (value == "Mail Sent") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn")));
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          value,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                      ));
                                    }
                                  });
                                },
                                child: Text("Gửi"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Quên mật khẩu"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginWithEmail(_emailController.text,
                                _passwordController.text)
                            .then((value) {
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Đăng nhập thành công")));
                            Navigator.restorablePushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                ));
                          }
                        });
                      }
                    },
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có tài khoản?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                      child: Text("Đăng ký"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
