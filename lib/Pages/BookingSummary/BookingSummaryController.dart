import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';

import 'BookingSummaryModel.dart';

class BookingSummaryController extends GetxController {
  var bookingSummaryObj = BookingSummaryData();
  var servcesIcon = true.obs;

  @override
  void onInit() async {
    super.onInit();
    bookingSummaryObj = Get.arguments;
    Preferences.preferences
        .saveBool(key: PrefernceKey.isGuestUser, value: false);
  }
}
