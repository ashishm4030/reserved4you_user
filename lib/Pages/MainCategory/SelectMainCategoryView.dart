import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';

class SelectMainCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: Column(children: [
            header(context),
            Expanded(
              child: listView(),
            )
          ]),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AssestPath.login + "Logo_Home.png",
            height: 20,
            width: 90,
          ),
          SizedBox(height: 15),
          Text(
            'titleOfSelectMainCategory'.tr,
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppFont.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget listView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: rightSideImageContainer(imgurl: AssestPath.category + "CommingSoon1.png", text: 'commingSoon!!'.tr),
            ),
            InkWell(
              onTap: () {
                Preferences.preferences.saveString(key: PrefernceKey.mainSelectedCategory, value: MainCategories.cosmetics);
                Get.offAllNamed("/bottomNavBar");
              },
              child: Container(
                child: leftSideImageContainer(
                  imgurl: AssestPath.category + "CommingSoon2.png",
                  text: 'selectedCategory'.tr,
                  textColor: Color(AppColor.maincategorySelectedTextColor),
                  bgColor: Color(AppColor.maincategorySelectedColor),
                  borderColor: Color(AppColor.maincategorySelectedBorderColor),
                  blur: false,
                ),
              ),
            ),
            Container(
              child: rightSideImageContainer(imgurl: AssestPath.category + "CommingSoon3.png", text: 'commingSoon!!'.tr),
            ),
            Container(
              child: leftSideImageContainer(
                imgurl: AssestPath.category + "CommingSoon4.png",
                text: 'commingSoon!!'.tr,
                textColor: Color(AppColor.maincategoryDisableTextColor),
                bgColor: Color(AppColor.maincategoryDisableColor),
                borderColor: Color(AppColor.maincategoryDisableBorderColor),
                blur: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSideImageContainer({String imgurl, String text}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        height: Get.height * 0.17,
        decoration: BoxDecoration(
          color: Color(AppColor.maincategoryDisableColor),
          borderRadius: BorderRadius.all(Radius.circular(25.0) //                 <--- border radius here
              ),
          border: Border.all(
            width: 1.5,
            color: Color(AppColor.maincategoryDisableBorderColor),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFont.bold,
                fontSize: 22,
                color: Color(AppColor.maincategoryDisableTextColor),
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              child: ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Image.asset(
                    imgurl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftSideImageContainer({
    String imgurl,
    String text,
    Color textColor,
    Color bgColor,
    Color borderColor,
    bool blur,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        height: Get.height * 0.18,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0) //                 <--- border radius here
              ),
          border: Border.all(
            width: 1.5,
            color: borderColor,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              child: ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur ? 6 : 0, sigmaY: blur ? 6 : 0),
                  child: Image.asset(
                    imgurl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              text,
              style: TextStyle(fontFamily: AppFont.bold, color: textColor, fontSize: 22),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
