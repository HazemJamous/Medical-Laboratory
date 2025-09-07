// lib/features/otp/otp_verification_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/otp_cubit/cubit/otp_cubit_cubit.dart';
import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';
import 'package:pinput/pinput.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/models/otp/otp_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midical_laboratory/cubit/profile/profile_cubit.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _hasNavigated = false;
  bool _isPending = true;

  @override
  void initState() {
    super.initState();
    _checkPending();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_pinFocusNode);
    });
  }

  Future<void> _checkPending() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getBool('email_pending_verification') ?? false;
    setState(() => _isPending = pending);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _onVerify(BuildContext context) {
    final code = _pinController.text.trim();
    if (code.length == 6) {
      BlocProvider.of<OtpCubit>(context).verifyOtp(OtpRequestModel(email: widget.email.trim(), code: code));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter all 6 digits"), backgroundColor: Colors.red));
    }
  }

  Future<bool> _onWillPop() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getBool('email_pending_verification') ?? false;
    return !pending; // لو pending true => لا تسمح بالرجوع
  }

  @override
  Widget build(BuildContext context) {
    final thirdWidth = MediaQuery.of(context).size.width / 3;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: AppTextStyle.style1.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
        create: (_) => OtpCubit(),
        child: BlocListener<OtpCubit, OtpCubitState>(
          listener: (context, state) async {
            if (_hasNavigated) return;

            if (state is OtpSuccess) {
              if (state.isVerified) {
                _hasNavigated = true;

                // remove pending flags
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('email_pending_verification');
                await prefs.remove('pending_email');

                // try refresh profile
                try {
                  context.read<ProfileCubit>().profile();
                } catch (_) {}

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Verified Successfully!"), backgroundColor: Colors.green));
                // route to login or profile depending your app flow
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => LoginPage()), (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP has been resent!"), backgroundColor: Colors.blue));
              }
            } else if (state is OtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.accent, AppColors.secondary], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.lock_outline, size: 60, color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text("OTP Verification", style: AppTextStyle.style1.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Enter the 6-digit code sent to ${widget.email}", textAlign: TextAlign.center, style: AppTextStyle.style1.copyWith(fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 24),
                          Pinput(
                            length: 6,
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            autofocus: true,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration!.copyWith(border: Border.all(color: AppColors.primary, width: 2), boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 6, spreadRadius: 1)])),
                            submittedPinTheme: defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration!.copyWith(color: Colors.grey.shade100)),
                            separatorBuilder: (_) => const SizedBox(width: 12),
                            showCursor: true,
                          ),
                          const SizedBox(height: 28),
                          BlocBuilder<OtpCubit, OtpCubitState>(builder: (context, state) {
                            if (state is OtpLoading) return const CircularProgressIndicator();
                            return CustomButton(text: "Verify", width: thirdWidth, function: () => _onVerify(context));
                          }),
                          const SizedBox(height: 16),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Text("Didn't receive the code?"),
                            const SizedBox(width: 8),
                            BlocBuilder<OtpCubit, OtpCubitState>(builder: (context, state) {
                              bool isLoading = state is OtpLoading;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonPrimary, foregroundColor: Colors.white, elevation: 2, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                onPressed: isLoading ? null : () => BlocProvider.of<OtpCubit>(context).resendOtp(widget.email.trim()),
                                child: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text("Resend"),
                              );
                            }),
                          ]),
                        ]),
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
