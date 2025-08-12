import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'dart:async';

import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();

    Timer(const Duration(seconds: 8), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.biotech_rounded,
                      color: AppColors.primary,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    "Medical Laboratory",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonPrimaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    "Connecting Patients with Labs",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
