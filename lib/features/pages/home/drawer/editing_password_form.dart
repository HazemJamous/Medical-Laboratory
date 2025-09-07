import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/update_password_cubit/update_password_cubit.dart';
import 'package:midical_laboratory/cubit/update_password_cubit/update_password_state.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_password_model.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class ChangePasswordForm extends StatefulWidget {
  final BuildContext parentContext;

  const ChangePasswordForm({Key? key, required this.parentContext})
    : super(key: key);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
          lowerBound: 0.0,
          upperBound: 0.04,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) _pulseController.reverse();
        });
  }

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Return a score 0..3 and label
  Map<String, dynamic> _strengthResult(String pwd) {
    int score = 0;
    if (pwd.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) score++;
    if (RegExp(r'[0-9]').hasMatch(pwd)) score++;
    if (RegExp(r'[!@#\$&*~^%\-+=]').hasMatch(pwd)) score++;

    // normalize to 0..3 (treat >=3 as 3)
    int normalized = score.clamp(0, 3);
    String label;
    if (pwd.isEmpty)
      label = '';
    else if (normalized <= 1)
      label = 'ضعيفة';
    else if (normalized == 2)
      label = 'جيدة';
    else
      label = 'قوية';
    return {'score': normalized, 'label': label};
  }

  double _strengthPercent(String pwd) {
    final res = _strengthResult(pwd);
    return (res['score'] as int) / 3.0;
  }

  Color _strengthColor(String pwd) {
    final res = _strengthResult(pwd);
    final s = res['score'] as int;
    if (pwd.isEmpty) return Colors.grey.shade300;
    if (s <= 1) return Colors.redAccent;
    if (s == 2) return Colors.orangeAccent;
    return Colors.green;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final model = UpdatePasswordModel(
      oldPassword: _oldCtrl.text.trim(),
      newPassword: _newCtrl.text.trim(),
      newPasswordConfirmation: _confirmCtrl.text.trim(),
    );

    // animate a pulse for micro-feedback
    _pulseController.forward();

    context.read<UpdatePasswordCubit>().updatePassword(model);
  }

  InputDecoration _passwordDecoration({
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20),
        onPressed: toggle,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.buttonPrimary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newPwd = _newCtrl.text;
    final percent = _strengthPercent(newPwd);
    final strengthColor = _strengthColor(newPwd);
    final strengthLabel = _strengthResult(newPwd)['label'] as String;

    return Container(
      // card-like modal body
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header with gradient & icon
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  AppColors.buttonPrimary.withOpacity(0.12),
                  Colors.white,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonPrimary.withOpacity(0.18),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.lock, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تغيير كلمة السر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pageTitle,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'احرص على استخدام كلمة قوية وطويلة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _oldCtrl,
                  obscureText: _obscureOld,
                  decoration: _passwordDecoration(
                    label: 'كلمة السر الحالية',
                    obscure: _obscureOld,
                    toggle: () => setState(() => _obscureOld = !_obscureOld),
                    hint: 'أدخل كلمة السر الحالية',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'الرجاء إدخال كلمة السر الحالية'
                      : null,
                ),
                SizedBox(height: 14),

                TextFormField(
                  controller: _newCtrl,
                  obscureText: _obscureNew,
                  decoration: _passwordDecoration(
                    label: 'كلمة السر الجديدة',
                    obscure: _obscureNew,
                    toggle: () => setState(() => _obscureNew = !_obscureNew),
                    hint: 'مثال: P@ssw0rd2025',
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'الرجاء إدخال كلمة السر الجديدة';
                    if (v.trim().length < 8)
                      return 'يجب أن تكون كلمة السر 8 أحرف على الأقل';
                    return null;
                  },
                ),

                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: percent.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: strengthColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: strengthColor.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // label
                    Text(
                      strengthLabel.isEmpty ? '' : strengthLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: strengthColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // confirm
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  decoration: _passwordDecoration(
                    label: 'تأكيد كلمة السر',
                    obscure: _obscureConfirm,
                    toggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    hint: 'أعد إدخال كلمة السر الجديدة',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'الرجاء تأكيد كلمة السر';
                    if (v.trim() != _newCtrl.text.trim())
                      return 'كلمتا السر غير متطابقتين';
                    return null;
                  },
                ),

                SizedBox(height: 18),

                // action buttons row: cancel + submit
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child:
                          BlocConsumer<
                            UpdatePasswordCubit,
                            UpdatePasswordState
                          >(
                            listener: (ctx, state) {
                              if (state is UpdatePasswordSuccessState) {
                                // close sheet
                                Navigator.of(ctx).pop();
                                // show success in parent
                                ScaffoldMessenger.of(
                                  widget.parentContext,
                                ).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              } else if (state is UpdatePasswordFailureState) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(content: Text(state.errorMessege)),
                                );
                              }
                            },
                            builder: (ctx, state) {
                              final isLoading =
                                  state is UpdatePasswordLoadingState;
                              return ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.heading,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'تحديث كلمة السر',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                    ),
                  ],
                ),

                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
