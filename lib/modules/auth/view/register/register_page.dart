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
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: _registerListener,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildRegisterForm(context, state),
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

  Widget _buildRegisterForm(BuildContext context, RegisterState state) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          label: AppStrings.registerName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: cpfController,
          label: AppStrings.registerCpf,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          label: AppStrings.registerEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          label: AppStrings.registerPassword,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: confirmPasswordController,
          label: AppStrings.registerConfirmPassword,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _buildRegisterButton(context, state),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterState state) {
    return ElevatedButton(
      onPressed: state is RegisterLoading
        ? null
        : () => _onRegisterPressed(context),
      child: state is RegisterLoading
        ? const CircularProgressIndicator()
        : const Text(AppStrings.registerButton),
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