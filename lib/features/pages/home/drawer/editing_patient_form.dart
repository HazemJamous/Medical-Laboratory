import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/cubit/profile/profile_cubit.dart';
import 'package:midical_laboratory/cubit/update_patient_cubit/update_patient_cubit.dart';
import 'package:midical_laboratory/cubit/update_patient_cubit/update_patient_state.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_patient_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class EditPatientForm extends StatefulWidget {
  final UpdatePatientModel patient;
  final BuildContext parentContext;

  const EditPatientForm({
    Key? key,
    required this.patient,
    required this.parentContext,
  }) : super(key: key);

  @override
  _EditPatientFormState createState() => _EditPatientFormState();
}

class _EditPatientFormState extends State<EditPatientForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _healthProblemsController;
  late TextEditingController _dobController;
  late DateTime _dob;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.patient.firstName,
    );
    _lastNameController = TextEditingController(text: widget.patient.lastName);
    _phoneController = TextEditingController(text: widget.patient.phone);
    _healthProblemsController = TextEditingController(
      text: widget.patient.healthProblems,
    );
    _dob = widget.patient.dob;
    _dobController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_dob),
    );
    _gender = widget.patient.gender.isNotEmpty ? widget.patient.gender : 'male';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _healthProblemsController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.patient.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _gender,
      dob: _dob,
      healthProblems: _healthProblemsController.text.trim(),
    );

    context.read<UpdatePatientCubit>().updatePatient(updated);
  }

  InputDecoration _multiLineDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');

    return SingleChildScrollView(
      child: Column(
        children: [
          // Grab Handle
          Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Text(
            'تعديل بيانات المريض',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonPrimary,
            ),
          ),
          SizedBox(height: 20),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionCard(
                  icon: Icons.person,
                  title: "المعلومات الشخصية",
                  children: [
                    NameFormField(
                      label: 'الاسم الأول',
                      controller: _firstNameController,
                      type: TextInputType.name,
                      prefixIcon: Icons.person,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الرجاء إدخال الاسم الأول'
                          : null,
                    ),
                    SizedBox(height: 16),
                    NameFormField(
                      label: 'اسم العائلة',
                      controller: _lastNameController,
                      type: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الرجاء إدخال اسم العائلة'
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.contact_phone,
                  title: "معلومات التواصل",
                  children: [
                    NameFormField(
                      label: 'رقم الهاتف',
                      controller: _phoneController,
                      type: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'الرجاء إدخال رقم الهاتف';
                        final pattern = RegExp(r'^[0-9+\-\s]{7,20}$');
                        if (!pattern.hasMatch(v.trim()))
                          return 'أدخل رقم هاتف صالح';
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.info,
                  title: "معلومات إضافية",
                  children: [
                    DateFormField(
                      controller: _dobController,
                      label: 'تاريخ الميلاد',
                      initialDate: _dob,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onDateSelected: (selected) {
                        setState(() {
                          _dob = selected;
                          _dobController.text = df.format(selected);
                        });
                      },
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الرجاء اختيار تاريخ الميلاد'
                          : null,
                    ),
                    SizedBox(height: 16),
                    GenderFormField(
                      selectedGender: _gender,
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                      label: 'الجنس',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الرجاء اختيار الجنس'
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _healthProblemsController,
                      maxLines: 3,
                      decoration: _multiLineDecoration(
                        'المشاكل الصحية (إن وجدت)',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                BlocConsumer<UpdatePatientCubit, UpdatePatientState>(
                  listener: (ctx, state) {
                    if (state is UpdatePatientSuccessState) {
                      try {
                        widget.parentContext.read<ProfileCubit>().profile();
                      } catch (_) {}
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(
                        widget.parentContext,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is UpdatePatientFailureState) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text(state.errorMessege)),
                      );
                    }
                  },
                  builder: (ctx, state) {
                    final isLoading = state is UpdatePatientLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: AppColors.buttonPrimary,
                          elevation: 3,
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
                            : Text(
                                '💾 حفظ التغييرات',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.buttonPrimary),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
