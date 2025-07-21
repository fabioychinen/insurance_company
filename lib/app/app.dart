import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/app/core/services/api_services.dart';
import 'package:insurance_company/env.dart';
import '../modules/auth/viewmodel/login/login_bloc.dart';
import '../modules/auth/viewmodel/register/register_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/services/firebase_repository_impl.dart';
import 'routes/app_routes.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';
import 'package:insurance_company/app/core/bloc/post_bloc.dart';
import 'package:insurance_company/app/core/repositories/post_repository.dart';

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
        BlocProvider<PostBloc>(
          create: (_) => PostBloc(
            PostRepository(
              ApiServices(baseUrl: Environments.prod)
            )
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppColors.appTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}