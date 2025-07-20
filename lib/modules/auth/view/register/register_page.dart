import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../viewmodel/register/register_bloc.dart';
import '../../viewmodel/register/register_event.dart';
import '../../viewmodel/register/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final isTablet = constraints.maxWidth > 700 && constraints.maxWidth <= 900;
          final maxWidth = isWide ? 500 : isTablet ? 400 : double.infinity;
          final scale = isWide ? 1.3 : isTablet ? 1.15 : 1.0;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth.toDouble()),
                  child: _buildRegisterForm(context, scale),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _registerListener(BuildContext context, RegisterState state) {
    if (state is RegisterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.registerSuccess)),
      );
      Navigator.pop(context);
    } else if (state is RegisterFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Widget _buildRegisterForm(BuildContext context, double scale) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: _registerListener,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.registerTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26 * scale, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 32 * scale),
          CustomTextField(
            controller: nameController,
            label: AppStrings.registerName,
          ),
          SizedBox(height: 16 * scale),
          CustomTextField(
            controller: cpfController,
            label: AppStrings.registerCpf,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16 * scale),
          CustomTextField(
            controller: emailController,
            label: AppStrings.registerEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16 * scale),
          CustomTextField(
            controller: passwordController,
            label: AppStrings.registerPassword,
            obscureText: true,
          ),
          SizedBox(height: 16 * scale),
          CustomTextField(
            controller: confirmPasswordController,
            label: AppStrings.registerConfirmPassword,
            obscureText: true,
          ),
          SizedBox(height: 24 * scale),
          _buildRegisterButton(context, state, scale),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterState state, double scale) {
    return ElevatedButton(
      onPressed: state is RegisterLoading
          ? null
          : () => _onRegisterPressed(context),
      child: state is RegisterLoading
          ? const CircularProgressIndicator()
          : Text(AppStrings.registerButton, style: TextStyle(fontSize: 16 * scale)),
    );
  }

  void _onRegisterPressed(BuildContext context) {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.registerPasswordsNotMatch)),
      );
      return;
    }

    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        name: nameController.text.trim(),
        cpf: cpfController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }
}