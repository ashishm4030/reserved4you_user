import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class IntroductionView extends StatelessWidget {
  PageController pagecontroll =
      new PageController(viewportFraction: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColor.scaffoldbgcolor),
      body: Container(
        // padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          children: [
            pageViewContianer(),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                children: [
                  bottomPager(),
                  Spacer(),
                  bottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        pageViewContianer(),
        Positioned(
          child: Container(
            // height: 100,
            child: Row(
              children: [
                bottomPager(),
                Spacer(),
                bottomButton(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget pageViewContianer() {
    return Container(
      height: Get.height * 0.80,
      child: PageView(
        controller: pagecontroll,
        children: [
          pageView('introduction1Title'.tr, 'introduction1Description'.tr,
              "assets/images/Intro/Onboarding1.svg"),
          pageView('introduction2Title'.tr, 'introduction2Description'.tr,
              "assets/images/Intro/Onboarding2.svg"),
          pageView(
            'introduction3Title'.tr,
            'introduction3Description'.tr,
            "assets/images/Intro/Onboarding3.png",
          ),
        ],
      ),
    );
  }

  Widget pageView(String text, String text2, String imgurl) {
    return Container(
      width: Get.width,
      //  padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: text == "Book Service At\nAny Time & Date"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              text == 'introduction3Title'.tr
                  ? Image.asset(
                      imgurl,
                      height: Get.height / 2,
                      fit: BoxFit.fitWidth,
                    )
                  : Container(
                      child: SvgPicture.asset(
                        imgurl,
                        fit: BoxFit.fitWidth,
                        //  width: Get.width,
                        height: Get.height / 2,
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              text,
              style: TextStyle(fontSize: 25, fontFamily: AppFont.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              text2,
              style: TextStyle(
                  color: Color(0xffa3a7ac),
                  fontSize: 16,
                  fontFamily: AppFont.regular),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomPager() {
    return Container(
      child: SmoothPageIndicator(
        controller: pagecontroll,
        count: 3,
        effect: ExpandingDotsEffect(
          dotHeight: 6,
          dotWidth: 10,
          activeDotColor: Colors.amber[700],
        ),
      ),
    );
  }

  Widget bottomButton() {
    return Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: InkWell(
        onTap: () {
          if (pagecontroll.page == 2) {
            Preferences.preferences.saveBool(
                key: PrefernceKey.isIntroductionScreenLoaded, value: true);
            Get.offNamed('/selectMainCategory');

            // Login page
          } else {
            //updateLocal();
            pagecontroll.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'nextbtn'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: AppFont.regular,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
