import 'package:ecommerce_app_1/controllers/auth_serivce.dart';
import 'package:ecommerce_app_1/providers/admin_provider.dart';
import 'package:ecommerce_app_1/views/admin_home.dart';
import 'package:ecommerce_app_1/views/categories_page.dart';
import 'package:ecommerce_app_1/views/coupons.dart';
import 'package:ecommerce_app_1/views/dashboard_page.dart';
import 'package:ecommerce_app_1/views/login.dart';
import 'package:ecommerce_app_1/views/modifi_product.dart';
import 'package:ecommerce_app_1/views/modifi_promo.dart';
import 'package:ecommerce_app_1/views/order_page.dart';
import 'package:ecommerce_app_1/views/product_page.dart';
import 'package:ecommerce_app_1/views/promo_banners_page.dart';
import 'package:ecommerce_app_1/views/signup.dart';
import 'package:ecommerce_app_1/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          '/': (context) => CheckUser(),
          '/home': (context) => AdminHome(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SignUpPage(),
          '/category': (context) => CategoriesPage(),
          '/products': (context) => ProductsPage(),
          '/add_product': (context) => ModifyProduct(),
          '/view_product': (context) => ViewProduct(),
          "/promos": (context) => PromoBannersPage(),
          "/update_promo": (context) => ModifyPromo(),
          "/coupons": (context) => CouponsPage(),
          "/orders": (context) => OrdersPage(),
          "/view_order": (context) => ViewOrder(),
          "/dashboard": (context) => DashboardPage(),
        },
      ),
    );
  }
}
class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}