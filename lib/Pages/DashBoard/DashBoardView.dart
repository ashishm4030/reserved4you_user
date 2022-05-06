import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/Favourite/FavouriteCell.dart';
import 'DashBoardController.dart';
import 'DropDownSearch.dart';
import 'Widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DashBoardView extends StatefulWidget {
  @override
  _DashBoardViewState createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  // var itemSize = Get.height;
  moveUp() {
    _dashBoardController.scrollController.animateTo(0, curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  DashBoardController _dashBoardController = Get.put(DashBoardController());

  @override
  void initState() {
    super.initState();
    _dashBoardController.onInit();
  }

  var arrSort = [
    SortinOptions.aToz,
    SortinOptions.zToa,
    // SortinOptions.nearest,
    // SortinOptions.lowestPrice,
    // SortinOptions.highestPrice,
    // SortinOptions.bestRated
  ];

  var documentDirectory;
  _asyncMethod({url}) async {
    var response = await get(Uri.parse(url)); // <--2
    print('responseeeeee');
    print(response);
    if (Platform.isIOS) {
      print('ifs');
      documentDirectory = await getApplicationDocumentsDirectory();
    } else {
      print('else');
    }
    print('documentDirectory');
    print(documentDirectory);
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    setState(() {
      imageData = filePathAndName;
    });
  }

  String imageData;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
    );
    return GestureDetector(
      onTap: () {
        _dashBoardController.fabIconNumber.value = false;
      },
      child: Obx(
        () => Container(
          height: Get.height - 50,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                // ignore: missing_return
                onNotification: (scroll) {
                  if (scroll.metrics.pixels != 0.0) {
                    _dashBoardController.isScroll.value = true;
                  } else if (scroll.metrics.pixels == 10.0) {
                    _dashBoardController.isScroll.value = false;
                  } else {
                    _dashBoardController.isScroll.value = false;
                  }
                },
                child: SmartRefresher(
                  controller: _dashBoardController.refreshController,
                  enablePullDown: true,
                  header: ClassicHeader(
                    completeText: 'refreshCompleted'.tr,
                    releaseText: 'releaseToRefresh'.tr,
                    idleText: 'pullDownRefresh'.tr,
                  ),
                  onRefresh: () {
                    _dashBoardController.clearAllDataAndPullToRefresh();
                  },
                  child: ListView(
                    // itemExtent: itemSize,
                    controller: _dashBoardController.scrollController,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                /*Header part */ Container(
                                  height: 240,
                                  color: Color(AppColor.logoBgColor),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      header(context),
                                      SizedBox(height: 10),
                                      Obx(() => viewCategory()),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Obx(
                                  () => Column(
                                    children: [
                                      newRecomandedBestratedTabs(),
                                      Visibility(
                                        visible: !(_dashBoardController.arrRecommandedBestRated.isEmpty),
                                        child: Container(
                                          color: Color(0xFFf4f4f6).withOpacity(0.6),
                                          child: Column(
                                            children: [
                                              Obx(
                                                () => newRecomandedBestratedDataCell(),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                bottomPart(context),
                              ],
                            ),
                          ),
                          DropDownSearch(),
                          Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _dashBoardController.isLoader.value)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(margin: EdgeInsets.only(bottom: 10, left: 8), child: bottomFloatingOptions()),
              ),
              Obx(
                () => Visibility(
                  visible: _dashBoardController.isScroll.value,
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 20, right: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              moveUp();
                            },
                            child: Icon(
                              Icons.keyboard_arrow_up_outlined,
                              color: Colors.transparent.withOpacity(0.7),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AssestPath.favourite + 'Logo_Home.png',
                height: 20,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, bottom: 10),
          child: Obx(
            () => Text(
              "${_dashBoardController.title.value}" + "\n" + 'WhatYouWantToDo'.tr,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontFamily: AppFont.semiBold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget viewCategory() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dashBoardController.arrCategory.length,
        itemBuilder: (context, ind) {
          var currentObj = _dashBoardController.arrCategory[ind];
          return InkWell(
            onTap: () {
              var currentObj = _dashBoardController.arrCategory[ind];

              if (_dashBoardController.selectedIndex.value == ind.toString()) {
                _dashBoardController.selectedCategoryName.value = 'all'.tr;
                _dashBoardController.selectedCategoryId.value = "";
                _dashBoardController.fabIconNumber.value = false;
                _dashBoardController.selectedIndex.value = "";
                _dashBoardController.arrCategoryWiseSubCategory.clear();
                _dashBoardController.arrCategoryWiseSubCategoryString.clear();
                _dashBoardController.resetAdvanceSerach();
              } else {
                _dashBoardController.fabIconNumber.value = true;
                _dashBoardController.selectedCategoryName.value = currentObj.name;
                _dashBoardController.selectedCategoryId.value = currentObj.id.toString();

                _dashBoardController.selectedIndex.value = ind.toString();
                _dashBoardController.getCategoryWiseSubCategory();
              }

              callAllDataAPIForFilters();
            },
            child: Obx(() => HomeUnits().categoryShell(
                imgurl: currentObj.categoryImagePath, categoryName: currentObj.name, isSelected: ind.toString() == _dashBoardController.selectedIndex.value ? true : false)),
          );
        },
      ),
    );
  }

  Widget newRecomandedBestratedTabs() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        color: Colors.white,
        child: DefaultTabController(
          length: 3,
          initialIndex: _dashBoardController.selectedOptionsInd.value,
          child: TabBar(
            onTap: (ind) {
              _dashBoardController.selectedOptionsInd.value = ind;
              if (ind == 0) {
                _dashBoardController.selectedOptions = "new";
              }

              if (ind == 1) {
                _dashBoardController.selectedOptions = "recommended";
              }

              if (ind == 2) {
                _dashBoardController.selectedOptions = "best_rating";
              }
              _dashBoardController.getAllDataForNewRecomandedTabs();
            },
            indicatorColor: Color(0xFFdb8a8a),
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xFF87878b),
            labelPadding: EdgeInsets.all(2),
            indicatorPadding: EdgeInsets.only(left: 8, right: 8),
            labelStyle: TextStyle(
              fontSize: 14,
              fontFamily: AppFont.semiBold,
            ),
            tabs: [
              Tab(
                text: 'new'.tr,
              ),
              Tab(
                text: 'recommanded'.tr,
              ),
              Tab(
                text: 'bestRated'.tr,
              ),
            ],
          ),
        ));
  }

  Widget bottomPart(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => sortOptionAndswitchContainer(context),
        ),

        Obx(
          () => _dashBoardController.arrStoreList.length == 0 ? noDataFound() : bottomStoreList(),
        ),

        SizedBox(
          height: 30,
        )
        //FavouriteCell(),
      ],
    );
  }

  Widget bottomStoreList() {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _dashBoardController.arrStoreList == null ? 0 : _dashBoardController.arrStoreList.length,
          itemBuilder: (context, ind) {
            var currentObj = _dashBoardController.arrStoreList[ind];
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Obx(
                () => FavouriteCell(
                  urlimg: currentObj.storeBannerImagePath,
                  discount: currentObj.discountFlage,
                  isfavourite: currentObj.favourite.value,
                  avgrating: currentObj.avgRating,
                  totalfeedback: currentObj.totalFeedback,
                  isvalue: currentObj.isValue,
                  storename: currentObj.storeName,
                  categoryid: currentObj.categoryName,
                  storeaddress: currentObj.storeAddress,
                  storecategory: currentObj.storeCategory,
                  storeId: currentObj.id.toString(),
                  controller: _dashBoardController,
                  isFromFav: false,
                  discountValue: currentObj.discount,
                  currentInd: ind,
                  storeGallery: currentObj.storeGallery,
                ),
              ),
            );
          }),
    );
  }

  Widget newRecomandedBestratedDataCell() {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 20),
      child: Container(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _dashBoardController.arrRecommandedBestRated == null ? 0 : _dashBoardController.arrRecommandedBestRated.length,
          itemBuilder: (context, ind) {
            var currentobj = _dashBoardController.arrRecommandedBestRated[ind];
            var imageUrl = currentobj.storeProfileImagePath.split('/').last;
            print(currentobj.storeProfileImagePath);
            return InkWell(
              onTap: () {
                Get.toNamed("/storeDetailsView", arguments: currentobj.id.toString());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: Container(
                  // main container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: (Get.width / 3) - 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 130,
                            child: CachedNetworkImage(
                              imageUrl: currentobj.storeProfileImagePath,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/store_default.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/store_default.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                ),
                              ),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFfaba5f),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Image.asset(
                                        AssestPath.homeView + "Star.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "${currentobj.avgRating}",
                                    style: TextStyle(fontFamily: AppFont.medium, color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentobj.storeName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: AppFont.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sortOptionAndswitchContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_dashBoardController.selectedCategoryName} " + 'services'.tr,
                        style: TextStyle(
                          fontFamily: AppFont.bold,
                          fontSize: 20,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${_dashBoardController.arrStoreList.length}",
                            style: TextStyle(
                              color: Color(0xFF5a616b),
                              fontFamily: AppFont.semiBold,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: _dashBoardController.arrStoreList.length > 1 ? 'results'.tr : 'result'.tr,
                            style: TextStyle(
                              color: Color(0xFFbec0c4),
                              fontFamily: AppFont.semiBold,
                              fontSize: 12,
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                /*Soritn options*/ Container(
                    height: 30,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0) //                 <--- border radius here
                          ),
                      border: Border.all(
                        width: 1.5,
                        color: Color(0xFFe2e3e6),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        showBottomSheetForSortingOptions(context);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 3,
                          ),
                          Obx(
                            () => Text(
                              _dashBoardController.sortByText.value,
                              style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: 10,
                              width: 15,
                              child: Image.asset(
                                AssestPath.homeView + "Sort.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 45,
                  width: Get.width,
                  color: Color(0xFFfef4ee),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                              value: _dashBoardController.isBookingSystem.value,
                              activeColor: Color(0xFFdb8a8a),
                              inactiveTrackColor: Color(0xFFcfcbca),
                              inactiveThumbColor: Color(0xFF878c93),
                              onChanged: (value) {
                                _dashBoardController.isBookingSystem.value = value;
                                _dashBoardController.isLoader.value = true;
                                _dashBoardController.getAllDataForDashboard();
                              },
                            ),
                            Text(
                              'bookingSystem'.tr,
                              style: TextStyle(fontSize: 10, fontFamily: AppFont.regular),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 2,
                        color: Color(0xFFe2dbd9),
                      ),
                      Container(
                        width: 150,
                        child: Row(
                          children: [
                            Switch(
                              value: _dashBoardController.isDiscount.value,
                              activeColor: Color(0xFFdb8a8a),
                              inactiveTrackColor: Color(0xFFcfcbca),
                              inactiveThumbColor: Color(0xFF878c93),
                              onChanged: (value) {
                                _dashBoardController.isDiscount.value = value;
                                _dashBoardController.isLoader.value = true;
                                if (_dashBoardController.isDiscount.value == false) {
                                  _dashBoardController.applyFilter();
                                } else {
                                  _dashBoardController.getAllDataForDashboard();
                                }
                              },
                            ),
                            Text(
                              'discounts'.tr,
                              style: TextStyle(fontSize: 10, fontFamily: AppFont.regular),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottomFloatingOptions() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Container(
        height: 40,
        width: Get.width * 0.30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Get.toNamed("/filter");
              },
              icon: Image.asset(
                AssestPath.homeView + "Filter.png",
                height: 12,
              ),
            ),
            Container(
              height: 20,
              width: 1,
              color: Color(0xFF626973),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed("/mapView");
              },
              icon: Image.asset(
                AssestPath.homeView + "map.png",
                height: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future showBottomSheetForSortingOptions(BuildContext context) {
    return Get.bottomSheet(
      Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                color: Color(0xFFfef4ee),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Text(
                  'sortBy'.tr,
                  style: TextStyle(fontFamily: AppFont.bold, fontSize: 15, color: Color(0xFFde9292)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: ListView.builder(
                      itemCount: arrSort.length,
                      itemBuilder: (context, ind) {
                        return InkWell(
                          onTap: () {
                            clickToBtnSort(ind);
                          },
                          child: Container(
                            height: 30,
                            child: Text(
                              arrSort[ind],
                              style: TextStyle(
                                fontFamily: AppFont.medium,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clickToBtnSort(int index) {
    var selectedtext = arrSort[index];
    if (selectedtext == SortinOptions.aToz) {
      _dashBoardController.sortByText.value = "A-Z";
    }

    if (selectedtext == SortinOptions.zToa) {
      _dashBoardController.sortByText.value = "Z-A";
    }

    _dashBoardController.getSortByDataForDashboard();
    Get.back();
  }

  void callAllDataAPIForFilters() {
    _dashBoardController.getAllDataForDashboard();
  }

  Widget noDataFound() {
    return Container();
  }
}
