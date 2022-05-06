import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/BookingController.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/CancleConfirmation.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/MyBookinModel.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/SettingController.dart';

// ignore: must_be_immutable
class BookingView extends StatelessWidget {
  BookingController _bookingController = Get.find();
  SettingController _settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Scaffold(
        backgroundColor: Color(0xfff6f6f8),
        body: SafeArea(
            child: Obx(
          () => Column(
            children: [
              tabView(),
              if (_bookingController.selectedIndex.value == 0)
                pending()
              else if (_bookingController.selectedIndex.value == 1)
                running()
              else if (_bookingController.selectedIndex.value == 2)
                completed()
              else
                cancled(),
              SizedBox(
                height: 80,
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget tabView() {
    return DefaultTabController(
      length: 4,
      initialIndex: _bookingController.isHomeScreen == 'cancel'
          ? 3
          : (_bookingController.isHomeScreen == 'pending' ? 0 : (_bookingController.isHomeScreen == 'running' ? 1 : (_bookingController.isHomeScreen == 'completed' ? 2 : 0))),
      child: Container(
        decoration: BoxDecoration(
          color: Color(AppColor.bgColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          onTap: (ind) {
            _bookingController.selectedIndex.value = ind;
            ind == 0
                ? _bookingController.getBookingData("pending")
                : ind == 1
                    ? _bookingController.getBookingData("running")
                    : ind == 2
                        ? _bookingController.getBookingData("completed")
                        : _bookingController.getBookingData("cancel");
          },
          labelPadding: EdgeInsets.all(0),
          labelStyle: TextStyle(
            fontFamily: AppFont.regular,
            fontSize: 14,
          ),
          indicatorColor: Color(AppColor.maincategorySelectedTextColor),
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          tabs: [
            Tab(
              text: 'pending'.tr,
            ),
            Tab(
              text: 'running'.tr,
            ),
            Tab(
              text: "completed".tr,
            ),
            Tab(
              text: 'canceled'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget containerDetail(Color btnClr, String text, bool yelloCon, bool blueCon, bool pinkCon, PendingModel data, {bool cancleButton = false}) {
    List<String> nameList;
    String name = '';
    if (data.serviceExpert != null) {
      nameList = data.serviceExpert.split(' ');
      if (nameList.length == 2) {
        name = nameList.first[0].toUpperCase() + nameList.last[0].toUpperCase();
      } else {
        name = nameList.first[0].toUpperCase() + nameList.first[1].toUpperCase();
      }
    } else {
      name = '-';
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Visibility(
            visible: yelloCon,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 350,
              width: Get.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(AppColor.starContainer)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.remainingtime,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: AppFont.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //  margin: EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  Container(
                    height: 85,
                    width: Get.width,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 70,
                              width: 110,
                              child: CachedNetworkImage(
                                imageUrl: data.serviceImage,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/selectservices.png",
                                        ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/selectservices.png",
                                        ),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'bookingId'.tr,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "#" + data.orderId.toString(),
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: Get.width - 210,
                              child: Text(
                                data.serviceName == null ? '(No Name)' : data.serviceName,
                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: AppFont.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    // height: 55,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(color: Color(AppColor.textFieldBg), borderRadius: BorderRadius.circular(15)),
                    child: data.variantData == null
                        ? Center(
                            child: Text(
                              "-",
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width * 0.3,
                                      child: Text(
                                        data.variantData.description == null ? " - " : data.variantData.description,
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontFamily: AppFont.regular, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "${data.variantData.durationOfService} min",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      getStatusName(data.status),
                                      style: TextStyle(fontSize: 13, fontFamily: AppFont.regular),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      data.price + "€",
                                      style: TextStyle(color: Color(AppColor.maincategorySelectedTextColor), fontSize: 15, fontFamily: AppFont.semiBold),
                                    ),
                                    data.status == "reschedule"
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                'rescheduleAppointment'.tr,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    borderRadius: BorderRadius.circular(8),
                                                    onTap: () {
                                                      _bookingController.goReScheduleTimePage(data);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFdb8a8a))),
                                                      child: Text(
                                                        'accept'.tr,
                                                        style: TextStyle(fontSize: 11),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  InkWell(
                                                    borderRadius: BorderRadius.circular(8),
                                                    onTap: () {
                                                      _bookingController.selectedAppoinmentId = data.appointmentId.toString();
                                                      _bookingController.selectedVariantid = data.variantData.id.toString();

                                                      Get.dialog(CancleConfirmation());
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                                      decoration:
                                                          BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xFFdb8a8a))),
                                                      child: Text(
                                                        'cancel'.tr,
                                                        style: TextStyle(fontSize: 11, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(width: 5),
                                Visibility(
                                  visible: (text != 'cancel'.tr || cancleButton && (data.isCancellation == "yes")) && data.status != "reschedule",
                                  child: InkWell(
                                    onTap: () {
                                      if (text == 'cancel'.tr) {
                                        _bookingController.selectedAppoinmentId = data.appointmentId.toString();
                                        _bookingController.selectedVariantid = data.variantData.id.toString();

                                        Get.dialog(CancleConfirmation());
                                      }
                                      if (text == 'bookAgain'.tr) {
                                        _bookingController.sendSelectedServiceDataToServer(
                                          categoryid: data.categoryId.toString(),
                                          serviceId: data.serviceId.toString(),
                                          varientId: data.variantId.toString(),
                                          storeid: data.storeId.toString(),
                                          subcategoryid: data.subcategoryId.toString(),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 35,
                                      width: text == 'cancel'.tr ? 80 : 100,
                                      decoration: BoxDecoration(color: btnClr, borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        /*_bookingController.isHomeScreen == "completed"?"".tr:*/
                                        text,
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: AppFont.medium),
                                      )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    height: 70,
                    width: Get.width,
                    decoration: BoxDecoration(color: Color(AppColor.reviewContainer), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: BorderRadius.circular(23)),
                          child: Container(
                              margin: EdgeInsets.all(8),
                              child: Image.asset(
                                AssestPath.favourite + "pin.png",
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.toNamed("/storeDetailsView", arguments: data.storeId.toString());
                              },
                              child: Text(
                                data.storeName,
                                style: TextStyle(fontSize: 15, fontFamily: AppFont.bold),
                              ),
                            ),
                            SizedBox(height: 3),
                            SizedBox(
                              width: 200,
                              child: Text(
                                data.storeAddress,
                                maxLines: 2,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: Get.width,
                    decoration: BoxDecoration(color: Color(AppColor.bgColor), borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: name != '-' &&
                                    (data.serviceExpertImgae == 'https://www.reserved4you.de/storage/app/public/default/default-user.png' ||
                                        data.serviceExpertImgae == null ||
                                        data.serviceExpertImgae == '')
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFFdb8a8a), width: 0.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFdb8a8a),
                                        ),
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: data.serviceExpertImgae,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF101928),
                                        borderRadius: BorderRadius.circular(60),
                                        border: Border.all(color: Colors.white, width: 2),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/defaultuser.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF101928),
                                        borderRadius: BorderRadius.circular(60),
                                        border: Border.all(color: Colors.white, width: 2),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/defaultuser.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF101928),
                                        borderRadius: BorderRadius.circular(60),
                                        border: Border.all(color: Colors.white, width: 2),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.serviceExpert ?? 'anyPerson'.tr,
                                style: TextStyle(fontFamily: AppFont.semiBold, color: Color(AppColor.maincategorySelectedTextColor)),
                              ),
                              SizedBox(height: 3),
                              SizedBox(
                                width: Get.width - 140,
                                child: Text(
                                  data.appoDate + " - " + data.appoTime + " - " + "${data.appEndTime.split(':').first}:${data.appEndTime.split(':')[1]}",
                                  style: TextStyle(
                                      fontFamily: AppFont.semiBold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var arr = [
                        data.storeId, //0
                        data.storeName, //1
                        data.storeimage, //2
                        data.serviceId.toString(), //3
                        data.serviceName, //4
                        data.serviceExpert, //5
                        data.storeEmpId.toString(), //6
                        data.categoryId.toString(), //7
                        data.subcategoryId.toString(),
                        data.id.toString(), //8
                        data.appointmentId.toString(), //8
                        false,
                      ];
                      if (data.isReviewed == null) {
                        Get.toNamed('/giveFeedback', arguments: arr).then((value) {
                          _bookingController.getBookingData(_bookingController.selectedStatus);
                        });
                      } else {
                        _settingController.getAllUserReviews();
                        Get.toNamed('/givenreview', arguments: arr);
                      }
                    },
                    child: Visibility(
                      visible: blueCon,
                      child: Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFF101928)),
                        child: Center(
                            child: Text(
                          data.isReviewed == null ? 'sharYourReview'.tr : 'showRating'.tr,
                          style: TextStyle(color: Colors.white, fontFamily: AppFont.medium, decoration: TextDecoration.underline),
                        )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: pinkCon,
                    child: InkWell(
                      child: Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(AppColor.maincategorySelectedColor)),
                        child: Center(
                            child: Text(
                          'seeCencelationReason'.tr,
                          style: TextStyle(color: Color(AppColor.maincategorySelectedTextColor), fontFamily: AppFont.medium, decoration: TextDecoration.underline),
                        )),
                      ),
                      onTap: () {
                        Get.bottomSheet(bottomContainer(data));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getStatusName(String status) {
    if (status == 'booked') {
      return 'bookedStatus'.tr;
    } else if (status == 'pending') {
      return 'pendingStatus'.tr;
    } else if (status == 'running') {
      return 'runningStatus'.tr;
    } else if (status == 'reschedule') {
      return 'rescheduleStatus'.tr;
    } else if (status == 'completed') {
      return 'completedStatus'.tr;
    } else if (status == 'cancel') {
      return 'cancelStatus'.tr;
    } else {
      return "Error";
    }
  }

  Widget bottomContainer(PendingModel data) {
    return data.isBlank
        ? Text("null")
        : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: Get.width,
                  height: Get.height / 2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Color(0xfffef4ee)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'reasonForCancellation'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(AppColor.firstColour), fontFamily: AppFont.bold, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  height: Get.height / 2 - 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Color(0xffffffff)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 70,
                                  width: 125,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black38,
                                      image: DecorationImage(image: NetworkImage(data.serviceImage), fit: BoxFit.fill)),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'bookingId'.tr,
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      "#" + data.appointmentId.toString(),
                                      style: TextStyle(fontSize: 13, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data.serviceName,
                                  style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: AppFont.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'iCanceledTheBookingBecause'.tr,
                          style: TextStyle(fontSize: 20, fontFamily: AppFont.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(data.cancelReason, maxLines: 4, style: TextStyle(fontSize: 18, color: Color(0xff9ca0a5), fontFamily: AppFont.bold)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget cosmeticPopUp() {
    return Container(
      height: 250,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)), color: Color(AppColor.bgColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: Get.width,
            child: Center(
                child: Text(
              'Change Sercice',
              style: TextStyle(color: Color(AppColor.maincategorySelectedTextColor), fontSize: 20, fontFamily: AppFont.bold),
            )),
            decoration: BoxDecoration(
              color: Color(AppColor.maincategorySelectedColor),
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: Get.width,
                  color: Color(AppColor.bgColor),
                  child: Text(
                    "Gastronomy - (Coming Soon)".tr,
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: AppFont.medium),
                  ),
                ),
                Container(
                  height: 40,
                  width: Get.width,
                  color: Color(AppColor.bgColor),
                  child: Text(
                    "Cosmetic",
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: AppFont.medium),
                  ),
                ),
                Container(
                  height: 40,
                  width: Get.width,
                  color: Color(AppColor.bgColor),
                  child: Text(
                    "Health - (Coming Soon)".tr,
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: AppFont.medium),
                  ),
                ),
                Container(
                  height: 40,
                  width: Get.width,
                  color: Color(AppColor.bgColor),
                  child: Text(
                    "Law & Advise - (Coming Soon)".tr,
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: AppFont.medium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget running() {
    return Expanded(
      // ignore: invalid_use_of_protected_member
      child: _bookingController.arrBookingData.value.isBlank
          ? Center(
              child: Text(
              'nobookings'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontFamily: AppFont.bold, color: Colors.black),
            ))
          : SmartRefresher(
              controller: _bookingController.refresh2Controller,
              header: ClassicHeader(
                completeText: 'refreshCompleted'.tr,
                releaseText: 'releaseToRefresh'.tr,
                idleText: 'pullDownRefresh'.tr,
              ),
              enablePullDown: true,
              onRefresh: () {
                _bookingController.getBookingData(_bookingController.selectedStatus);
              },
              child: ListView.builder(
                itemCount: _bookingController.arrBookingData.length,
                itemBuilder: (context, index) {
                  // ignore: invalid_use_of_protected_member
                  var currentObj = _bookingController.arrBookingData.value[index];
                  return containerDetail(
                    Color(0xFF101928),
                    'cancel'.tr,
                    false,
                    false,
                    false,
                    currentObj,
                  );
                },
              ),
            ),
    );
  }

  Widget pending() {
    return Expanded(
        // ignore: invalid_use_of_protected_member
        child: _bookingController.arrBookingData.value.isBlank
            ? Center(
                child: Text(
                'nobookings'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontFamily: AppFont.bold, color: Colors.black),
              ))
            : Obx(() {
                if (_bookingController.isHomeScreen == 'pending' && _bookingController.isLoader.isFalse && _bookingController.scrollFirstTime == false) {
                  _bookingController.scrollFirstTime = true;
                  _bookingController.onPendingScrollJump();
                }
                return SmartRefresher(
                  controller: _bookingController.refresh1Controller,
                  header: ClassicHeader(
                    completeText: 'refreshCompleted'.tr,
                    releaseText: 'releaseToRefresh'.tr,
                    idleText: 'pullDownRefresh'.tr,
                  ),
                  enablePullDown: true,
                  onRefresh: () {
                    _bookingController.getBookingData(_bookingController.selectedStatus);
                  },
                  child: ListView.builder(
                    controller: _bookingController.pendingScroll,
                    itemCount: _bookingController.arrBookingData.length,
                    itemBuilder: (context, index) {
                      // ignore: invalid_use_of_protected_member
                      if (_bookingController.arrBookingData.length == 0) {
                        return SizedBox();
                      }
                      var currentObj = _bookingController.arrBookingData.value[index];
                      return containerDetail(Color(0xFF101928), 'cancel'.tr, false, false, false, currentObj, cancleButton: true);
                    },
                  ),
                );
              }));
  }

  Widget completed() {
    return Expanded(
      child: _bookingController.arrBookingData.isBlank
          ? Center(
              child: Text(
              'nobookings'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontFamily: AppFont.bold, color: Colors.black),
            ))
          : Obx(() {
              if (_bookingController.isHomeScreen == 'completed' && _bookingController.scrollFirstTime == false) {
                _bookingController.scrollFirstTime = true;
                _bookingController.onCompleteScrollJump();
              }
              return SmartRefresher(
                controller: _bookingController.refresh3Controller,
                header: ClassicHeader(
                  completeText: 'refreshCompleted'.tr,
                  releaseText: 'releaseToRefresh'.tr,
                  idleText: 'pullDownRefresh'.tr,
                ),
                enablePullDown: true,
                onRefresh: () {
                  _bookingController.getBookingData(_bookingController.selectedStatus);
                },
                child: ListView.builder(
                  controller: _bookingController.completeScroll,
                  itemCount: _bookingController.arrBookingData.length,
                  itemBuilder: (context, index) {
                    // ignore: invalid_use_of_protected_member
                    if (_bookingController.arrBookingData == null || _bookingController.arrBookingData.length == 0) {
                      return SizedBox();
                    }
                    var currentObj = _bookingController.arrBookingData.value[index];
                    return containerDetail(Color(0xFFdb8a8a), 'bookAgain'.tr, false, true, false, currentObj);
                  },
                ),
              );
            }),
    );
  }

  Widget cancled() {
    return Expanded(
      child: _bookingController.arrBookingData.value.isBlank
          ? Center(
              child: Text(
              'nobookings'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontFamily: AppFont.bold, color: Colors.black),
            ))
          : Obx(() {
              if (_bookingController.isHomeScreen == 'cancel' && _bookingController.isLoader.isFalse && _bookingController.scrollFirstTime == false) {
                _bookingController.scrollFirstTime = true;
                _bookingController.onCancelScrollJump();
              }
              return SmartRefresher(
                controller: _bookingController.refresh4Controller,
                header: ClassicHeader(
                  completeText: 'refreshCompleted'.tr,
                  releaseText: 'releaseToRefresh'.tr,
                  idleText: 'pullDownRefresh'.tr,
                ),
                enablePullDown: true,
                onRefresh: () {
                  _bookingController.getBookingData(_bookingController.selectedStatus);
                },
                child: ListView.builder(
                  controller: _bookingController.cancelScroll,
                  itemCount: _bookingController.arrBookingData.length,
                  itemBuilder: (context, index) {
                    // ignore: invalid_use_of_protected_member
                    if (_bookingController.arrBookingData.length == 0) {
                      return SizedBox();
                    }
                    var currentObj = _bookingController.arrBookingData.value[index];
                    return containerDetail(Color(0xffdb8a8a), 'bookAgain'.tr, false, false, true, currentObj);
                  },
                ),
              );
            }),
    );
  }
}
