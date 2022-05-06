import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/Filter/review_filter.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/ReviewModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/givenReview.dart';

// ignore: must_be_immutable
class Review extends StatefulWidget {
  // ignore: unused_field
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  StoreDetailController _detailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff9f9fb),
      child: Column(
        children: [
          Obx(() {
            if (_detailController.storeReviewObj.value != null && _detailController.storeReviewObj.value.totalAvgRating != null) {
              return ratingCard(context);
            } else {
              return SizedBox();
            }
          }),
          Obx(
            () {
              if (_detailController.storeReviewObj.value != null &&
                  _detailController.storeReviewObj.value.customerReview != null &&
                  _detailController.storeReviewObj.value.customerReview.length != 0) {
                return ListView.builder(
                  itemCount: _detailController.storeReviewObj.value.customerReview.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var currentObject = _detailController.storeReviewObj.value.customerReview[index];
                    return reviewCard(currentObject, index);
                  },
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  Card ratingCard(BuildContext context) {
    return Card(
      color: Color(0xffffffff),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: Get.width * 0.95,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(AppColor.logoBgColor)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 50),
                        alignment: Alignment.center,
                        width: Get.width,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFfaba5f),
                        ),
                        child: Obx(() => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_detailController.storeReviewObj.value.allOverAvg}/5.0",
                                  style: TextStyle(color: Color(AppColor.scaffoldbgcolor), fontFamily: AppFont.semiBold, fontSize: 35),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildRatingBar(Color(0xFFfaba5f), _detailController.storeReviewObj.value.allOverAvg),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "(${_detailController.storeDetailsObj.value.totalFeedback})" +
                                      "${_detailController.storeDetailsObj.value.totalFeedback == 1 ? 'rating'.tr : 'vanueReview'.tr}",
                                  style: TextStyle(fontFamily: AppFont.semiBold),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            )),
                      ),
                      ratingAndServices(rating: _detailController.storeReviewObj.value.totalAvgRating.first.serviceRate.toString() + "/5", serviceName: 'serviceStaff'.tr),
                      ratingAndServices(rating: _detailController.storeReviewObj.value.totalAvgRating[0].ambiente.toString() + "/5", serviceName: 'Ambiance'.tr),
                      ratingAndServices(rating: _detailController.storeReviewObj.value.totalAvgRating[0].preieLeistungsRate.toString() + "/5", serviceName: 'priceprefoma'.tr),
                      ratingAndServices(rating: _detailController.storeReviewObj.value.totalAvgRating[0].wartezeit.toString() + "/5", serviceName: 'waitingPeriod'.tr),
                      ratingAndServices(rating: _detailController.storeReviewObj.value.totalAvgRating[0].atmosphare.toString() + "/5", serviceName: 'atmosphere'.tr),
                      // ratingAndServices(rating: "4.5/5", serviceName: "Food"),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var isLogin = await Preferences.preferences.getBool(key: PrefernceKey.isUserLogin, defValue: false);

                    if (isLogin) {
                      var arr = [
                        _detailController.selectedStoreId,
                        _detailController.storeDetailsObj.value.storeName,
                        _detailController.storeDetailsObj.value.storeProfileImagePath,
                        true
                      ];
                      for (CustomerReview user in _detailController.storeReviewObj.value.customerReview) {
                        if (user.userId == _detailController.userDataObj.value.id) {
                          _detailController.reviewButtonText.value = 'giveFeedBack'.tr;
                          break;
                        }
                      }
                      if (_detailController.reviewButtonText.value == 'giveFeedBack'.tr) {
                        Get.toNamed('/giveFeedback', arguments: arr).then((value) {
                          _detailController.getReviewData();
                        });
                      } else {
                        Get.to(() => Givenreview());
                      }
                    } else {
                      Get.toNamed("/login", arguments: true);
                    }
                  },
                  child: Obx(() => Center(
                        child: Container(
                          height: Get.height / 17.92,
                          width: Get.width * 0.70,
                          margin: EdgeInsets.fromLTRB(0, 215, 0, 0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xff101928)),
                          child: Center(
                            child: Text(
                              _detailController.type.toString() == "customer_request"
                                  ? 'customerProfile'.tr
                                  : (_detailController.type.toString() == "review_request" ? "evaluationReq".tr : _detailController.reviewButtonText.value),
                              style: TextStyle(color: Colors.white, fontFamily: AppFont.regular, fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              rowline(context),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: findContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container findContainer() {
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 8),
        height: 50,
        width: Get.width - 20,
        decoration: BoxDecoration(color: Color(0xfff9f9fb), borderRadius: BorderRadius.circular(15)),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          autocorrect: false,
          controller: _detailController.revierTextEditing,
          onChanged: (value) {
            if (value.length > 2) {
              _detailController.getReviewData(searchText: value);
            } else if (value.isEmpty) {
              _detailController.getReviewData(searchText: value);
            }
          },
          decoration: InputDecoration(
              icon: Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Image.asset(
                  AssestPath.homeView + 'SearchWhite.png',
                  height: 20,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              labelText: 'findByEmployeeName'.tr,
              labelStyle: TextStyle(fontFamily: AppFont.light, fontSize: 17)),
        ));
  }

  Future showBottomSheetForSortingOptions(BuildContext context) {
    return Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 20, color: Color(0xFFde9292)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              commonText("newest".tr, "newest"),
              commonText("bestRatings".tr, "best_rating"),
              commonText("worstRating".tr, "worst_rating"),
            ],
          ),
        ),
      ),
    );
  }

  commonText(String text, String paramText) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: InkWell(
        onTap: () {
          _detailController.sortByReviewData(sorTing: paramText);
          _detailController.sortText.value = text;
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontFamily: AppFont.semiBold, fontSize: 18),
        ),
      ),
    );
  }

  Row rowline(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'customerReview'.tr,
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: AppFont.bold),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Get.to(FilterForReview());
          },
          child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xffdb8a8a),
              child: Image.asset(
                AssestPath.homeView + 'Group.png',
                height: 15,
                width: 15,
              )),
        ),
        SizedBox(
          width: 10,
        ),
        sort(context),
      ],
    );
  }

  Container sort(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        height: 30,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0) //                 <--- border radius here
              ),
          border: Border.all(
            width: 1.5,
            color: Color(0xFFe2e3e6),
          ),
        ),
        child: InkWell(
          onTap: () {
            return showBottomSheetForSortingOptions(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => SizedBox(
                  width: 56,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _detailController.sortText.value,
                      style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 13),
                    ),
                  ),
                ),
              ),
              Image.asset(
                AssestPath.homeView + "Sort.png",
                height: 10,
              )
            ],
          ),
        ));
  }

  Container ratingAndServices({String rating, String serviceName}) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 0, 10),
      child: Row(
        children: [
          Text(
            "$rating",
            style: TextStyle(color: Color(0xFFe29e9e), fontFamily: AppFont.regular),
          ),
          SizedBox(width: 20),
          Text(
            "$serviceName",
            style: TextStyle(color: Color(0xFF959396), fontFamily: AppFont.regular),
          ),
        ],
      ),
    );
  }

  RatingBar buildRatingBar(color, ind) {
    return RatingBar.builder(
      initialRating: double.parse(ind),
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      glowColor: Colors.white,
      ignoreGestures: true,
      itemSize: 40,
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
            color: Colors.white,
          ),
        );
      },
      onRatingUpdate: (value) {},
    );
  }

  Widget reviewCard(CustomerReview data, int index) {
    List<String> name = ['serviceStaff'.tr, 'Ambiance'.tr, 'priceprefoma'.tr, 'waitingPeriod'.tr, 'atmosphere'.tr];
    List<double> rating = [
      double.parse(data.serviceRate),
      double.parse(data.ambiente),
      double.parse(data.preieLeistungsRate),
      double.parse(data.wartezeit),
      double.parse(data.atmosphare)
    ];
    print(data.createdAt);
    print(data.dayAgo);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Container(
        // height: 500,
        width: Get.width,
        decoration: BoxDecoration(color: Color(AppColor.bgColor), borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: data.userImagePath == null
                              ? noProfilePicNames(data.noProfilcePicData)
                              : CachedNetworkImage(
                                  imageUrl: data.userImagePath,
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF101928),
                                      borderRadius: BorderRadius.circular(25),
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
                                      borderRadius: BorderRadius.circular(25),
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
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.userName == " " ? " - " : data.userName,
                              style: TextStyle(fontSize: 17, fontFamily: AppFont.medium),
                            ),
                            data.empName == ""
                                ? SizedBox()
                                : Text(
                                    'serviceBy'.tr + data.empName,
                                    style: TextStyle(fontSize: 10, fontFamily: AppFont.regular),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      spacing: 2,
                      children: [
                        Container(
                          height: 28,
                          width: 53,
                          decoration: BoxDecoration(color: Color(AppColor.starContainer), borderRadius: BorderRadius.circular(8)),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  height: 24,
                                  width: 22,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color(AppColor.starContainer),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(27, 7, 0, 0),
                                child: Text(
                                  data.totalAvgRating,
                                  style: TextStyle(fontSize: 14, color: Color(AppColor.logoBgColor), fontFamily: AppFont.medium),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          data.dayAgo,
                          style: TextStyle(fontSize: 11, fontFamily: AppFont.regular),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 40,
                width: Get.width,
                decoration: BoxDecoration(color: Color(AppColor.maincategorySelectedColor), borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Text(
                  data.serviceName,
                  style: TextStyle(color: Color(AppColor.maincategorySelectedTextColor), fontSize: 12, fontFamily: AppFont.medium),
                )),
              ),
              SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.writeComment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontFamily: AppFont.medium),
                  ),
                  Visibility(
                    visible: data.storeReplay != null,
                    child: Container(
                      padding: EdgeInsets.only(top: 15),
                      child: InkWell(
                        onTap: () {
                          _detailController.storeReviewObj.value.customerReview[index].isOpenReplay.value =
                              !_detailController.storeReviewObj.value.customerReview[index].isOpenReplay.value;
                        },
                        child: Row(
                          children: [
                            Text(
                              'venueReplay'.tr,
                              style: TextStyle(fontSize: 12, fontFamily: AppFont.regular, color: Colors.grey),
                            ),
                            Obx(() => Icon(data.isOpenReplay.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Colors.grey, size: 18))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Obx(
                    () => Visibility(
                      visible: data.isOpenReplay.value,
                      child: Text(
                        data.storeReplay ?? " ",
                        style: TextStyle(fontSize: 13, fontFamily: AppFont.regular, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      _detailController.storeReviewObj.value.customerReview[index].isOpen.value = !_detailController.storeReviewObj.value.customerReview[index].isOpen.value;
                    },
                    child: Row(
                      children: [
                        Text(
                          'showFullRatings'.tr,
                          style: TextStyle(fontSize: 12, fontFamily: AppFont.regular, color: Color(AppColor.maincategorySelectedTextColor)),
                        ),
                        Obx(() => Icon(data.isOpen.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Color(AppColor.maincategorySelectedTextColor), size: 20))
                      ],
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: data.isOpen.value,
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0, mainAxisExtent: 50),
                            itemCount: name.length,
                            itemBuilder: (context, ind) {
                              return reviewList(name[ind], rating[ind]);
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noProfilePicNames(String username) {
    List<String> strList = username.split(' ');
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: Color(0xFFFABA5F), width: 0.3), color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Align(
            alignment: Alignment.center,
            child: username != null
                ? Text(
                    username == ' ' || username == ' '
                        ? "-"
                        : username.contains(" ")
                            ? username.split(" ").first.toString()[0].toUpperCase() + username.split(" ").last.toString()[0].toUpperCase()
                            : username[0].toString().toUpperCase() + username[1].toString().toUpperCase(),
                    style: TextStyle(color: Color(0xFFFABA5F), fontFamily: AppFont.medium, fontSize: 15),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "",
                    style: TextStyle(color: Color(0xFFFABA5F), fontFamily: AppFont.medium, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }

  Widget reviewList(String text, double ratingValue) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(AppColor.reviewContainer)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: ratingValue,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              glowColor: Colors.white,
              ignoreGestures: true,
              itemSize: 15,
              unratedColor: Color(0xFFdadbde),
              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
              itemBuilder: (context, index) {
                return Container(
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    AssestPath.homeView + "Star.png",
                    height: 18,
                    width: 18,
                  ),
                );
              },
              onRatingUpdate: (value) {},
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(fontSize: 10, fontFamily: AppFont.medium),
            )
          ],
        ),
      ),
    );
  }
}
