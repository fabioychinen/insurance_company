import 'package:flutter/material.dart';
import 'package:insurance_company/modules/auth/view/register/register_page.dart';
import '../../modules/auth/view/login/login_page.dart';
import '../../modules/home/view/home_page.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';
  static const register = '/register';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    register: (_) => const RegisterPage()
  };
}