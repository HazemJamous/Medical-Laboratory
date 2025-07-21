import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/password_form_filed.dart';

class RegisterPageTest extends StatefulWidget {
  const RegisterPageTest({Key? key}) : super(key: key);

  @override
  _RegisterPageTestState createState() => _RegisterPageTestState();
}

class _RegisterPageTestState extends State<RegisterPageTest> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      _dobController.text = DateFormat.yMd().format(picked);
    }
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      // مسحح: _formKey.currentState!.save();
      // هنا استدعِ تابع التسجيل الخاص بك
      debugPrint("All fields valid, gender=$_gender, ready to register");
    }
  }

  @override
  Widget build(BuildContext context) {
    final thirdWidth = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      body: SizedBox.expand(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

                          // الجنس والتاريخ في صف واحد
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              // Radio بين Male / Female
                              Expanded(
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: "Gender",
                                    border: InputBorder.none,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // خيار Male
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: 'M',
                                            groupValue: _gender,
                                            onChanged: (val) =>
                                                setState(() => _gender = val),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Male'),
                                        ],
                                      ),

                                      const SizedBox(
                                        width: 32,
                                      ), // مسافة بين الخيارين
                                      // خيار Female
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: 'F',
                                            groupValue: _gender,
                                            onChanged: (val) =>
                                                setState(() => _gender = val),
                                          ),
                                          const SizedBox(width: 8),
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
                                  isRTL: false,
                                  validator: (v) => (v?.isEmpty ?? true)
                                      ? "Select date"
                                      : null,
                                  // عند الضغط يُفتح DatePicker
                                  suffixIcon: Icons.arrow_drop_down,

                                  onTap: _pickDate,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // حقول الهاتف والإيميل
                          NameFormField(
                            label: "Phone",
                            controller: _phoneController,
                            type: TextInputType.phone,
                            prefixIcon: Icons.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter phone";
                              }
                              final valid = RegExp(r"^09\d{8}$").hasMatch(v);
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
                              if (v == null || v.isEmpty) {
                                return "Enter email";
                              }
                              final valid = RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                              ).hasMatch(v);
                              return valid ? null : "Invalid email";
                            },
                          ),

                          const SizedBox(height: 16),

                          // حقل كلمة المرور
                          PasswordFormField(
                            controller: _passwordController,
                            label: "Password",
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter password";
                              }
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
                              if (v == null || v.isEmpty) {
                                return "Confirm your password";
                              }
                              if (v != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          CustomButton(
                            text: "Register",
                            width: thirdWidth,
                            function: _onRegister,
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
