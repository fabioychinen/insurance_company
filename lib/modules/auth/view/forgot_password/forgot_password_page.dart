import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/constants/app_strings.dart';
import '../../../../app/core/repositories/firebase_repository_impl.dart';
import '../../../../shared/themes/app_theme.dart';
import '../../viewmodel/forgot_password/forgot_password_bloc.dart';
import '../../viewmodel/forgot_password/forgot_password_event.dart';
import '../../viewmodel/forgot_password/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(FirebaseRepositoryImpl()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.forgotPasswordTitle),
      backgroundColor: AppColors.primaryDark,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            color: AppColors.primaryDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: _blocListener,
                builder: _blocBuilder,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ForgotPasswordState state) {
    if (state.success) {
      _showSnackBar(AppStrings.forgotPasswordEmailSent);
      Navigator.pop(context);
    }
    if (state.error != null) {
      _showSnackBar('${AppStrings.forgotPasswordSendError} ${state.error}');
    }
  }

  Widget _blocBuilder(BuildContext context, ForgotPasswordState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_reset, size: 64, color: AppColors.primaryGreen),
        const SizedBox(height: 24),
        const Text(
          AppStrings.forgotPasswordHeader,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          AppStrings.forgotPasswordSubheader,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white70),
        ),
        const SizedBox(height: 28),
        _buildEmailField(),
        const SizedBox(height: 28),
        _buildSendButton(state),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: AppStrings.email,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        filled: true,
        fillColor: AppColors.cardDark.withValues(alpha: 77),
      ),
    );
  }

  Widget _buildSendButton(ForgotPasswordState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: state.isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.email_outlined),
        label: Text(
          state.isLoading
              ? AppStrings.forgotPasswordSending
              : AppStrings.forgotPasswordSendButton,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: state.isLoading
            ? null
            : () {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  _showSnackBar(AppStrings.forgotPasswordEmailRequired);
                  return;
                }
                context.read<ForgotPasswordBloc>().add(
                      ForgotPasswordSubmitted(email: email),
                    );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}