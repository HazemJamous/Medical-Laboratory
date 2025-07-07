import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/features/auth/domain/auth_repository.dart';
import 'package:midical_laboratory/features/auth/register/bloc/register_bloc.dart';
import 'package:midical_laboratory/features/auth/register/widgets/drop_shape_clipper.dart';
import 'package:midical_laboratory/features/auth/register/widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) {
      final repo = context.read<AuthRepository>();
        return RegisterBloc(repo);
      },
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pushNamed(context, '/otp');
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 250,
                  child: RepaintBoundary(
                    child: ClipPath(
                      clipper: DropShapeClipper(),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(22, 210, 151, 1),
                              Color.fromRGBO(33, 135, 166, 1),
                            ],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                ),

                // ننقل الفورم أعلى الشاشة باستخدام Translate
                Transform.translate(
                  offset: const Offset(0, -68),
                  child: Column(
                    children: const [
                      SizedBox(width: 120),
                      SizedBox(height: 10),
                      RegisterForm(),
                    ],
                  ),
                ),
              ],
            ),

            // الخيار 2 (بدل ListView): Column + Expanded
            // child: Column(
            //   children: [
            //     Expanded(
            //       child: Stack(...),  // كما في الكود الأصلي للـ ClipPath
            //     ),
            //     Transform.translate(...),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}