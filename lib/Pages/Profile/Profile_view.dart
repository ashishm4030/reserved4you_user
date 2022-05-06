import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/Profile/Profile_Controller.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/SettingController.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController _profileController = Get.put(ProfileController());
  SettingController _settingController = Get.put(SettingController());

  @override
  void initState() {
    _profileController.checkIfLoginOrNot();
    print("profile view");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  profileHeader(),
                  Obx(() => imageCircle()),
                ],
              ),
              Obx(() => customerDetail()),
              SizedBox(height: Get.height * 0.04),
              profileBottom(),
              Text(
                'Version 1.0.0(20)',
                style: TextStyle(fontFamily: AppFont.medium, fontSize: 17),
              ),
              SizedBox(height: Get.height * 0.04),
            ],
          ),
          Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _profileController.isLoader.value))
        ],
      ),
    );
  }

  Widget profileHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: Get.height * 0.24,
      width: Get.width,
      color: Color(AppColor.maincategorySelectedColor),
      child: Stack(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    AssestPath.profile + "Logo_Home.png",
                    height: 20,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'titelofProfile'.tr,
                    style: TextStyle(fontSize: 22, fontFamily: AppFont.bold),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed('/editView');
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(color: Color(AppColor.maincategorySelectedTextColor), spreadRadius: -2, offset: Offset(-1, 2), blurRadius: 5)]),
                          child: Container(
                            child: Image.asset(AssestPath.profile + "Edit.png"),
                            margin: EdgeInsets.all(13),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          _settingController.getAllUserReviews();
                          Get.toNamed('/settingView');
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Color(AppColor.maincategorySelectedTextColor), spreadRadius: -2, offset: Offset(-1, 2), blurRadius: 5)],
                              color: Color(AppColor.maincategorySelectedTextColor),
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            child: Image.asset(
                              AssestPath.profile + "Setting.png",
                            ),
                            margin: EdgeInsets.all(13),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget imageCircle() {
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.15),
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        children: [
          (_profileController.userDataObj.value.userImagePath == null || _profileController.userDataObj.value.userImagePath.isEmpty)
              ? Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.white, width: 3), color: Colors.black),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _profileController.userDataObj.value.userName,
                        style: TextStyle(color: Color(0xFFFABA5F), fontFamily: AppFont.medium, fontSize: Get.height * 0.04),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 140,
                    width: 140,
                    child: CachedNetworkImage(
                      imageUrl: _profileController.userDataObj.value.userImagePath,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF101928),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 3),
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
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 3),
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
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget customerDetail() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            (_profileController.userDataObj.value.firstName == null ? "" : _profileController.userDataObj.value.firstName) +
                "  " +
                (_profileController.userDataObj.value.lastName == null ? "" : _profileController.userDataObj.value.lastName),
            style: TextStyle(
              fontFamily: AppFont.bold,
              fontSize: Get.height * 0.03,
            ),
          ),
          Text(
            _profileController.userDataObj.value.email == null ? "" : _profileController.userDataObj.value.email,
            style: TextStyle(fontSize: Get.height * 0.018, color: Colors.grey, fontFamily: AppFont.regular),
          ),
          SizedBox(height: 22),
          Container(
            height: Get.height * 0.22,
            width: Get.width,
            color: Color(AppColor.reviewContainer),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  height: Get.height * 0.09,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(color: Color(AppColor.maincategorySelectedTextColor), spreadRadius: -3, offset: Offset(-2, 2), blurRadius: 5)],
                  ),
                  child: Image.asset(
                    AssestPath.profile + "Contact.png",
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Text(
                  'contact'.tr,
                  style: TextStyle(fontFamily: AppFont.bold, fontSize: Get.height * 0.02),
                ),
                SizedBox(height: 3),
                Text(
                  _profileController.userDataObj.value.phoneNumber == null ? "" : _profileController.userDataObj.value.phoneNumber,
                  style: TextStyle(color: Colors.black54, fontFamily: AppFont.medium, fontSize: Get.height * 0.02),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profileBottom() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.toNamed('/bookingView');
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 2), borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Image.asset(
                      AssestPath.profile + "My Booking.png",
                      height: 24,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'bookingbtn'.tr,
                      style: TextStyle(fontFamily: AppFont.medium, fontSize: 20),
                    ),
                    Spacer(),
                    Image.asset(
                      AssestPath.profile + "Right.png",
                      height: 15,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
