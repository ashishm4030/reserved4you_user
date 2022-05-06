import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Portfolio/Portfolio.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/reviews.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'About/AboutView.dart';
import 'ServiceView/ServicesView.dart';

// ignore: must_be_immutable
class StoreDetailsView extends StatefulWidget {
  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  StoreDetailController _storeDetailController = Get.put(StoreDetailController());

  PageController pagecontroll = new PageController(viewportFraction: 1, keepPage: true);

  var string = ':';

  @override
  void initState() {
    super.initState();
    _storeDetailController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    _storeDetailController.context = context;

    return Scaffold(
      bottomNavigationBar: Obx(
        () => _storeDetailController.selectedtabIndex.value == 0
            ? bottomNavBar()
            : Container(
                height: 1,
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _storeDetailController.scrollController,
          scrollDirection: Axis.vertical,
          child: Obx(() {
            return Stack(
              children: [
                if (_storeDetailController.isLoader.value == true)
                  noDataFound(context)
                else
                  Column(
                    children: [
                      topDetail(context),
                      middleDetail(),
                      bottomDetail(),
                      tabView(),
                      // ignore: unrelated_type_equality_checks
                      if (_storeDetailController.selectedtabIndex == 0)
                        SevicesView()
                      // ignore: unrelated_type_equality_checks
                      else if (_storeDetailController.selectedtabIndex == 1)
                        AboutViewPage()
                      // ignore: unrelated_type_equality_checks
                      else if (_storeDetailController.selectedtabIndex == 2)
                        PortFolioView()
                      else
                        Review(),
                    ],
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget topDetail(BuildContext context) {
    return Container(
      height: 310,
      width: Get.width,
      color: Color(AppColor.backColour),
      child: Stack(
        children: [
          _storeDetailController.storeDetailsObj.value.storeGallery.length > 0 ? multipleImageContainer() : gridViewContainer(""),
          if (_storeDetailController.storeDetailsObj.value.storeGallery.length > 1)
            Container(
              padding: EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              margin: EdgeInsets.only(top: 130),
              child: backAndForwardIndicators(),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 37, 15, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), color: Color(AppColor.scaffoldbgcolor)),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                    ),
                  ),
                ),
                Obx(
                  () => InkWell(
                    onTap: () {
                      _storeDetailController.checkIfLoginOrNot();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          _storeDetailController.storeDetailsObj.value.favourite.value ? AssestPath.favourite + 'Favourite.png' : AssestPath.favourite + 'unFavourite.png',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 160),
                alignment: Alignment.bottomCenter,
                height: 120,
                width: 120,
                child: CachedNetworkImage(
                  imageUrl: _storeDetailController.storeDetailsObj.value.storeProfileImagePath,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0.1),
                          spreadRadius: 5,
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/store_default.png",
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0.1),
                          spreadRadius: 5,
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/store_default.png",
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0.1),
                          spreadRadius: 5,
                        )
                      ],
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget middleDetail() {
    return Container(
      //height: 170,
      width: Get.width,
      color: Color(AppColor.backColour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              _storeDetailController.storeDetailsObj.value.storeName,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 26, fontFamily: AppFont.medium),
            ),
          ),
          SizedBox(height: 5),
          InkWell(
            onTap: _storeDetailController.openGoogleMap,
            child: Text(
              _storeDetailController.storeDetailsObj.value.storeAddress,
              style: TextStyle(fontFamily: AppFont.regular, fontSize: 15),
            ),
          ),
          SizedBox(height: 16),
          /*Ratting bar*/ Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 26,
                width: 55,
                decoration: BoxDecoration(color: Color(AppColor.fouthColour), borderRadius: BorderRadius.circular(5)),
                child: Stack(
                  children: [
                    Positioned(
                      top: 2,
                      left: 2,
                      child: Container(
                        height: 22,
                        width: 20,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: Icon(
                          Icons.star,
                          size: 18,
                          color: Color(AppColor.fouthColour),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 8, 0, 0),
                      child: Text(
                        _storeDetailController.storeDetailsObj.value.avgRating,
                        style: TextStyle(fontSize: 11, color: Color(AppColor.secondColour), fontFamily: AppFont.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 5),
              Text(
                "(${_storeDetailController.storeDetailsObj.value.totalFeedback})" +
                    "${_storeDetailController.storeDetailsObj.value.totalFeedback == 1 ? 'rating'.tr : 'reviewes'.tr}",
                style: TextStyle(fontSize: 13, fontFamily: AppFont.regular, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 15),
          /*Opening time*/ Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 38,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(AppColor.profileColour), width: 0.8), color: Color(AppColor.thirdColour), borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                        _storeDetailController.currentWeekDayObj.isOff == "on"
                            ? "${_storeDetailController.weekday.tr + " " + " (" + 'closedDay'.tr + ")"}"
                            : "${_storeDetailController.weekday.tr + " " + _storeDetailController.currentTimeStlot}",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: AppFont.medium,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  Get.toNamed("/showDetails");
                },
                child: Container(
                  height: 30,
                  width: 90,
                  decoration: BoxDecoration(
                      //  border: Border.all(color: Colors.black, width: 0.5),
                      color: (_storeDetailController.currentWeekDayObj.endTime != null && _storeDetailController.currentWeekDayObj.startTime != null)
                          ? TimeOfDay(
                                              hour: int.parse(_storeDetailController.currentWeekDayObj.endTime.split(":")[0]),
                                              minute: int.parse(_storeDetailController.currentWeekDayObj.endTime.split(":")[1]))
                                          .compareTo(TimeOfDay.now()) ==
                                      1 &&
                                  TimeOfDay(
                                              hour: int.parse(_storeDetailController.currentWeekDayObj.startTime.split(":")[0]),
                                              minute: int.parse(_storeDetailController.currentWeekDayObj.startTime.split(":")[1]))
                                          .compareTo(TimeOfDay.now()) ==
                                      -1
                              ? Colors.green[800]
                              : Colors.red[800]
                          : Colors.red[800], // close
                      borderRadius: BorderRadius.circular(26)),
                  child: InkWell(
                    onTap: () {
                      for (var i in _storeDetailController.storeDetailsObj.value.about.openingHours) {
                        print(i.day);
                      }
                      print(_storeDetailController.weekday);
                    },
                    child: Center(
                        child: Text(
                      (_storeDetailController.currentWeekDayObj.endTime != null && _storeDetailController.currentWeekDayObj.startTime != null)
                          ? TimeOfDay(
                                              hour: int.parse(_storeDetailController.currentWeekDayObj.endTime.split(":")[0]),
                                              minute: int.parse(_storeDetailController.currentWeekDayObj.endTime.split(":")[1]))
                                          .compareTo(TimeOfDay.now()) ==
                                      1 &&
                                  TimeOfDay(
                                              hour: int.parse(_storeDetailController.currentWeekDayObj.startTime.split(":")[0]),
                                              minute: int.parse(_storeDetailController.currentWeekDayObj.startTime.split(":")[1]))
                                          .compareTo(TimeOfDay.now()) ==
                                      -1
                              ? 'open'.tr
                              : 'close'.tr
                          : 'close'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: AppFont.bold),
                    )),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget bottomDetail() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      width: Get.width,
      color: Color(AppColor.secondColour),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /*Services*/ Container(
            width: 180,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Color(AppColor.firstColour), spreadRadius: -3, offset: Offset(-2, 2), blurRadius: 5)],
                    color: Colors.white,
                  ),
                  child: Image.asset(AssestPath.detailScreen + "Services.png"),
                ),
                SizedBox(height: 10),
                Text(
                  'services'.tr,
                  style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  // height: 100,
                  child: Text(
                    _storeDetailController.storeDetailsObj.value.categoryName,
                    style: TextStyle(
                      fontFamily: AppFont.regular,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 100,
            width: 1.5,
            color: Color(AppColor.firstColour).withOpacity(0.5),
          ),
          /*Contacts*/ Container(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Color(AppColor.firstColour), spreadRadius: -3, offset: Offset(-2, 2), blurRadius: 5)],
                    color: Colors.white,
                  ),
                  child: Image.asset(AssestPath.detailScreen + "Contact.png"),
                ),
                SizedBox(height: 8),
                Text(
                  'contacts'.tr,
                  style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
                ),
                SizedBox(height: 7),
                InkWell(
                  onTap: () {
                    launch("tel://${_storeDetailController.storeDetailsObj.value.about.phoneNumber}");
                  },
                  child: Container(
                    height: 35,
                    width: 99,
                    decoration: BoxDecoration(color: Color(0xFFdb8a8a), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          'callNow'.tr,
                          style: TextStyle(color: Colors.white, fontFamily: AppFont.medium),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabView() {
    return DefaultTabController(
      length: 4,
      initialIndex: _storeDetailController.selectedtabIndex.value,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: TabBar(
          onTap: (tabInd) {
            _storeDetailController.selectedtabIndex.value = tabInd;
          },
          indicatorColor: Color(AppColor.firstColour),
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          labelPadding: EdgeInsets.all(2),
          indicatorPadding: EdgeInsets.only(left: 8, right: 8),
          labelStyle: TextStyle(
            fontFamily: AppFont.semiBold,
            fontSize: 13,
          ),
          tabs: [
            Tab(
              text: 'servicesText'.tr,
            ),
            Tab(
              text: 'about'.tr,
            ),
            Tab(
              text: 'portFolio'.tr,
            ),
            Tab(
              text: 'reviewes'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget noDataFound(BuildContext context) {
    return Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _storeDetailController.isLoader.value));
  }

  Widget bottomNavBar() {
    return Container(
      height: 120,
      child: Column(
        children: [
          Obx(
            () => totalPriceAndServicesCount(),
          ),
          InkWell(
            onTap: () {
              if (_storeDetailController.totalSelectetServicePrice.value == 0) {
                showTostMessage(message: 'pleaseSelectProceed'.tr);
              } else {
                Get.toNamed('/proceedToPayView', arguments: _storeDetailController.selectedStoreId);
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              }
            },
            child: Container(
                height: 80,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Color(0xFFdb8a8a)),
                child: Center(
                  child: Text('proccedTopay'.tr, style: TextStyle(color: Color(AppColor.scaffoldbgcolor), fontSize: 18, fontFamily: AppFont.semiBold)),
                )),
          ),
        ],
      ),
    );
  }

  Widget totalPriceAndServicesCount() {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(AppColor.logoBgColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Center(
              child: Text(
                '${_storeDetailController.totalSelectetServicePrice.value.toStringAsFixed(2)} ' + appStaticPriceSymbol,
                style: TextStyle(fontFamily: AppFont.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          Container(
            width: 100,
            child: Center(
              child: Text("${_storeDetailController.totalSelectedServicesCount.value} " + 'servicesText'.tr,
                  style: TextStyle(
                    fontFamily: AppFont.bold,
                    color: Colors.grey,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget multipleImageContainer() {
    return Container(
      height: 230,
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pagecontroll,
          itemCount: _storeDetailController.storeDetailsObj.value.storeGallery.length,
          itemBuilder: (context, ind) {
            return gridViewContainer(_storeDetailController.storeDetailsObj.value.storeGallery[ind].storeGalleryImagePath);
          }),
    );
  }

  Widget gridViewContainer(String img) {
    // GridView Container
    return Container(
      height: 200,
      width: Get.width,
      child: CachedNetworkImage(
        imageUrl: img,
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/store_default.png",
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(13), bottomLeft: Radius.circular(13)),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/store_default.png",
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(13), bottomLeft: Radius.circular(13)),
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(13), bottomLeft: Radius.circular(13)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomPager() {
    return Container(
      height: 20,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: SmoothPageIndicator(
          controller: pagecontroll,
          count: _storeDetailController.storeDetailsObj.value.storeGallery.length,
          effect: ScrollingDotsEffect(
            activeStrokeWidth: 1.3,
            activeDotScale: 1.6,
            dotHeight: 8,
            dotWidth: 8,
            fixedCenter: true,
            dotColor: Color(0xFFcfccc9),
            activeDotColor: Colors.white,
            spacing: 8,
          )),
    );
  }

  Row backAndForwardIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (pagecontroll.page != 0) {
              pagecontroll.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black45),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        if (_storeDetailController.storeDetailsObj.value.storeGallery.length > 0) bottomPager(),
        GestureDetector(
          onTap: () {
            if (pagecontroll.page != _storeDetailController.storeDetailsObj.value.storeGallery.length - 1) {
              pagecontroll.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black45),
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  backpressFromDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              'areYouWantToRemove'.tr,
              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: AppFont.regular, fontWeight: FontWeight.normal),
            ),
            actions: <Widget>[
              InkWell(
                  child: Text(
                    'yes'.tr,
                    style: TextStyle(
                      color: Color(AppColor.firstColour),
                      fontSize: 18,
                      fontFamily: AppFont.medium,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    _storeDetailController.clearParticularStoreSelection();
                  }),
              InkWell(
                  child: Text(
                    'no'.tr,
                    style: TextStyle(
                      color: Color(AppColor.firstColour),
                      fontSize: 18,
                      fontFamily: AppFont.medium,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  }),
            ]);
      },
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (this.hour < other.hour) return -1;
    if (this.hour > other.hour) return 1;
    if (this.minute < other.minute) return -1;
    if (this.minute > other.minute) return 1;
    return 0;
  }
}
