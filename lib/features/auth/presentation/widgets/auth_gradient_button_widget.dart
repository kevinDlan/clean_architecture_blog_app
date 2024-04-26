import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButtonWidget extends StatelessWidget {
  const AuthGradientButtonWidget({
    super.key,
    required this.onTap,
    required this.label,
  });
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * .01;
    double width = MediaQuery.of(context).size.width * .01;
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [AppPallete.gradient1, AppPallete.gradient2]),
          borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.transparentColor,
              shadowColor: AppPallete.transparentColor,
              fixedSize: Size(width * 100, height * 7)),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppPallete.whiteColor),
          )),
    );
  }
}
