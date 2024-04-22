import 'package:food_delivery_app/utils/dialog_util.dart';

class IBaseRepository {
  void handleError(error) {
    print(error);
    if (error.osError != null) {
      final osError = error.osError;
      if (osError.errorCode == 101) {
        DialogUtils.showInfoErrorDialog(content: error.message);
      }
    }
  }
}
