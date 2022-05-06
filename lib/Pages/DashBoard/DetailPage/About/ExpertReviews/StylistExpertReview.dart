import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/About/ExpertReviews/StylistExpertReviewController.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/About/ExpertReviews/StylistExpertReviewModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsModel.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/ProceedToPayController.dart';

// ignore: must_be_immutable
class StylistExpertReview extends StatelessWidget {
  StylistExpertReviewController _stylistExpertReviewController = Get.put(StylistExpertReviewController());
  ProceedToPayController _proceedToPayController = Get.put(ProceedToPayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      color: Color(0xFFf6f6fa),
                      child: Column(
                        children: [
                          Obx(
                            () => employeeReview(),
                          ),
                          Obx(
                            () => _stylistExpertReviewController.arrExpertReviewObj.value.length == 0
                                ? Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Text(
                                      'noDataFound'.tr,
                                      style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _stylistExpertReviewController.arrExpertReviewObj.value.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var currentObject = _stylistExpertReviewController
                                          // ignore: invalid_use_of_protected_member
                                          .arrExpertReviewObj
                                          // ignore: invalid_use_of_protected_member
                                          .value[index];
                                      print(_stylistExpertReviewController
                                          // ignore: invalid_use_of_protected_member
                                          .arrExpertReviewObj
                                          // ignore: invalid_use_of_protected_member
                                          .value
                                          .length);
                                      return reviewCard(currentObject, index);
                                    },
                                  ),
                          )
                        ],
                      )),
                ],
              ),
              Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _stylistExpertReviewController.isLoader.value)),
            ],
          ),
        ),
      ),
    );
  }

  //========== Header ==========
  AppBar headerAppbar() {
    return AppBar(
      backgroundColor: Color(AppColor.bgColor),
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          height: 35.0,
          width: 35.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Get.back();
            },
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'stylistExpertReview'.tr,
        style: TextStyle(fontFamily: AppFont.medium, fontSize: 20, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget header() {
    return Container(
      height: 60,
      width: Get.width,
      color: Color(AppColor.bgColor),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, offset: Offset(1, 1), blurRadius: 7)],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21)),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  onPressed: () {
                    Get.back();
                  },
                  iconSize: 20,
                )),
          ),
          SizedBox(width: 50),
          Text(
            'stylistExpertReview'.tr,
            style: TextStyle(fontFamily: AppFont.medium, fontSize: 20),
          )
        ],
      ),
    );
  }

  //========== Staff Review ==========

  Widget employeeReview() {
    return Container(
      height: 151,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), color: Color(AppColor.bgColor)),
      child: ListView.builder(
        itemBuilder: (context, index) {
          var currentObj = _stylistExpertReviewController.arrServiceExpert[index];
          return InkWell(
              onTap: () {
                _stylistExpertReviewController.selectedEmployeId.value = currentObj.id;
                _stylistExpertReviewController.getStylistExpertReviewData();
              },
              child: Container(width: 90, child: stylistReview(currentObj)));
        },
        // ignore: invalid_use_of_protected_member
        itemCount: _stylistExpertReviewController.arrServiceExpert.value.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
      ),
    );
  }

  //========== Tab Container ==========

  Widget tabContainer() {
    return Container(
      height: 1,
      width: 80,
      color: Colors.pink,
    );
  }

  //========== Review card ==========

  Widget reviewCard(StylistExpertReviewModel data, int index) {
    List<String> name = ['serviceStaff'.tr, 'Ambiance'.tr, 'priceprefoma'.tr, 'waitingPeriod'.tr, 'atmosphere'.tr];
    List<String> rating = [
      data.serviceRate,
      data.ambiente,
      data.preieLeistungsRate,
      data.wartezeit,
      data.atmosphare,
    ];
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
                        data.userImage == null
                            ? noProfilePicNames(data.noProfilcePicData)
                            : /*Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25), image: DecorationImage(image: NetworkImage(data.userImage.toString()), fit: BoxFit.cover)),
                              ),*/
                            Container(
                                height: 50,
                                width: 50,
                                child: CachedNetworkImage(
                                  imageUrl: data.userImage.toString(),
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
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
                              data.userName.trim().isEmpty ? "-" : data.userName,
                              style: TextStyle(fontSize: 17, fontFamily: AppFont.medium),
                            ),
                            Text(
                              data.empName == "" ? 'serviceBy'.tr + 'anyPerson'.tr : 'serviceBy'.tr + data.empName,
                              style: TextStyle(fontSize: 10, fontFamily: AppFont.regular),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
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
                          _stylistExpertReviewController.arrExpertReviewObj[index].isOpenReplay.value =
                              !_stylistExpertReviewController.arrExpertReviewObj[index].isOpenReplay.value;
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
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _stylistExpertReviewController.arrExpertReviewObj[index].isOpen.value = !_stylistExpertReviewController.arrExpertReviewObj[index].isOpen.value;
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
                        child: GridView.builder(
                            padding: EdgeInsets.only(top: 10),
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
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white, width: 3), color: Colors.black),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            username,
            style: TextStyle(color: Color(0xFFFABA5F), fontFamily: AppFont.medium, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  //========== List View ==========

  Widget reviewList(String text, String ratingValue) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(AppColor.reviewContainer)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: double.parse(ratingValue),
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
            ),
          ],
        ),
      ),
    );
  }

//========== Stylist Review ==========

  Widget stylistReview(OurServiceExpert currentObj) {
    List<String> nameList = currentObj.empName.split(' ');
    String name = '';
    if (nameList.length == 2) {
      name = nameList.first[0].toUpperCase() + nameList.last[0].toUpperCase();
    } else {
      name = nameList.first[0].toUpperCase() + nameList.first[1].toUpperCase();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        children: [
          currentObj.empImagePath == null
              ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(width: 1.5, color: Colors.grey)),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFdb8a8a),
                      ),
                    ),
                  ),
                )
              : /*Container(
                  //   padding: EdgeInsets.all(10),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(image: NetworkImage(currentObj.empImagePath), fit: BoxFit.cover)),
                ),*/
              Container(
                  height: 60,
                  width: 60,
                  child: CachedNetworkImage(
                    imageUrl: currentObj.empImagePath,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 8),
          Text(
            currentObj.empName,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontFamily: AppFont.bold),
          ),
          SizedBox(height: 8),
          Container(
            height: 25,
            width: 50,
            decoration: BoxDecoration(color: Color(AppColor.starContainer), borderRadius: BorderRadius.circular(6)),
            child: Stack(
              children: [
                Positioned(
                  top: 3,
                  left: 2,
                  child: Container(
                    height: 20,
                    width: 20,
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
                    currentObj.avgRating,
                    style: TextStyle(fontSize: 12, color: Color(AppColor.logoBgColor), fontFamily: AppFont.medium),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Obx(() => Visibility(
                visible: currentObj.id == _stylistExpertReviewController.selectedEmployeId.value ? true : false,
                child: tabContainer(),
              ))
        ],
      ),
    );
  }
}
