import 'package:flutter/material.dart';

class CouponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);

    final radius = size.height * .065;

    Path holePath = Path();

    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(0, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }
    for (int i = 1; i <= 4; i++) {
      holePath.addOval(
        Rect.fromCircle(
          center: Offset(size.width, (size.height * .2) * i),
          radius: radius,
        ),
      );
    }

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
