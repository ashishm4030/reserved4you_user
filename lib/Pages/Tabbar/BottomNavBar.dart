import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardView.dart';
import 'package:reserve_for_you_user/Pages/Favourite/favouriteView.dart';
import 'package:reserve_for_you_user/Pages/Notification/notification_view.dart';
import 'package:reserve_for_you_user/Pages/Profile/Profile_view.dart';
import 'package:reserve_for_you_user/Pages/Tabbar/bottombar_controller.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  int pageIndex;

  BottomNavBar({this.pageIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var currentIndex = 0;

  selectedIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    if (widget.pageIndex != null) {
      currentIndex = widget.pageIndex;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
    return Scaffold(
      backgroundColor: Color(AppColor.scaffoldbgcolor),
      bottomNavigationBar: bottomnavbar(context),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ColorfulSafeArea(
          color: Color(AppColor.logoBgColor),
          child: Stack(
            children: [if (currentIndex == 0) DashBoardView() else if (currentIndex == 1) FavouriteView() else if (currentIndex == 2) NotificationView() else ProfileView()],
          ),
        ),
      ),
    );
  }

  Container bottomnavbar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: Get.width,
      height: 80,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(50),
                    ),
                    color: Color(0xFFf5f7f8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    iconButton(
                      iconImg: "Home2.png",
                      iconName: 'home'.tr,
                      currentInd: 0,
                      selectedind: 0,
                    ),
                    iconButton(
                      iconImg: "Fav.png",
                      iconName: 'favourite'.tr,
                      currentInd: 1,
                      selectedind: 1,
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(15),
                    ),
                    color: Color(0xFFf5f7f8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        iconButton(
                          iconImg: "Notification.png",
                          iconName: 'notification'.tr,
                          currentInd: 2,
                          selectedind: 2,
                        ),
                        Obx(() => Visibility(
                              visible: bottomBarController.notificationBadge.isTrue,
                              child: Positioned(
                                right: 10,
                                top: 20,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    iconButton(
                      iconImg: "User.png",
                      iconName: 'profile'.tr,
                      currentInd: 3,
                      selectedind: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            heightFactor: 0.5,
            child: Container(
              height: 65,
              width: 65,
              child: FloatingActionButton(
                  backgroundColor: Color(0xFFffffff),
                  child: Center(
                    child: Image.asset(
                      AssestPath.bottomnavbar + "LOGO.png",
                      height: 40,
                    ),
                  ),
                  elevation: 1,
                  onPressed: () {
                    Get.offAllNamed('/selectMainCategory');
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconButton({page, currentInd, selectedind, String iconImg, String iconName}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 35,
          child: IconButton(
            icon: Image.asset(
              AssestPath.bottomnavbar + "$iconImg",
              color: currentIndex == currentInd ? Color(0xFFdb8a8a) : Color(0xFF7f848d),
              height: 25,
            ),
            onPressed: () {
              selectedIndex(selectedind);
            },
          ),
        ),
        Text(
          "$iconName",
          style: TextStyle(
            fontSize: 10,
            color: currentIndex == currentInd ? Colors.black : Color(0xFF7f848d),
          ),
        ),
      ],
    );
  }
}
