import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final IconData? icon;
  final Color? dynamicBackgroundColor;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 60,
    this.icon,
    this.dynamicBackgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool useDynamicColor =
        onPressed != null && dynamicBackgroundColor != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: useDynamicColor ? dynamicBackgroundColor : null,
            gradient:
                useDynamicColor
                    ? null
                    : const LinearGradient(
                      colors: [
                        Color(0xFF7A4DB6),
                        Color(0xFFDFCEF7),
                        Color(0xFFF0E7FB),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
          ),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color:
                                useDynamicColor
                                    ? Colors.white
                                    : AppColors.darkPurple,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            color:
                                useDynamicColor
                                    ? Colors.white
                                    : AppColors.darkPurple,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
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
