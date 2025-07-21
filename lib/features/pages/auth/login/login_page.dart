import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/features/pages/auth/register/register_page.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/password_form_filed.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    // BlocProvider<RegisterBloc>(
    //   create: (context) {
    //     final repo = context.read<AuthRepository>();
    //     return RegisterBloc(repo);
    //   },
    //   child: BlocListener<RegisterBloc, RegisterState>(
    //     listener: (context, state) {
    //       if (state is RegisterSuccess) {
    //         Navigator.pushNamed(context, '/otp');
    //       } else if (state is RegisterFailure) {
    //         ScaffoldMessenger.of(
    //           context,
    //         ).showSnackBar(SnackBar(content: Text(state.error)));
    //       }
    //     },
    //     child:
    Scaffold(
      backgroundColor: AppColors.accent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),

        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text("Login", style: AppTextStyle.style1),
                NameFormField(
                  label: "Email",
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "must be enter value";
                    } else if (value.contains("@gmail.com"))
                      return "must be enter a correct email Address";
                    else
                      return null;
                  },
                ),
                PasswordFormField(
                  controller: _passwordController,
                  label: "Password",
                  validator: (String? password) {
                    if (password == null || password.isEmpty) {
                      return "must be enter value";
                    } else if (password.length >= 6)
                      return "must password length > 5";
                    else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: "Login",
                  width: MediaQuery.of(context).size.width / 3,
                  function: () async {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegisterPage();
                            },
                          ),
                        );
                      },
                      child: Text("Register Now"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      //   ),
      // ),
    );
  }
}
