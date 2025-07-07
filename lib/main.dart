import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/routes.dart';
import 'package:midical_laboratory/features/auth/OTP/bloc/otp_bloc.dart';
import 'package:midical_laboratory/features/auth/OTP/view/otp_view.dart';
import 'package:midical_laboratory/features/auth/domain/auth_repository.dart';
import 'package:midical_laboratory/features/auth/data/auth_repository_impl.dart';
import 'package:midical_laboratory/features/auth/data/auth_api_service.dart';
import 'package:midical_laboratory/features/auth/login/view/login_view.dart';
import 'package:midical_laboratory/features/auth/register/bloc/register_bloc.dart';
import 'package:midical_laboratory/features/auth/register/view/register_view.dart';
import 'package:midical_laboratory/features/laboratory/laboratory_view.dart';

void main() {
  // MultiRepositoryProvider(
  //   providers: [
  //     RepositoryProvider<AuthRepository>(
  //       create: (_) => AuthRepositoryImpl(AuthApiService()),
  //     ),
  //   ],
  //   child: MultiBlocProvider(
  //     providers: [
  //       BlocProvider<RegisterBloc>(
  //         create: (ctx) => RegisterBloc(ctx.read<AuthRepository>()),
  //       ),
  //       BlocProvider<OtpBloc>(
  //         create: (ctx) => OtpBloc(ctx.read<AuthRepository>()),
  //       ),
  //     ],
  //     child: const MidicalLaboratoryApp(),
  //   ),
  // );

  runApp(const MidicalLaboratoryApp());
}

class MidicalLaboratoryApp extends StatelessWidget {
  const MidicalLaboratoryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF3498DB),
        scaffoldBackgroundColor: Color(0xFFF8F8F8),
        fontFamily: 'Roboto',
      ),

      // routes: {
      //   Routes.register: (_) => const RegisterView(),
      //   Routes.otp: (_) => const OtpView(email: ""),
      //   Routes.login: (_) => const LoginView(),
      //   Routes.Laboratory: (_)=> const LaboratoryView(),
      // },
      // initialRoute: Routes.Laboratory,
      home: RegisterView(),
    );
  }
}
//