import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/password_form_filed.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? gender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),

        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text("Register", style: AppTextStyle.style1),
                Row(
                  children: [
                    NameFormField(
                      width: MediaQuery.of(context).size.width * 7 / 15,
                      label: "last name",
                      controller: _lastNameController,
                      type: TextInputType.name,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "must be enter value";
                        } else
                          return null;
                      },
                    ),
                    Expanded(child: SizedBox()),
                    NameFormField(
                      width: MediaQuery.of(context).size.width * 7 / 15,
                      label: "first name",
                      controller: _firstNameController,
                      type: TextInputType.name,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "must be enter value";
                        } else
                          return null;
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    GenderFormField(
                      width: MediaQuery.of(context).size.width * 7 / 15,
                      selectedGender: gender,
                      onChanged: (String? value) {
                        gender = value;
                      },
                    ),
                    Expanded(child: SizedBox()),

                    DateFormField(
                      width: MediaQuery.of(context).size.width * 7 / 15,
                      controller: _dobController,
                    ),
                  ],
                ),
                NameFormField(
                  label: "phone",
                  controller: _phoneController,
                  type: TextInputType.phone,
                  prefixIcon: Icons.phone,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "must be enter value";
                    } else if (value.length != 10 || !value.contains("09", 0))
                      return "must be enter correct number phone";
                    else
                      return null;
                  },
                ),
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
                PasswordFormField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  validator: (String? password) {
                    if (password == null || password.isEmpty) {
                      return "must be enter value";
                    } else if (password.length >= 6)
                      return "must password length > 5";
                    else if (_confirmPasswordController.text !=
                        _passwordController.text)
                      return "لازم التطابق";
                    else
                      return null;
                  },
                ),
                SizedBox(height: 15),
                CustomButton(
                  text: "Register",
                  width: MediaQuery.of(context).size.width / 3,
                  function: () async {
                    if (_formKey.currentState!.validate()) {}
                  },
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
