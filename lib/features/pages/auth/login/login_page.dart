import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/cubit/login_cubit/login_cubit.dart';
import 'package:midical_laboratory/cubit/login_cubit/login_state.dart';
import 'package:midical_laboratory/features/pages/auth/register/register_page.dart';
import 'package:midical_laboratory/labs_page.dart';
import 'package:midical_laboratory/models/login_request_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/password_form_filed.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  // void _onLogin() {
  //   if (_formKey.currentState!.validate()) {
  //     LogInRequestModel logInModel =
  //     BlocProvider.of<LoginCubit>(context).login(logInModel);

  //     debugPrint("Logging in with ${_emailController.text}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final thirdWidth = MediaQuery.of(context).size.width / 3;

    return BlocProvider(
      create: (context) => LoginCubit(),

      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Welcome Back',
            style: AppTextStyle.style1.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accentLight, AppColors.accentDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // العنوان داخل البطاقة
                          Text(
                            'Login',
                            style: AppTextStyle.style1.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          NameFormField(
                            label: 'Email Address',
                            controller: _emailController,
                            type: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final pattern =
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              if (!RegExp(pattern).hasMatch(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          PasswordFormField(
                            controller: _passwordController,
                            label: 'Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return value.length >= 6
                                  ? null
                                  : 'At least 6 characters';
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              if (state is LoginSuccessState) {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text("تم تسجيل الدخول بنجاح"),
                                //     backgroundColor: AppColors.accentDark,
                                //   ),
                                // );
                                dispose();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LabsPage(),
                                  ),
                                );
                              } else if (state is LoginFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.errorMessege),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (state is LoadingState) {
                                return ElevatedButton(
                                  onPressed: () {},
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CustomButton(
                                text: 'Login',
                                width: thirdWidth,
                                function: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<LoginCubit>(context).login(
                                      LogInRequestModel(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Register Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
