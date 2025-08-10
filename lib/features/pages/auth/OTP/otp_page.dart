// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:midical_laboratory/core/routes.dart';
// import 'package:midical_laboratory/shared/widgets/custom_button.dart';

// class OtpView extends StatefulWidget {
//   final String email;
//   const OtpView({Key? key, required this.email}) : super(key: key);

//   @override
//   State<OtpView> createState() => _OtpViewState();
// }

// class _OtpViewState extends State<OtpView> {
//   final _formKey = GlobalKey<FormState>();
//   final _otpController = TextEditingController();

//   // وضعنا 300 ثانية = 5 دقائق
//   int _resendCooldown = 0;
//   Timer? _cooldownTimer;

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // طلب إرسال OTP لمرة أولى
//     context.read<OtpBloc>().add(RequestOtp(email: widget.email));
//     _startResendCooldown();
//   }

//   void _resend() {
//     if (_resendCooldown > 0) return;
//     context.read<OtpBloc>().add(RequestOtp(email: widget.email));
//     _startResendCooldown();
//   }

//   void _startResendCooldown() {
//     _cooldownTimer?.cancel();
//     setState(() => _resendCooldown = 300);

//     _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendCooldown <= 1) {
//         timer.cancel();
//         setState(() => _resendCooldown = 0);
//       } else {
//         setState(() => _resendCooldown--);
//       }
//     });
//   }

//   void _submitOtp() {
//     if (_formKey.currentState!.validate()) {
//       context.read<OtpBloc>().add(
//         VerifyOtp(email: widget.email, code: _otpController.text.trim()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<OtpBloc, OtpState>(
//       listener: (context, state) {
//         if (state is OtpSent) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(' تم إرسال الرمز إلى ${widget.email}')),
//           );
//         }
//         if (state is OtpVerified) {
//           Navigator.pushReplacementNamed(context, Routes.login);
//         }
//         if (state is OtpFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('التحقق من الرمز'),
//           centerTitle: true,
//           leading: BackButton(
//             onPressed:
//                 () => Navigator.popAndPushNamed(context, Routes.register),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'أدخل الرمز المكون من 6 أرقام\nالمرسل إلى ${widget.email} :',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 widget.email,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 24),
//               Form(
//                 key: _formKey,
//                 child: TextFormField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   maxLength: 6,
//                   decoration: InputDecoration(
//                     counterText: '',
//                     filled: true,
//                     fillColor: Colors.green.shade50,
//                     hintText: '••••••',
//                     hintStyle: TextStyle(letterSpacing: 16, color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   style: const TextStyle(letterSpacing: 16, fontSize: 20),
//                   validator: (v) {
//                     if (v == null || v.trim().length != 6) {
//                       return 'الرجاء إدخال الرمز الصحيح';
//                     }
//                     return null;
//                   },
//                 ),
//               ),

//               const SizedBox(height: 32),
//               CustomButton(
//                 text: 'تأكيد الرمز',
//                 function: _submitOtp,
//                 background: Colors.green.shade600,
//                 icon: Icons.lock_open,
//               ),

//               const SizedBox(height: 16),
//               CustomButton(
//                 text:
//                     _resendCooldown == 0
//                         ? 'طلب رمز جديد'
//                         : 'أعدّ $_resendCooldown ثانية',
//                 function: _resendCooldown == 0 ? _resend : () {},
//                 background:
//                     _resendCooldown == 0
//                         ? Colors.green.shade600
//                         : Colors.grey.shade400,
//                 icon: Icons.refresh,
//               ),

//               const SizedBox(height: 24),
//               Text(
//                 'لم يصلك الرمز؟ انتظر 5 دقائق ثم حاول مرة أخرى.',
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
