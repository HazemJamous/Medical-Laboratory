import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/profile/profile_cubit.dart';
import 'package:midical_laboratory/cubit/profile/profile_state.dart';
import 'package:midical_laboratory/features/pages/home/drawer/editing_email_form.dart';
import 'package:midical_laboratory/features/pages/home/drawer/editing_password_form.dart';
import 'package:midical_laboratory/features/pages/home/drawer/editing_patient_form.dart';
import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_patient_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  String _initials(ProfileModel p) =>
      "${p.firstName.isNotEmpty ? p.firstName[0] : ''}${p.lastName.isNotEmpty ? p.lastName[0] : ''}"
          .toUpperCase();

  String _fullName(ProfileModel p) => '${p.firstName} ${p.lastName}';

  int _age(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  String _formatDate(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (context) =>
              ProfileCubit()..profile(), // هذا اللي طلبت تتركه كما هو
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'الملف الشخصي',
            style: TextStyle(
              color: AppColors.pageTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: AppColors.pageTitle),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileFailureState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'خطأ: ${state.errorMessege}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          foregroundColor: AppColors.buttonPrimaryText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.read<ProfileCubit>().profile(),
                        child: const Text('حاول مرة أخرى'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileSuccessState) {
              final patient = state.profileModel;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // رأس الصفحة
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            _initials(patient),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _fullName(patient),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Balance: ${state.balance.total} ${state.balance.currency}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ID: ${patient.patientId} • ${_age(patient.dob)} سنة',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // معلومات الاتصال
                  _buildCard(
                    title: "معلومات الاتصال",
                    children: [
                      _InfoTile(
                        icon: Icons.phone,
                        title: 'الهاتف',
                        value: patient.phone,
                      ),
                      _InfoTile(
                        icon: Icons.email,
                        title: 'البريد الإلكتروني',
                        value: patient.email.isEmpty
                            ? 'غير متوفر'
                            : patient.email,
                      ),
                      _InfoTile(
                        icon: Icons.cake,
                        title: 'تاريخ الميلاد',
                        value: _formatDate(patient.dob),
                      ),
                      _InfoTile(
                        icon: Icons.person,
                        title: 'الجنس',
                        value: patient.gender.isEmpty ? '-' : patient.gender,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // المشاكل الصحية
                  _buildCard(
                    title: "المشاكل الصحية",
                    children: [
                      if (patient.healthProblems.trim().isEmpty)
                        const Text(
                          'لا توجد مشاكل صحية مسجلة',
                          style: TextStyle(color: AppColors.textColor),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: patient.healthProblems
                              .split(',')
                              .map(
                                (s) => Chip(
                                  label: Text(
                                    s.trim(),
                                    style: const TextStyle(
                                      color: AppColors.pageTitle,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: AppColors.secondary,
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildCard(
                    title: "إعدادات الحساب",
                    children: [
                      _ActionButton(
                        icon: Icons.edit_document,
                        text: "تغيير البيانات",
                        color: AppColors.buttonPrimary,
                        onPressed:
                            ()
                            // {},
                            {
                              showEditPatientBottomSheet(
                                context,
                                UpdatePatientModel(
                                  firstName: state.profileModel.firstName,
                                  lastName: state.profileModel.lastName,
                                  phone: state.profileModel.phone,
                                  gender: state.profileModel.gender,
                                  dob: state.profileModel.dob,
                                  healthProblems:
                                      state.profileModel.healthProblems,
                                ),
                              );
                            },
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        icon: Icons.switch_account,
                        text: "تغيير الحساب",
                        color: AppColors.accent,
                        onPressed: () {
                          final currentEmail = state.profileModel.email;
                          showChangeEmailBottomSheet(context, currentEmail);
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        icon: Icons.lock,
                        text: "تغيير كلمة السر",
                        color: AppColors.heading,
                        onPressed: () => showChangePasswordBottomSheet(context),
                      ),
                    ],
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accentLight,
            child: Icon(icon, size: 20, color: AppColors.accentDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
      ),
      onPressed: onPressed,
    );
  }
}

Future<void> showEditPatientBottomSheet(
  BuildContext parentContext,
  UpdatePatientModel patient,
) {
  return showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(parentContext).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: EditPatientForm(
                patient: patient,
                parentContext: parentContext, // مهم
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showChangePasswordBottomSheet(BuildContext parentContext) {
  return showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(parentContext).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: ChangePasswordForm(parentContext: parentContext),
            ),
          );
        },
      );
    },
  );
}
