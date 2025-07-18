import 'package:flutter/material.dart';
import '../../modules/auth/view/login_page.dart';
import '../../modules/home/view/home_page.dart';

class AppRoutes {
  static const login = '/';
  static const home = '/home';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
  };
}