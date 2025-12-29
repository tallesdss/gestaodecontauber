import 'package:flutter/material.dart';

class AppSpacing {
  // Espaçamentos base
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Padding presets
  static const paddingXS = EdgeInsets.all(xs);
  static const paddingSM = EdgeInsets.all(sm);
  static const paddingMD = EdgeInsets.all(md);
  static const paddingLG = EdgeInsets.all(lg);
  static const paddingXL = EdgeInsets.all(xl);
  static const paddingXXL = EdgeInsets.all(xxl);
  static const paddingXXXL = EdgeInsets.all(xxxl);

  // Padding horizontal
  static const horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  // Padding vertical
  static const verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const verticalMD = EdgeInsets.symmetric(vertical: md);
  static const verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const verticalXXL = EdgeInsets.symmetric(vertical: xxl);
}

