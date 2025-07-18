import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/core/firebase_options.dart';
import 'app/routes/app_routes.dart';
import 'modules/auth/viewmodel/login/login_bloc.dart';
import 'modules/auth/auth_repository.dart';
import 'modules/auth/viewmodel/register/register_bloc.dart';
import 'shared/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(AuthRepository()),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(AuthRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Insurance App',
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}