import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          "assets/images/background.svg",
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: double.maxFinite,
        ),
        child
      ],
    );
  }
}
