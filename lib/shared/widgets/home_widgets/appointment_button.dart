import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class NewAppointmentButton extends StatefulWidget {
  final VoidCallback onPressed;

  const NewAppointmentButton({Key? key, required this.onPressed})
    : super(key: key);

  @override
  _NewAppointmentButtonState createState() => _NewAppointmentButtonState();
}

class _NewAppointmentButtonState extends State<NewAppointmentButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 22,
            ),
            label: const Text(
              'حجز موعد جديد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              
            }, 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.primary.withOpacity(0.8);
                }
                return AppColors.primary;
              }),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.2),
              ),
              elevation: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return 2.0;
                }
                return 8.0;
              }),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 16),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
