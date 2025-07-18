import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../home/view/home_page.dart';
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
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: _loginListener,
        builder: (context, state) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildLoginForm(context, state),
          ),
        ),
      ),
    );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 32),
        CustomTextField(
          controller: cpfController,
          label: AppStrings.loginCpf,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          label: AppStrings.loginPassword,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        _buildRememberRow(),
        const SizedBox(height: 16),
        _buildLoginButton(context, state),
        _buildRegisterButton(context),
        const SizedBox(height: 24),
        _buildSocialIcons(),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.loginTitle,
      style: TextStyle(fontSize: 28),
    );
  }

  Widget _buildRememberRow() {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value ?? false;
            });
          },
        ),
        const Text(AppStrings.loginRememberMe),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(AppStrings.loginForgotPassword),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return ElevatedButton(
      onPressed: state is LoginLoading
          ? null
          : () {
              context.read<LoginBloc>().add(LoginSubmitted(
                    cpf: cpfController.text.trim(),
                    password: passwordController.text,
                  ));
            },
      child: state is LoginLoading
          ? const CircularProgressIndicator()
          : const Text(AppStrings.loginButton),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RegisterPage(),
          ),
        );
      },
      child: const Text(AppStrings.loginRegister),
    );
  }

  Widget _buildSocialIcons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.facebook),
        SizedBox(width: 16),
        Icon(Icons.g_mobiledata),
        SizedBox(width: 16),
        Icon(Icons.apple),
      ],
    );
  }
}