import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/cubit/register_cubit/register_cubit.dart';
import 'package:midical_laboratory/cubit/register_cubit/register_state.dart';
import 'package:midical_laboratory/features/pages/auth/OTP/otp_page.dart';
import 'package:midical_laboratory/models/register_request_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/password_form_filed.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _healthController = TextEditingController();

  String? _gender = 'male';
  bool _navigated = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _healthController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      print(_dobController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final thirdWidth = MediaQuery.of(context).size.width / 3;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (!_navigated) {
            if (state is RegisterSuccessState) {
              _navigated = true;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("تم إنشاء الحساب بنجاح"),
                  backgroundColor: AppColors.accentDark,
                ),
              );
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpVerificationPage(
                      email: _emailController.text.trim(),
                    ),
                  ),
                );
              }
            } else if (state is RegisterFailureState) {
              _navigated = true;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessege),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SizedBox.expand(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.secondary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
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
                                Text(
                                  "Create Account",
                                  style: AppTextStyle.style1.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: NameFormField(
                                        label: "Last Name",
                                        controller: _lastNameController,
                                        type: TextInputType.name,
                                        width: thirdWidth,
                                        validator: (v) => (v?.isEmpty ?? true)
                                            ? "Enter last name"
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: NameFormField(
                                        label: "First Name",
                                        controller: _firstNameController,
                                        type: TextInputType.name,
                                        width: thirdWidth,
                                        validator: (v) => (v?.isEmpty ?? true)
                                            ? "Enter first name"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          labelText: "Gender",
                                          border: InputBorder.none,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Radio<String>(
                                                  value: 'male',
                                                  groupValue: _gender,
                                                  onChanged: (val) => setState(
                                                    () => _gender = val,
                                                  ),
                                                ),
                                                const Text('Male'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio<String>(
                                                  value: 'female',
                                                  groupValue: _gender,
                                                  onChanged: (val) => setState(
                                                    () => _gender = val,
                                                  ),
                                                ),
                                                const Text('Female'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: NameFormField(
                                        label: "Date of Birth",
                                        controller: _dobController,
                                        type: TextInputType.datetime,
                                        prefixIcon: Icons.calendar_today,
                                        width: thirdWidth,
                                        validator: (v) => (v?.isEmpty ?? true)
                                            ? "Select date"
                                            : null,
                                        suffixIcon: Icons.arrow_drop_down,
                                        onTap: _pickDate,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                NameFormField(
                                  label: "smoking, drugs or diseases",
                                  controller: _healthController,
                                  type: TextInputType.text,
                                  validator: (v) => (v?.isEmpty ?? true)
                                      ? "Enter smoking, drugs or diseases"
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                NameFormField(
                                  label: "Phone",
                                  controller: _phoneController,
                                  type: TextInputType.phone,
                                  prefixIcon: Icons.phone,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return "Enter phone";
                                    final valid = RegExp(
                                      r"^09\d{8}$",
                                    ).hasMatch(v);
                                    return valid ? null : "Invalid phone";
                                  },
                                ),
                                const SizedBox(height: 16),
                                NameFormField(
                                  label: "Email",
                                  controller: _emailController,
                                  type: TextInputType.emailAddress,
                                  prefixIcon: Icons.email,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return "Enter email";
                                    final valid = RegExp(
                                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                    ).hasMatch(v);
                                    return valid ? null : "Invalid email";
                                  },
                                ),
                                const SizedBox(height: 16),
                                PasswordFormField(
                                  controller: _passwordController,
                                  label: "Password",
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return "Enter password";
                                    return v.length >= 6
                                        ? null
                                        : "At least 6 characters";
                                  },
                                ),
                                const SizedBox(height: 16),
                                PasswordFormField(
                                  controller: _confirmPasswordController,
                                  label: "Confirm Password",
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return "Confirm your password";
                                    if (v != _passwordController.text)
                                      return "Passwords do not match";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                const SizedBox(height: 24),
                                BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    if (state is LoadingState) {
                                      return const CircularProgressIndicator();
                                    }
                                    return CustomButton(
                                      text: "Register",
                                      width: thirdWidth,
                                      function: () {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          _navigated = false;
                                          print("#############");
                                          print(_dobController);
                                          print("#############");
                                          BlocProvider.of<RegisterCubit>(
                                            context,
                                          ).register(
                                            RegisterRequestModel(
                                              firstName: _firstNameController
                                                  .text
                                                  .trim(),
                                              lastName: _lastNameController.text
                                                  .trim(),
                                              dob: _dobController.text.trim(),
                                              gender: _gender ?? '',
                                              healthProblems:
                                                  _healthController.text,
                                              phone: _phoneController.text
                                                  .trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                              passwordConfirmation:
                                                  _confirmPasswordController
                                                      .text
                                                      .trim(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
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
          ),
        ),
      ),
    );
  }
}
