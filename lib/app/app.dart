import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/firebase_repository_impl.dart';
import 'routes/app_routes.dart';
import 'core/constants/app_strings.dart';
import '../shared/themes/app_theme.dart';
import '../modules/auth/viewmodel/login/login_bloc.dart';
import '../modules/auth/viewmodel/register/register_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(FirebaseRepositoryImpl()),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(FirebaseRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}