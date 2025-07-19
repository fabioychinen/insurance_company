import 'package:flutter/material.dart';
import 'package:insurance_company/modules/auth/view/register/register_page.dart';
import 'package:insurance_company/modules/validate_invoice/view/validate_invoice.dart';
import '../../modules/assets/view/assets_page.dart';
import '../../modules/auth/view/login/login_page.dart';
import '../../modules/claims/view/claims_page.dart';
import '../../modules/contracts/view/contracts_page.dart';
import '../../modules/coverage/view/coverage_page.dart';
import '../../modules/family/view/family_page.dart';
import '../../modules/home/view/home_page.dart';
import '../../modules/important_phones/view/important_phones.dart';
import '../../modules/payments/view/payments_page.dart';
import '../../modules/settings/view/settings_page.dart';

class AppRoutes { 
  static const String assets = '/assets';
  static const String claims = '/claims';
  static const String contracts = '/contracts';
  static const String coverage = '/coverage';
  static const String family = '/family';
  static const home = '/home';
  static const String importantPhones = '/important-phones';
  static const login = '/';
  static const String payments = '/payments';
  static const register = '/register';
  static const String settings = '/settings';
  static const String validateInvoice = '/validate-invoice';

  static final routes = <String, WidgetBuilder>{  
    assets: (_) => const AssetsPage(),
    claims: (_) => const ClaimsPage(),
    contracts: (_) => const ContractsPage(),
    coverage: (_) => const CoveragePage(),
    family: (_) => const FamilyPage(),
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
    importantPhones: (_) => const ImportantPhonesPage(),
    payments: (_) => const PaymentsPage(),
    register: (_) => const RegisterPage(),    
    settings: (_) => const SettingsPage(),
    validateInvoice: (_) => const ValidateInvoicePage(),
  };
}