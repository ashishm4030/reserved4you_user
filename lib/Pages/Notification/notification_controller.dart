import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsView.dart';
import 'package:reserve_for_you_user/Pages/Notification/notification_service.dart';
import 'package:reserve_for_you_user/Pages/Notification/notifications_model.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/MyBooking.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/givenReview.dart';
import 'package:reserve_for_you_user/Pages/Tabbar/bottombar_controller.dart';

class NotificationController extends GetxController {
  Rx<NotificationsModel> notificationModel = NotificationsModel().obs;
  RefreshController refreshController = RefreshController();
  RxBool loader = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkIfLoginOrNot();
  }

  void checkIfLoginOrNot() async {
    refreshController = RefreshController();
    var isLogin = await Preferences.preferences.getBool(key: PrefernceKey.isUserLogin, defValue: false);

    if (isLogin) {
      getNotifications();
    } else {
      //Get.back();
      Get.toNamed('/login', arguments: true);
    }
  }

  Future<void> getNotifications() async {
    notificationModel.value = await NotificationService.getNotifications().then((value) {
      loader.value = false;
      return value;
    });
    preferences.saveInt(
      key: PrefernceKey.totalNotification,
      value: notificationModel.value.responseData.length,
    );
    bottomBarController.notificationBadge.value = false;
    refreshController.refreshCompleted();
  }

  Future<void> setPermission(ResponseDatum obj, String action) async {
    ApiProvider apiProvider = ApiProvider();
    await apiProvider.post(ApiUrl.permission, {"store_id": obj.storeId, "user_id": obj.userId, "action": action}).then((value) {
      print(value.body);
      getNotifications();
    });
  }

  void onNotificationTap(ResponseDatum obj) {
    print('obj.title');
    print(obj.title);
    if (obj.title == "Antwort auf dein Feedback!") {
      Get.to(() => Givenreview());
    } else if (obj.title == 'Termin storniert !' || obj.title == 'Verschoben !') {
      //Get.to(() => MyBooking(), arguments: 'cancel');
      Get.to(() => MyBooking(), arguments: {
        'status': 'cancel',
        'appointment_id': obj.appointmentId,
      });
    } else if (obj.title == "Feedback reply !") {
      Get.to(
        () => StoreDetailsView(),
        arguments: {'storeId': obj.storeId, 'isHome': true, 'id': obj.appointmentId, 'type': obj.type},
      );
    } else if (obj.title == 'Bewertungsanfrage !') {
      Get.to(() => MyBooking(), arguments: {
        'status': 'completed',
        'appointment_id': obj.appointmentId,
        'id': obj.id,
        'type': obj.type,
      });
    } else if (obj.title == 'Kundenprofil - Anfrage !') {
    } else {
      Get.to(() => MyBooking(), arguments: {
        'status': 'pending',
        'appointment_id': obj.appointmentId,
      });
    }
  }

  Future<void> giveFeedBack(ResponseDatum obj) async {
    Get.toNamed('/giveFeedback', arguments: [
      obj.storeId,
      obj.appointment.storeName,
      obj.appointment.storeProfileImagePath,
      obj.appointment.serviceId,
      obj.appointment.serviceName,
      obj.appointment.empName,
      obj.appointment.storeEmpId,
      "",
      "",
      obj.appointment.id,
      false,
    ]).then((value) {
      getNotifications();
    });
  }
}
