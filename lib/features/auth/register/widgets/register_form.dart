import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/features/auth/register/bloc/register_bloc.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthDateController = TextEditingController();

  String? selectedGender;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushNamed(context, '/otp');
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Register Now"),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: NameFormField(
                          label: "الاسم الأخير",
                          controller: lastNameController,
                          type: TextInputType.name,
                          validator: (name) {
                            if (name!.isEmpty) {
                              return "خانة الاسم ضرورية للتسجيل";
                            } else
                              return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: NameFormField(
                          label: "الاسم الأول",
                          controller: firstNameController,
                          type: TextInputType.name,
                          validator: (name) {
                            if (name!.isEmpty) {
                              return "خانة الاسم ضرورية للتسجيل";
                            } else
                              return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GenderFormField(
                    onChanged: (newGender) {
                      selectedGender = newGender;
                      // setState(() {

                      // });
                    },
                    selectedGender: selectedGender,
                    label: "الجنس",
                    // validator: (value) {
                    //   if (value == null || value.isEmpty)
                    //     return 'يرجى اختيار الجنس';
                    //   return null;
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DateFormField(
                    controller: birthDateController,
                    label: "أدخل تاريخ ميلادك",
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'يرجى اختيار تاريخ الميلاد';
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: NameFormField(
                    label: "Email",
                    isRTL: true,
                    prefixIcon: Icons.email,
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'يرجى إدخال بريدك الإلكتروني';
                      } else if (!email.contains("@gmail.com")) {
                        return 'يرجى إدخال بريد إلكتروني صالح';
                      } else
                        return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: PasswordFormField(
                    label: "Password",
                    isRtl: false,
                    controller: passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return "يجب إدخال كلمة السر";
                      } else if (password.length <= 5) {
                        return "كلمة السر قصيرة جدا، ينبغي أن تكون من 6 خانات على الأقل";
                      } else
                        return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomButton(
                    text:
                        state is RegisterLoading
                            ? "جاري الإرسال..."
                            : "إنشاء حساب",
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<RegisterBloc>().add(
                          SubmitRegistration(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            gender: selectedGender ?? '',
                            birthDate: birthDateController.text,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.toString())),
                        );
                      }
                      ;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
