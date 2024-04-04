import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/widgets/reponsive/size_config.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

extension DateStringExtension on String {
  bool get isTodayDateFormat {
    final splitText = split('/');
    final now = DateTime.now();
    return now.day == int.parse(splitText[0]) &&
        int.parse(splitText[2]) == now.year &&
        now.month == int.parse(splitText[1]);
  }
}

extension DateTimeExtension on DateTime? {
  String? get toHourFormat {
    return this == null ? null : DateFormat(HOUR_FORMAT).format(this ?? DateTime.now());
  }

  String? get toDayFormat {
    return this == null ? null : DateFormat(DAY_FORMAT).format(this ?? DateTime.now());
  }

  bool isSameTime(DateTime dateTime) {
    final now = this ?? DateTime.now();
    return now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year &&
        now.hour == dateTime.hour &&
        now.minute == dateTime.minute;
  }

  bool isSameDay(DateTime dateTime) {
    if (this == null) return false;
    return dateTime.day == this!.day && dateTime.month == this!.month && dateTime.year == this!.year;
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.day == this!.day && now.month == this!.month && now.year == this!.year;
  }

  bool get isBeforeToday {
    if (this == null) return false;
    final now = DateTime.now();
    if (this!.year < now.year) {
      return true;
    } else if (this!.year == now.year) {
      if (this!.month > now.month) {
        return false;
      } else if (this!.month == now.month) {
        return this!.day < now.day;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool get isAfterToday {
    if (this == null) return false;
    final now = DateTime.now();
    if (this!.year < now.year) {
      return false;
    } else if (this!.year == now.year) {
      if (this!.month > now.month) {
        return true;
      } else if (this!.month == now.month) {
        return this!.day > now.day;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.of(this).size;
}

extension FocusNodeExtension on FocusNode {
  void unfocusListener(VoidCallback function) {
    addListener(() {
      if (!hasFocus) {
        function();
      }
    });
  }
}

extension Reponsive on num {
  double get w => SizeConfig.instance.getWidth(this) ?? 0;

  double get h => SizeConfig.instance.getHeight(this) ?? 0;

  double get fontSize => SizeConfig.instance.getFontSize(this) ?? 0;
}

EdgeInsets padding({
  double? left,
  double? right,
  double? top,
  double? bottom,
  double? all,
  double? horizontal,
  double? vertical,
}) {
  return SizeConfig.instance.paddingOnly(
        left: all ?? left ?? horizontal,
        right: all ?? right ?? horizontal,
        top: all ?? top ?? vertical,
        bottom: all ?? bottom ?? vertical,
      ) ??
      EdgeInsets.all(0);
  if (all != null) {
    return SizeConfig.instance.paddingAll(all: all) ?? const EdgeInsets.all(0);
  } else if (horizontal != null || vertical != null) {
    return SizeConfig.instance.paddingSymmetric(horizontal: horizontal, vertical: vertical) ??
        const EdgeInsets.symmetric();
  } else {
    return SizeConfig.instance.paddingOnly(left: left, right: right, top: top, bottom: bottom) ??
        const EdgeInsets.only();
  }
}

const _uuid = Uuid();

String getUuid() {
  return _uuid.v1();
}
