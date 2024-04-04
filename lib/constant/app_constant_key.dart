import 'dart:ui';

const DAY_FORMAT = 'dd/MM/yyyy';
const DAY_MONTH_FORMAT = 'dd/MM';
const HOUR_FORMAT = 'HH:mm';

class AppConstant {}

const List<Locale> supportedLocales = <Locale>[
  Locale('vi'),
  Locale('en'),
];

abstract class BUCKET_ID {
  static const IMAGE = 'image';
}

abstract class TABLE_NAME {
  static const EMPLOYEE = 'employee';
  static const WORKING_TIME = 'working_time';
  static const HEART_MEASURE = 'heart_measure';
}

abstract class ERROR_CODE {
  static const UNAUTHOR = 'PGRST301';
}

abstract class DAY_STATUS {
  static const MORNING = 'MORNING';
  static const AFTERNOON = 'AFTERNOON';
}
