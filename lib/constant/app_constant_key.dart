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
  static const ACCOUNT = 'account';
  static const FOOD = 'food';
  static const FOODTYPE = 'food_type';
}

abstract class ERROR_CODE {
  static const UNAUTHOR = 'PGRST301';
}

abstract class DAY_STATUS {
  static const MORNING = 'MORNING';
  static const AFTERNOON = 'AFTERNOON';
}
