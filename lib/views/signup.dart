import 'package:ecommerce_app_1/controllers/auth_serivce.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9, // Keep consistent with login
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đăng Ký",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue.shade700),
                    ),
                    Text("Tạo tài khoản mới và bắt đầu",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600)),
                    SizedBox(
                      height: 20,
                    ),
                    // Name Text Field
                    _buildTextField(
                      controller: _nameController,
                      label: "Tên",
                      icon: Icons.person_rounded,
                      validator: (value) => value!.isEmpty
                          ? "Tên không được để trống."
                          : null,
                    ),
                    SizedBox(height: 15),
                    // Email Text Field
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_rounded,
                      validator: (value) =>
                          value!.isEmpty ? "Email không được để trống." : null,
                    ),
                    SizedBox(height: 15),
                    // Password Text Field
                    _buildTextField(
                      controller: _passwordController,
                      label: "Mật khẩu",
                      icon: Icons.lock_rounded,
                      obscureText: true,
                      validator: (value) => value!.length < 8
                          ? "Mật khẩu phải có ít nhất 8 ký tự."
                          : null,
                    ),
                    SizedBox(height: 20),
                    // Sign Up Button
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * .9, // Keep consistent width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Slightly rounded corners
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AuthService()
                                .createAccountWithEmail(
                                    _emailController.text,
                                    _passwordController.text)
                                .then((value) {
                              if (value == "Account Created") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text("Tài khoản đã được tạo")));
                                Navigator.restorablePushNamedAndRemoveUntil(
                                    context, "/login", (route) => false);
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
                          }
                        },
                        child: Text(
                          "Đăng Ký",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đã có tài khoản?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Đăng Nhập",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Slightly rounded corners
          borderSide: BorderSide.none,
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20), // Increased padding to avoid being too close to the screen edge
      ),
    );
  }
}
