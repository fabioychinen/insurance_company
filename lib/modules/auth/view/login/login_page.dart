import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';
import '../../../../app/core/constants/app_strings.dart';
import '../../../../app/core/services/firebase_repository_impl.dart';
import '../../../../shared/widgets/custom_login_text_field.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../home/view/home_page.dart';
import '../../../home/viewmodel/home_bloc.dart';
import '../../../home/viewmodel/home_event.dart';
import '../../viewmodel/login/login_bloc.dart';
import '../../viewmodel/login/login_event.dart';
import '../../viewmodel/login/login_state.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        header: Column(
          children: [
            Text(
              AppStrings.appTitle,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.welcome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        footer: _buildSocialIcons(1.0),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(24),
          color: AppColors.primaryDark,
          child: Container(
            width: 340,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: _buildLoginForm(context, 1.0),
          ),
        ),
      ),
    );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<HomeBloc>(
            create: (context) {
              final bloc = HomeBloc(FirebaseRepositoryImpl());
              bloc.add(LoadHomeData());
              return bloc;
            },
            child: const HomePage(),
          ),
        ),
      );
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Widget _buildLoginForm(BuildContext context, double scale) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: _loginListener,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(scale),
          SizedBox(height: 16 * scale),
          CustomLoginTextField(
            controller: cpfController,
            label: AppStrings.loginCpf,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppStrings.loginCpf,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 16 * scale),
          CustomLoginTextField(
            controller: passwordController,
            label: AppStrings.loginPassword,
            textAlign: TextAlign.center,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppStrings.loginPassword,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 8 * scale),
          _buildRememberRow(scale),
          SizedBox(height: 8 * scale),
          _buildLoginButton(context, state, scale),
          _buildRegisterButton(context, scale),
        ],
      ),
    );
  }

  Widget _buildTitle(double scale) {
    return Text(
      AppStrings.loginTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26 * scale,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _buildRememberRow(double scale) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value ?? false;
            });
          },
          shape: const CircleBorder(),
          side: const BorderSide(color: Colors.white),
          checkColor: AppColors.primaryDark,
          activeColor: AppColors.primaryGreen,
        ),
        Text(
          AppStrings.loginRememberMe,
          style: TextStyle(fontSize: 12 * scale, color: Colors.white70),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            AppStrings.loginForgotPassword,
            style: TextStyle(
              fontSize: 12 * scale,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state, double scale) {
    return ElevatedButton(
      onPressed: state is LoginLoading
          ? null
          : () {
              final cpf = cpfController.text.trim();
              final password = passwordController.text;
              if (cpf.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.loginFieldsRequired)),
                );
                return;
              }
              context.read<LoginBloc>().add(LoginSubmitted(
                    cpf: cpf,
                    password: password,
                  ));
            },
      child: state is LoginLoading
          ? const CircularProgressIndicator()
          : Text(AppStrings.loginButton, style: TextStyle(fontSize: 16 * scale)),
    );
  }

  Widget _buildRegisterButton(BuildContext context, double scale) {
    return Padding(
      padding: EdgeInsets.only(top: 6 * scale),
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterPage(),
              ),
            );
          },
          child: Text(
            AppStrings.loginRegister,
            style: TextStyle(fontSize: 15 * scale, color: AppColors.primaryYellow),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcons(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.facebook, size: 32 * scale, color: Colors.white),
        SizedBox(width: 24 * scale),
        Icon(Icons.g_mobiledata, size: 32 * scale, color: Colors.white),
        SizedBox(width: 24 * scale),
        Icon(Icons.apple, size: 32 * scale, color: Colors.white),
      ],
    );
  }
}