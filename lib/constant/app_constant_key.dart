import 'dart:ui';

const DAY_FORMAT = 'dd/MM/yyyy';
const DAY_MONTH_FORMAT = 'dd/MM';
const HOUR_FORMAT = 'HH:mm';

const LIMIT = 10;

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
  static const FOOD_ORDER = 'food_order';
  static const FOOD_ORDER_ITEM = 'food_order_item';
  static const ORDER_ITEM = 'order_item';
  static const PRINTER = 'printer';
  static const TABLE = 'table';
  static const VOUCHER = 'voucher';
  static const PARTY_ORDER = 'party_order';
  static const PARTY_ORDER_ITEM = 'party_order_item';
  static const ORDER_WITH_PARTY = 'order_with_party';
}

abstract class ERROR_CODE {
  static const UNAUTHOR = 'PGRST301';
}

abstract class DAY_STATUS {
  static const MORNING = 'MORNING';
  static const AFTERNOON = 'AFTERNOON';
}

abstract class GENDER {
  static const MAN = 'MAN';
  static const FEMALE = 'FEMALE';

  static const map = {
    GENDER.MAN: "Nam",
    GENDER.FEMALE: "Nữ",
  };
}

abstract class USER_ROLE {
  static const ADMIN = 'ADMIN';
  static const STAFF = 'STAFF';

  static const map = {
    USER_ROLE.ADMIN: "ADMIN",
    USER_ROLE.STAFF: "STAFF",
  };
}

abstract class ORDER_STATUS {
  static const CREATED = 'CREATED';
  static const DONE = 'DONE';
}

abstract class ORDER_TYPE {
  static const NORMAL = 'NORMAL';
  static const PARTY = 'PARTY';
}
