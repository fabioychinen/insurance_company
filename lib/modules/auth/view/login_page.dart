import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../home/view/home_page.dart';
import '../viewmodel/login_bloc.dart';
import '../viewmodel/login_event.dart';
import '../viewmodel/login_state.dart';

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
        listener: (context, state) {
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
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text("Login", style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: cpfController,
                    label: "CPF",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    label: "Senha",
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text("Lembrar sempre"),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Esqueceu a senha?"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
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
                        : const Text("Entrar"),
                  ),
                  TextButton(
                    onPressed: () {
                      // ação para cadastro
                    },
                    child: const Text("Cadastrar"),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.facebook),
                      SizedBox(width: 16),
                      Icon(Icons.g_mobiledata),
                      SizedBox(width: 16),
                      Icon(Icons.apple),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}