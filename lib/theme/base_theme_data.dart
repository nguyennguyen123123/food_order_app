import 'package:flutter/material.dart';

abstract class BaseThemeData {
  Color primaryColor = const Color(0XFF3663FF);
  Color secondaryColor = const Color(0XFFFFB934);
  Color thirdColor = const Color(0x0ff00000);
  Color background = const Color(0XFFF5F5F5);

  Color primaryTextColor = const Color(0XFF3663FF);
  Color secondaryTextColor = const Color(0XFFFFB934);
  Color backgroundTextField = const Color(0XFFFFFFFF);

  Color nullColor = const Color(0XFF00FFFF);

  Color successColor = const Color(0XFF0CAF60);
  Color rejectColor = const Color(0XFFFF333B);
  Color warningColor = const Color(0XFFEC1C24);
  Color errorColor = const Color(0XFFFD4F4F);
  Color failColor = const Color(0XFFEC1C24);

  Color whiteText = const Color(0xFFFFFFFF);
  Color blackText = const Color(0xFF000000);

  Color fadeTextColor = Colors.grey;
  Color fadeBackgroundColor = Colors.grey;

  Color progressBackground = const Color(0XFFBFC6CE);

  Color hintColor = const Color(0XFFB6B7B6);
  Color secondaryErrorColor = const Color(0xFFFEF2F2);
  Color successTextColor = const Color(0XFF0BA259);

  Color successBackgroundColor = const Color(0XFFD0F3E2);
  Color backgroundContainer = const Color(0xFFEFEFEF);

  Color borderColor = const Color(0XFFE1E1E1);
  Color dividerColor = const Color(0XFFC6C6C6);

  Color undefinedColor = const Color(0xFF00FFFF);

  Color unselectedBackgroundColor = const Color(0xFFF2F2F7);

  Color darkGreen = const Color(0xFF0F4A35);

  Color greenLight = const Color(0xFFBADDD0);

  Color blackColor = const Color(0xFF0F172A);

  Color baseColor = const Color(0xFFFF9F29);

  Color greyscale50Color = const Color(0xFFF8FAFC);

  Color greyscale200Color = const Color(0xFFE2E8F0);

  Color greyscale300Color = const Color(0xFFCBD5E1);

  Color greyscale400Color = const Color(0xFF94A3B8);

  Color greyscale500Color = const Color(0xFF64748B);

  Color linearColor = const Color(0xFFF1F5F9);

  Color transparentColor = Colors.transparent;

  Color secondary50Color = const Color(0xFFfff5ea);

  Color colorLightmode = const Color(0xFFB6BBC3);

  Color colorLightmodeNeutral40 = const Color(0xFF9AA0AC);

  Color textDesColor = const Color(0xFF7E8695);

  Color background700Color = const Color(0xFF9AA0AC);

  Color usageSematicErrorColor = const Color(0xFFF73131);

  Color lineColor = const Color(0xFFF4F4F6);

  Color sixNumberColor = const Color(0xFF666666);

  Color textInputColor = const Color(0xFF373743);

  Color cardSendTimeColor = const Color(0xFF8E9AA3);

  Color notiMessTextColor = const Color(0xFF848C94);

  Color audioColor = const Color(0xFFF0F6FF);

  Color backgroundAvatarColor = const Color(0XFFD1D5DA);

  Color frameColor = const Color(0xFFC9CCD1);

  Color appColor = const Color(0xFF514BF6);

  Color oneActiveColor = const Color(0xFF5E7DF5);
  Color twoActiveColor = const Color(0xFF5661F5);
  Color fatherActiveColor = const Color(0xFF514BF6);

  Color primary40Color = const Color(0xFF5488F5);

  LinearGradient activeGradient = LinearGradient(
    colors: const [
      Color(0xFF5E7DF5),
      Color(0xFF5661F5),
      Color(0xFF514BF6),
    ],
  );

  Color topBTSColor = const Color(0xFFD2D5DA);

  Color greyColor = const Color(0xFF4E535F);
  // Color activeSwitchBackground = const Color(0XFFD1E6FA);
  // Color activeSwitch = const Color(0XFF3B86E8);
}
