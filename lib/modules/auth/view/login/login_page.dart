import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';
import '../../../../app/core/constants/app_images.dart';
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
import '../forgot_password/forgot_password_page.dart';
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
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCpf = prefs.getString('savedCpf');
      final savedPassword = prefs.getString('savedPassword');
      
      if (!mounted) return;
      
      if (savedCpf != null && savedCpf.isNotEmpty && 
          savedPassword != null && savedPassword.isNotEmpty) {
        setState(() {
          cpfController.text = savedCpf;
          passwordController.text = savedPassword;
          rememberMe = true;
        });
        
        if (mounted) {
          context.read<LoginBloc>().add(LoginSubmitted(
            cpf: savedCpf,
            password: savedPassword,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.loadingErrorMessage}:$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryGreen, AppColors.primaryYellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Image.asset(
          AppImages.logo,
          height: 64,
          fit: BoxFit.contain,
        ),
      ),
      body: GradientBackground(
        footer: _buildSocialIcons(1.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) => _loginListener(state),
          builder: (context, state) => _buildLoginFormCard(context, 1.0, state),
        ),
      ),
    );
  }

  void _loginListener(LoginState state) async {
    if (state is LoginSuccess) {
      try {
        final prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setString('savedCpf', cpfController.text.trim());
          await prefs.setString('savedPassword', passwordController.text);
        } else {
          await prefs.remove('savedCpf');
          await prefs.remove('savedPassword');
        }
        if (!mounted) return;
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
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.saveErrorMessage)),
        );
      }
    } else if (state is LoginFailure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Widget _buildLoginFormCard(BuildContext context, double scale, LoginState state) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
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
            child: _buildLoginForm(context, scale, state),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -31,
          child: Center(
            child: _buildLoginFabButton(context, state, scale),
          ),
        ),
      ],
    );
  }

Widget _buildLoginFabButton(BuildContext context, LoginState state, double scale) {
  return Material(
    elevation: 6,
    shape: const CircleBorder(),
    color: Colors.transparent,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: state is LoginLoading
          ? null
          : () async {
              if (!mounted) return;
              final cpf = cpfController.text.trim();
              final password = passwordController.text;
              
              if (cpf.isEmpty || password.isEmpty) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.loginFieldsRequired)),
                );
                return;
              }
              
              try {
                context.read<LoginBloc>().add(LoginSubmitted(
                  cpf: cpf,
                  password: password,
                ));
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro: ${e.toString()}')),
                );
              }
            },
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primaryGreen, AppColors.primaryYellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardDark.withAlpha(2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: state is LoginLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
        ),
      ),
    ),
  );
}

  Widget _buildLoginForm(BuildContext context, double scale, LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopTab(isActive: true, title: AppStrings.loginButton, onTap: () {}),
            _buildTopTab(
              isActive: false,
              title: AppStrings.loginRegister,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 24 * scale),
        CustomLoginTextField(
          controller: cpfController,
          label: AppStrings.loginCpf,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppStrings.loginCpf,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),

            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
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
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 8 * scale),
        _buildRememberRow(scale),
        SizedBox(height: 36 * scale),
      ],
    );
  }

  Widget _buildTopTab({required bool isActive, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: isActive ? AppColors.primaryGreen : Colors.white70,
            fontWeight: FontWeight.bold,
            decoration: isActive ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AppColors.primaryGreen,
            decorationThickness: 2,
          ),
        ),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ForgotPasswordPage(),
              ),
            );
          },
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