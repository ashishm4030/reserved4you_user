import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardController.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';

// ignore: must_be_immutable
class FilterForReview extends StatelessWidget {
  // ignore: unused_field
  DashBoardController _dashBoardController = Get.find();
  StoreDetailController _filterReviewController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Scaffold(
        bottomSheet: bottomNavBar(),
        backgroundColor: Color(AppColor.bgColor),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(),
                  SizedBox(height: 25),
                  filterstarReview(),
                  //SizedBox(height: 25),
                  Obx(
                    () => botomContainer(),
                  )
                ],
              ),
              Obx(() => CommanWidget(context: context).showlolder(
                  isshowDilog: _filterReviewController.isLoader.value))
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Header() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 65,
            width: Get.width,
            decoration: BoxDecoration(
              color: Color(AppColor.maincategorySelectedColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 38,
                    width: 38,
                    child: Center(
                        child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    )),
                    decoration: BoxDecoration(
                      color: Color(0xFFffffff),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(-1, 2),
                            spreadRadius: -10)
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Text(
                  'filter'.tr,
                  style: TextStyle(
                      color: Color(AppColor.maincategorySelectedTextColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      fontFamily: AppFont.regular),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      _filterReviewController.clearFilter();
                    },
                    child: Container(
                      height: 30,
                      width: 65,
                      decoration: BoxDecoration(
                          color: Color(0xFFfef6f1),
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'clear'.tr,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget filterstarReview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'byRating'.tr,
            style: TextStyle(fontSize: 20, fontFamily: AppFont.bold),
          ),
          SizedBox(height: 12),
          Obx(() => RatingBar.builder(
                initialRating: double.parse(
                    _filterReviewController.ratingForFilterReview.value),
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                glowColor: Colors.white,
                itemSize: 45,
                unratedColor: Color(0xFFdadbde),
                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, index) {
                  return Container(
                    height: 45,
                    width: 45,
                    child: Image.asset(
                      AssestPath.homeView + "Star.png",
                      height: 18,
                      width: 18,
                    ),
                  );
                },
                onRatingUpdate: (value) {
                  _filterReviewController.ratingForFilterReview.value =
                      value.toString();
                },
              )),
          SizedBox(height: 22),
          Text(
            'byServices'.tr,
            style: TextStyle(fontSize: 20, fontFamily: AppFont.bold),
          ),
          SizedBox(height: 12),
          Container(
            height: Get.height / 6.89,
            color: Color(AppColor.scaffoldbgcolor),
            child: Center(
              child: Obx(() => viewCategory()),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget viewCategory() {
    return Container(
      width: Get.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // ignore: invalid_use_of_protected_member
        itemCount: _filterReviewController.arrCategory.value.length,
        itemBuilder: (context, ind) {
          var currentObj = _filterReviewController.arrCategory[ind];

          return InkWell(
              onTap: () {
                _filterReviewController.selectedfilterForReview.value =
                    currentObj.categoryId;
                _filterReviewController.getCategoryWiseSubCategoryReview();
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 12, top: 0),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: _filterReviewController
                                    .selectedfilterForReview.value ==
                                currentObj.categoryId
                            ? Color(0xFFdb8a8a)
                            : Color(AppColor.logoBgColor),
                      ),
                      child: SvgPicture.network(
                        currentObj.categoryImagePath,
                        color: _filterReviewController
                                    .selectedfilterForReview.value ==
                                currentObj.categoryId
                            ? Colors.white
                            : Color(0xFF242c39),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        currentObj.categoryName,
                        style: TextStyle(
                            fontFamily: AppFont.medium,
                            color: _filterReviewController
                                        .selectedfilterForReview.value ==
                                    currentObj.categoryId
                                ? Color(0xFFdb8a8a)
                                : Color(0xFF878c93),
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget botomContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        height: Get.height / 3,
        decoration: BoxDecoration(
            color: Color(0xfff9f9fb), borderRadius: BorderRadius.circular(15)),
        child: ListView.builder(
            itemCount:
                _filterReviewController.arrCategoryWiseSubCategoryReview.length,
            itemBuilder: (context, ind) {
              var currentObj =
                  _filterReviewController.arrCategoryWiseSubCategoryReview[ind];
              return InkWell(
                onTap: () {},
                child: Obx(() => buildTextFieldContainer(
                    categoriesname: currentObj.name,
                    id: currentObj.id.toString())),
              );
            }),
      ),
    );
  }

  Column buildTextFieldContainer({String categoriesname, String id}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _filterReviewController.selectedSubCategoryForReviewInd.value = id;
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _filterReviewController
                          .selectedSubCategoryForReviewInd.value ==
                      id
                  ? Color(0xff101928)
                  : Color(0xfff9f9fb),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: Get.width - 100,
                  child: Text(
                    "$categoriesname",
                    style: TextStyle(
                        color: _filterReviewController
                                    .selectedSubCategoryForReviewInd.value ==
                                id
                            ? Colors.white
                            : Color(0xff373e4b),
                        fontFamily: AppFont.semiBold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomNavBar() {
    return InkWell(
      onTap: () {
        if (_filterReviewController.ratingForFilterReview.value == "0.0" &&
            _filterReviewController.selectedfilterForReview.value == 0) {
          _filterReviewController.getReviewData(sorTing: "", searchText: "");
          Get.back();
        } else {
          _filterReviewController.filterByReviewData();
        }
      },
      child: Container(
        height: 80,
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Color(0xFFdb8a8a)),
        child: Center(
          child: Text('applyFilter'.tr,
              style: TextStyle(
                  fontFamily: AppFont.semiBold,
                  fontSize: 15,
                  color: Color(AppColor.scaffoldbgcolor))),
        ),
      ),
    );
  }
}
