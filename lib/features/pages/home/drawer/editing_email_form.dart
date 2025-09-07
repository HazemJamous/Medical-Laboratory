// lib/features/profile/change_email_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/features/pages/auth/OTP/otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midical_laboratory/cubit/update_email_cubit/update_email_cubit.dart';
import 'package:midical_laboratory/cubit/update_email_cubit/update_email_state.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_email_model.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class ChangeEmailForm extends StatefulWidget {
  final BuildContext parentContext;
  final String initialEmail;
  const ChangeEmailForm({
    Key? key,
    required this.parentContext,
    required this.initialEmail,
  }) : super(key: key);

  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailCtrl.text = widget.initialEmail;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final model = UpdateEmailModel(email: _emailCtrl.text.trim());
    context.read<UpdateEmailCubit>().updateEmail(model);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(
            'تغيير الحساب (البريد الإلكتروني)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.pageTitle,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني الجديد',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'الرجاء إدخال البريد الإلكتروني';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v.trim()))
                    return 'أدخل بريدًا إلكترونيًا صالحًا';
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          BlocConsumer<UpdateEmailCubit, UpdateEmailState>(
            listener: (ctx, state) async {
              if (state is UpdateEmailSuccessState) {
                // جلب البريد المؤقت من SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                final pendingEmail =
                    prefs.getString('pending_email') ?? state.emailModel.email;

                // ننتقل لصفحة OTP بطريقة تمنع الرجوع للخلف (pushReplacement)
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => OtpVerificationPage(email: pendingEmail),
                  ),
                );

                ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                  SnackBar(
                    content: Text('أرسلنا كود التحقق إلى $pendingEmail'),
                  ),
                );
              } else if (state is UpdateEmailFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessege),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (ctx, state) {
              final loading = state is UpdateEmailLoadingState;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: loading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text('إرسال وتحقق'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// helper function to show sheet
Future<void> showChangeEmailBottomSheet(
  BuildContext context,
  String initialEmail,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
        ),
        child: SingleChildScrollView(
          controller: controller,
          child: ChangeEmailForm(
            parentContext: context,
            initialEmail: initialEmail,
          ),
        ),
      ),
    ),
  );
}
