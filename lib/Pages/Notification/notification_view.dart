import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/Notification/notification_controller.dart';
import 'package:reserve_for_you_user/Pages/Notification/notifications_model.dart';
import 'package:intl/intl.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  NotificationController _notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    print("notification");
    _notificationController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            Container(
              width: Get.width,
              color: Color(AppColor.maincategorySelectedColor),
              margin: EdgeInsets.only(left: 0, top: 0, bottom: 0),
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AssestPath.profile + "Logo_Home.png",
                    height: 20,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'notification'.tr,
                    style: TextStyle(fontFamily: AppFont.bold, fontSize: 22),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_notificationController.loader.isFalse) {
                  return SmartRefresher(
                    controller: _notificationController.refreshController,
                    onRefresh: () {
                      _notificationController.getNotifications();
                    },
                    header: ClassicHeader(
                      completeText: 'refreshCompleted'.tr,
                      releaseText: 'releaseToRefresh'.tr,
                      idleText: 'pullDownRefresh'.tr,
                    ),
                    enablePullDown: true,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      itemCount: _notificationController.notificationModel.value.responseData.length,
                      itemBuilder: (context, index) {
                        ResponseDatum obj = _notificationController.notificationModel.value.responseData[index];
                        timeAgo(DateTime.parse(obj.updatedAt.toString()));
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              print('onNotificationTap');
                              print(obj);
                              _notificationController.onNotificationTap(obj);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200, width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(AppColor.maincategorySelectedColor),
                                    offset: Offset(0, 0.7),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        obj.title,
                                        style: TextStyle(
                                          color: obj.title == "Termin storniert !"
                                              ? Color(0xFFdb8a8a)
                                              : obj.title == "Appointment Postpond !"
                                                  ? Color(0xFFfaba5f)
                                                  : obj.title == "Feedback reply !"
                                                      ? Color(0xFF17a2b8)
                                                      : Colors.black,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        isToday(obj.createdAt.toLocal())
                                            ? DateFormat('kk:mm').format(obj.createdAt.toLocal())
                                            : DateFormat('dd.MM.yyyy', 'nextbtn'.tr == "Next" ? 'de' : 'en').format(obj.createdAt.toLocal()),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    obj.description.trimLeft(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        obj.timeago,
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                      _notificationController.notificationModel.value.responseData[index].type == Type.CUSTOMER_REQUEST
                                          ? Row(
                                              children: [
                                                InkWell(
                                                    onTap: () => _notificationController.setPermission(obj, "1"),
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(color: Color(0xff006633), borderRadius: BorderRadius.circular(25)),
                                                      child: Text(
                                                        "accept".tr,
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () => _notificationController.setPermission(obj, "2"),
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(color: Color(0xffff0000), borderRadius: BorderRadius.circular(25)),
                                                    child: Text(
                                                      "reject".tr,
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : (_notificationController.notificationModel.value.responseData[index].type == Type.REVIEW_REQUEST
                                              ? InkWell(
                                                  onTap: () => _notificationController.giveFeedBack(_notificationController.notificationModel.value.responseData[index]),
                                                  child: Container(
                                                    decoration:
                                                        BoxDecoration(color: Colors.black, border: Border.all(color: Colors.yellow), borderRadius: BorderRadius.circular(25)),
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "review".tr,
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : Container())
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CommanWidget(context: context).showlolder(isshowDilog: true);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  String getMonthName(int month) {
    List<String> list = [
      'january'.tr,
      'february'.tr,
      'march'.tr,
      'april'.tr,
      'may'.tr,
      'june'.tr,
      'july'.tr,
      'august'.tr,
      'september'.tr,
      'october'.tr,
      'november'.tr,
      'december'.tr,
    ];

    return list[month - 1];
  }

  bool isToday(DateTime time) {
    DateTime now = DateTime.now();

    if (now.day == time.day && now.month == time.month && now.year == time.year) {
      return true;
    } else {
      return false;
    }
  }

  void detailPopup(ResponseDatum obj) {}
}
